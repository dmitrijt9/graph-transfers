<template>
  <div class="mt-8 mb-16">
    <PlayerCard :player="player" :transfers="transfers" />
    <related-players class="mt-8" :players="relatedPlayers" />
    <related-clubs class="mt-8" :clubs="relatedClubs" />
  </div>
</template>

<script>
export default {
  async asyncData({ params, $neo4j, error }) {
    // would be better have an API for neo4j queries...do not have time before deadline
    const records = await $neo4j.query(
      `MATCH (p:Player { name: $playerName})-[:INVOLVED_IN]->(t:Transfer)
      MATCH (relatedClub:Club { name: t.club })
      CALL {
        WITH t,p
        MATCH (relatedPlayer:Player)--(:Club {name: t.club})
        WITH t,size((relatedPlayer)--(:Club {name: t.club})) AS relatedPlayerCount,relatedPlayer
        WHERE apoc.text.levenshteinSimilarity(p.position, relatedPlayer.position) > 0.4 AND ID(relatedPlayer) <> ID(p)
        RETURN relatedPlayerCount,relatedPlayer
        ORDER BY relatedPlayerCount DESC
      }
      WITH relatedClub,p,t,relatedPlayer,relatedPlayerCount
      RETURN p,t,relatedPlayerCount,relatedPlayer,relatedClub
      ORDER BY t.season DESC`,
      {
        playerName: params.name,
      }
    )

    if (!records) {
      error({
        statusCode: 500,
        message: 'Something went wrong. Contact the author.',
      })

      return
    }

    let playerRecord = null
    const transferRecords = []
    const relatedPlayersRecords = []
    const relatedClubsRecords = []
    records.forEach((r) => {
      const player = r.get('p')
      const transfer = r.get('t')
      const relatedPlayer = r.get('relatedPlayer')
      const relatedClub = r.get('relatedClub')

      if (player !== null) {
        playerRecord = {
          id: player.identity.toNumber(),
          name: player.properties.name,
          position: player.properties.position,
          age: player.properties.age.toNumber(),
        }
      }

      if (transfer !== null) {
        const movement = transfer.properties.movement
        transferRecords.push({
          id: transfer.identity.toNumber(),
          from:
            movement === 'in'
              ? transfer.properties.clubInvolved
              : transfer.properties.club,
          to:
            movement === 'in'
              ? transfer.properties.club
              : transfer.properties.clubInvolved,
          season: transfer.properties.season,
          fee: transfer.properties.fee ?? 'Free',
        })
      }

      if (relatedPlayer !== null) {
        const count = r.get('relatedPlayerCount')
        relatedPlayersRecords.push({
          weight: count.toNumber(),
          id: relatedPlayer.identity.toNumber(),
          name: relatedPlayer.properties.name,
          position: relatedPlayer.properties.position,
          age: relatedPlayer.properties.age.toNumber(),
        })
      }

      if (relatedClub !== null) {
        relatedClubsRecords.push({
          id: relatedClub.identity.toNumber(),
          name: relatedClub.properties.name,
          league: relatedClub.properties.league,
        })
      }
    })

    const deduplicatedTransfers = []
    const deduplicatedRelatedPlayers = []
    const deduplicatedRelatedClubs = []

    transferRecords.forEach((t) => {
      const duplicate = deduplicatedTransfers.find(
        (d) => t.season === d.season && t.fee === d.fee
      )
      if (!duplicate) {
        deduplicatedTransfers.push(t)
      }
    })
    relatedPlayersRecords.forEach((rp) => {
      const duplicate = deduplicatedRelatedPlayers.find((p) => p.id === rp.id)
      if (!duplicate) {
        deduplicatedRelatedPlayers.push(rp)
      }
    })
    relatedClubsRecords.forEach((rc) => {
      const duplicate = deduplicatedRelatedClubs.find((c) => c.id === rc.id)
      if (!duplicate) {
        deduplicatedRelatedClubs.push(rc)
      }
    })

    return {
      player: playerRecord,
      transfers: deduplicatedTransfers,
      relatedPlayers: deduplicatedRelatedPlayers,
      relatedClubs: deduplicatedRelatedClubs,
    }
  },
}
</script>
