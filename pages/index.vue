<template>
  <div>
    <main class="mt-16 mb-8 mx-auto max-w-7xl px-4 sm:mt-24">
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
          <form class="w-full sm:mx-auto lg:mx-0" @submit.prevent>
            <div class="sm:flex">
              <div class="min-w-0 flex-1">
                <label for="query" class="sr-only">Search</label>
                <input
                  id="query"
                  v-model="searchQuery"
                  type="text"
                  placeholder="Start typing to search a player or a team"
                  autocomplete="off"
                  class="block w-full shadow px-4 py-3 bg-gray-100 rounded-md border-0 text-base text-black placeholder-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-indigo-300 focus:ring-offset-indigo-500"
                  @input="handleSearch"
                />
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
              :to="{
                name: 'club-name',
                params: { name: club.name },
              }"
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
  watch: {
    searchQuery(n) {
      if (n !== '') {
        this.noResult = true
      } else {
        this.noResult = false
      }
    },
  },
  methods: {
    handleSearch() {
      setTimeout(this.search, 400)
    },
    async search() {
      this.loading = true
      // would be better have an API for neo4j queries...do not have time before deadline
      const playerRecords = await this.$neo4j.query(
        `
          MATCH (p:Player) WHERE apoc.text.sorensenDiceSimilarity(p.name, $query) > 0.4
          RETURN p
          ORDER BY apoc.text.sorensenDiceSimilarity(p.name, $query) DESC
          LIMIT 5
        `,
        {
          query: this.searchQuery,
        }
      )
      const clubRecords = await this.$neo4j.query(
        `
          MATCH (c:Club) WHERE apoc.text.sorensenDiceSimilarity(c.name, $query) > 0.4
          RETURN c
          ORDER BY apoc.text.sorensenDiceSimilarity(c.name, $query) DESC
          LIMIT 5
        `,
        {
          query: this.searchQuery,
        }
      )

      this.playerResults = playerRecords
        .map((pr) => pr.get('p'))
        .filter((r) => r.labels[0] === 'Player')
        .map((p) => {
          return {
            id: p.identity.toNumber(),
            name: p.properties.name,
            position: p.properties.position,
            age: p.properties.age.toNumber(),
          }
        })
      this.clubResults = clubRecords
        .map((cr) => cr.get('c'))
        .filter((r) => r.labels[0] === 'Club')
        .map((c) => {
          return {
            id: c.identity.toNumber(),
            name: c.properties.name,
            league: c.properties.league,
          }
        })
      this.loading = false
    },
  },
}
</script>
