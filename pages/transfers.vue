<template>
  <div class="my-8">
    <h1 class="text-2xl">All transfers</h1>
    <Transfers
      class="mt-4"
      :transfers="transfers"
      :pagination="pagination"
      @season="handleSeason"
    />
  </div>
</template>

<script>
import { int } from 'neo4j-driver'
export default {
  // async asyncData() {
  //   return {
  //     transfers: await this.fetchTransfers()
  //   }
  // },
  data() {
    return {
      pagination: {
        skip: 0,
        limit: 20,
        total: 0,
        filter: {
          season: '2020/2021',
        },
      },
    }
  },
  methods: {
    handleSeason(season) {
      this.pagination.filter.season = season
    },
    async fetchTransfers() {
      // would be better have an API for neo4j queries...do not have time before deadline
      const records = await this.$neo4j.query(
        `MATCH (t:Transfer)
        WHERE t.season=$season
        WITH collect(t) as transfers, count(distinct t) as total
        UNWIND transfers as t
        RETURN t.club AS club, t.clubInvolved AS clubInvolved, t.movement AS movement, t.fee AS fee, t.playerName AS player, total
        SKIP $skip LIMIT $limit`,
        {
          season: this.pagination.filter.season,
          skip: int(this.pagination.skip),
          limit: int(this.pagination.limit),
        }
      )

      this.pagination.total = int(records[0].get('total')).toNumber()

      return records.map((r) => {
        return {
          club: r.get('club'),
          clubInvolved: r.get('clubInvolved'),
          movement: r.get('movement'),
          fee: r.get('fee'),
          player: r.get('player'),
        }
      })
    },
  },
}
</script>
