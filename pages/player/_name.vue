<template>
  <div class="my-8">
    <PlayerCard :player="player" :transfers="transfers" />
    <related-players class="mt-8" :players="relatedPlayers" />
  </div>
</template>

<script>
export default {
  async asyncData({ params, $neo4j, error }) {
    // would be better have an API for neo4j queries...do not have time before deadline
    const records = await $neo4j.query(
      `MATCH (p:Player { name: $playerName})-[:INVOLVED_IN]->(t:Transfer)
      MATCH (relatedPlayer:Player)-[:INVOLVED_IN]->(:Transfer {club: t.club})
      WITH p,t,relatedPlayer, size((relatedPlayer)-->(:Transfer {club: t.club})) AS count
      WHERE count > 1
      RETURN p,t,count, relatedPlayer
      ORDER BY t.season
      LIMIT 30`,
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
    records.forEach((r) => {
      const player = r.get('p')
      const transfer = r.get('t')
      const relatedPlayer = r.get('relatedPlayer')
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
        const count = r.get('count')
        relatedPlayersRecords.push({
          weight: count.toNumber(),
          id: relatedPlayer.identity.toNumber(),
          name: relatedPlayer.properties.name,
          position: relatedPlayer.properties.position,
          age: relatedPlayer.properties.age.toNumber(),
        })
      }
    })

    const deduplicatedTransfers = []
    const deduplicatedRelatedPlayers = []

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

    return {
      player: playerRecord,
      transfers: deduplicatedTransfers.sort((a, b) => a.season <= b.season),
      relatedPlayers: deduplicatedRelatedPlayers,
    }
  },
}
</script>
