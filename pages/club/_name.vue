<template>
  <div class="mt-8 mb-16">
    <club-card :club="club" :transfers="transfers" />
    <related-players class="mt-8" :players="relatedPlayers" />
    <related-clubs class="mt-8" :clubs="relatedClubs" />
  </div>
</template>

<script>
export default {
  async asyncData({ params, $neo4j, error }) {
    // would be better have an API for neo4j queries...do not have time before deadline
    const records = await $neo4j.query(
      `MATCH (c:Club { name: $clubName})-->(t:Transfer)<--(relatedPlayer:Player)
      MATCH (relatedClub:Club { league: c.league }) WHERE ID(c) <> ID(relatedClub)
      RETURN c,t,relatedPlayer,collect(relatedClub) as relatedClubs
      ORDER BY t.season DESC
      LIMIT 50`,
      {
        clubName: params.name,
      }
    )

    if (!records) {
      error({
        statusCode: 500,
        message: 'Something went wrong. Contact the author.',
      })

      return
    }

    let clubRecord = null
    const transferRecords = []
    const relatedPlayersRecords = []
    let relatedClubsRecords = []
    records.forEach((r) => {
      const club = r.get('c')
      const transfer = r.get('t')
      const relatedPlayer = r.get('relatedPlayer')
      if (relatedClubsRecords.length <= 0) {
        relatedClubsRecords = r.get('relatedClubs')
      }

      if (club !== null) {
        clubRecord = {
          id: club.identity.toNumber(),
          name: club.properties.name,
          league: club.properties.league,
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
          player: transfer.properties.playerName,
        })
      }

      if (relatedPlayer !== null) {
        relatedPlayersRecords.push({
          id: relatedPlayer.identity.toNumber(),
          name: relatedPlayer.properties.name,
          position: relatedPlayer.properties.position,
          age: relatedPlayer.properties.age.toNumber(),
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
    relatedClubsRecords
      .map((cr) => {
        return {
          id: cr.identity.toNumber(),
          name: cr.properties.name,
          league: cr.properties.league,
        }
      })
      .forEach((rc) => {
        const duplicate = deduplicatedRelatedClubs.find((c) => c.id === rc.id)
        if (!duplicate) {
          deduplicatedRelatedClubs.push(rc)
        }
      })

    return {
      club: clubRecord,
      transfers: deduplicatedTransfers,
      relatedPlayers: deduplicatedRelatedPlayers,
      relatedClubs: deduplicatedRelatedClubs,
    }
  },
}
</script>
