<template>
  <div>
    <main class="mt-16 mx-auto max-w-7xl px-4 sm:mt-24">
      <div class="text-center">
        <h1
          class="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl md:text-6xl"
        >
          <span class="block xl:inline">Graph</span>
          <span class="block text-indigo-600 xl:inline"> transfers</span>
        </h1>
        <p
          class="mt-3 max-w-md mx-auto text-base text-gray-500 sm:text-lg md:mt-5 md:text-xl md:max-w-3xl"
        >
          Search football players and teams and lookup for their transfer
          activity in top European football leagues.
        </p>
        <div class="mt-5 max-w-md mx-auto sm:flex sm:justify-center md:mt-8">
          <form class="w-full sm:mx-auto lg:mx-0" @submit.prevent="search">
            <div class="sm:flex">
              <div class="min-w-0 flex-1">
                <label for="query" class="sr-only">Search</label>
                <input
                  id="query"
                  v-model="searchQuery"
                  type="text"
                  placeholder="Search a player or a team"
                  class="block w-full shadow px-4 py-3 rounded-md border-0 text-base text-black placeholder-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-300 focus:ring-offset-gray-900"
                />
              </div>
              <div class="mt-3 sm:mt-0 sm:ml-3">
                <button
                  type="submit"
                  class="block w-full py-3 px-4 rounded-md shadow bg-indigo-500 text-white font-medium hover:bg-indigo-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-300 focus:ring-offset-gray-900"
                >
                  Search
                </button>
              </div>
            </div>
          </form>
        </div>
        <div class="mt-8 max-w-3xl mx-auto">
          <div v-if="loading" class="flex justify-center"><Loader /></div>
          <div v-else-if="isResult" class="flex flex-col gap-4">
            <NuxtLink
              v-for="player in playerResults"
              :key="player.name"
              :to="{
                name: 'player-name',
                params: { name: player.name },
              }"
              class="bg-gray-100 px-3 py-5 rounded-md hover:-translate-y-1 hover:shadow transition-all ease-linear duration-100"
            >
              {{ player.name }}, {{ player.position }}
            </NuxtLink>
            <div
              v-if="clubResults.length && playerResults.length"
              class="w-full h-1 border-t border-indigo-600"
            />
            <NuxtLink
              v-for="club in clubResults"
              :key="club.name"
              to="/"
              class="bg-gray-100 px-3 py-5 rounded-md hover:-translate-y-1 hover:shadow transition-all ease-linear duration-100"
            >
              {{ club.name }}, {{ club.league }}
            </NuxtLink>
          </div>
          <div v-else-if="noResult">No results for this query.</div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
export default {
  name: 'IndexPage',
  data() {
    return {
      searchQuery: '',
      playerResults: [],
      clubResults: [],
      loading: false,
      noResult: false,
    }
  },
  computed: {
    isResult() {
      return this.playerResults.length || this.clubResults.length
    },
  },
  methods: {
    async search() {
      this.loading = true
      const query =
        this.searchQuery.charAt(0).toUpperCase() + this.searchQuery.slice(1)
      // would be better have an API for neo4j queries...do not have time before deadline
      const records = await this.$neo4j.query(
        `
          OPTIONAL MATCH (p:Player) WHERE p.name CONTAINS $query 
          OPTIONAL MATCH (c:Club) WHERE c.name CONTAINS $query
          RETURN c, p LIMIT 10
        `,
        {
          query,
        }
      )
      const flatRecords = []
      records.forEach((r) => {
        const player = r.get('p')
        const club = r.get('c')
        if (player !== null) {
          flatRecords.push(player)
        }
        if (club !== null) {
          flatRecords.push(club)
        }
      })
      this.playerResults = flatRecords
        .filter((r) => r.labels[0] === 'Player')
        .map((p) => {
          return {
            id: p.identity.toNumber(),
            name: p.properties.name,
            position: p.properties.position,
            age: p.properties.age.toNumber(),
          }
        })
      this.clubResults = flatRecords
        .filter((r) => r.labels[0] === 'Club')
        .map((c) => {
          return {
            id: c.identity.toNumber(),
            name: c.properties.name,
            league: c.properties.league,
          }
        })
      this.loading = false
      if (!this.isResult) {
        this.noResult = true
      }
    },
  },
}
</script>
