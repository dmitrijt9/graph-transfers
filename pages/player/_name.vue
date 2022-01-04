<template>
  <div class="my-8">
    <PlayerCard :player="player" :transfers="transfers" />
  </div>
</template>

<script>
export default {
  async asyncData({ params, $neo4j }) {
    // would be better have an API for neo4j queries...do not have time before deadline
    const records = await $neo4j.query(
      `MATCH (p:Player { name: $playerName})-[r:INVOLVED_IN]->(t:Transfer) RETURN p,t ORDER BY t.season`,
      {
        playerName: params.name,
      }
    )

    const flatRecords = []
    records.forEach((r) => {
      const player = r.get('p')
      const transfer = r.get('t')
      if (player !== null) {
        flatRecords.push(player)
      }
      if (transfer !== null) {
        flatRecords.push(transfer)
      }
    })

    const player = flatRecords
      .filter((r) => r.labels[0] === 'Player')
      .map((p) => {
        return {
          name: p.properties.name,
          position: p.properties.position,
          age: p.properties.age.toNumber(),
        }
      })[0]

    const transfers = flatRecords
      .filter((r) => r.labels[0] === 'Transfer')
      .map((t) => {
        console.log(t)
        const movement = t.properties.movement
        return {
          from:
            movement === 'in' ? t.properties.clubInvolved : t.properties.club,
          to: movement === 'in' ? t.properties.club : t.properties.clubInvolved,
          season: t.properties.season,
          fee: t.properties.fee ?? 'Free',
        }
      })
      .sort((a, b) => a.season <= b.season)

    const deduplicatedTransfers = []

    transfers.forEach((t) => {
      const duplicate = deduplicatedTransfers.find(
        (d) => t.season === d.season && t.fee === d.fee
      )
      if (!duplicate) {
        deduplicatedTransfers.push(t)
      }
    })

    return {
      player,
      transfers: deduplicatedTransfers,
    }
  },
}
</script>
