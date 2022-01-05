<template>
  <div class="bg-white shadow overflow-hidden sm:rounded-lg px-4 py-5 sm:px-6">
    <div>
      <h3 class="text-xl leading-6 font-medium">Related clubs</h3>
      <p class="mt-1 max-w-2xl text-sm text-gray-500">Most relevant clubs.</p>
    </div>
    <div v-if="!clubs.length">No related clubs</div>
    <div v-else class="w-full snap-x overflow-x-auto flex gap-5 relative py-4">
      <NuxtLink
        v-for="club in clubs"
        :key="club.id"
        :to="{ name: 'club-name', params: { name: club.name } }"
        class="snap-start scroll-mx-2 shrink-0 max-w-sm bg-gray-100 p-4 shadow rounded-md flex flex-col gap-2 hover:shadow-md hover:-translate-y-1 transition-all duration-100 ease-linear"
      >
        <div class="text-lg text-indigo-500 font-semibold">
          {{ club.name }}
        </div>
        <div class="text-base">{{ club.league }}</div>
      </NuxtLink>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    clubs: {
      type: Array,
      default: () => [],
    },
  },
}
</script>
