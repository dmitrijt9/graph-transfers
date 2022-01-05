<template>
  <div class="bg-white shadow overflow-hidden sm:rounded-lg">
    <div class="px-4 py-5 sm:px-6">
      <h2 class="text-2xl leading-6 font-medium text-indigo-500">
        {{ club.name }}
      </h2>
      <p class="mt-1 max-w-2xl text-sm text-gray-500">
        {{ club.league }}
      </p>
    </div>
    <div class="border-t border-gray-200 px-4 py-5 sm:px-6">
      <dl>
        <div>
          <dt class="text-sm font-medium text-gray-500">Latest transfers</dt>
          <dd class="mt-2 text-sm text-gray-900">
            <div v-if="!transfers.length">No transfers yet</div>
            <ul
              v-else
              role="list"
              class="border border-gray-200 rounded-md divide-y divide-gray-200"
            >
              <li
                v-for="transfer in transfers"
                :key="transfer.id"
                class="pl-3 pr-4 py-3 grid grid-cols-1 gap-4 sm:grid-cols-6 text-sm"
              >
                <span class="flex items-center">
                  <Icon name="switch" class="h-6 w-6" />
                  <span class="ml-2 flex-1">
                    {{ transfer.season }}
                  </span>
                </span>
                <span>
                  {{ transfer.player }}
                </span>
                <span
                  :class="{ 'text-indigo-500': transfer.from === club.name }"
                >
                  {{ transfer.from }}
                </span>
                <span>
                  <Icon
                    name="arrow-narrow-right"
                    class="h-6 w-6 text-indigo-500"
                  />
                </span>
                <span :class="{ 'text-indigo-500': transfer.to === club.name }">
                  {{ transfer.to }}
                </span>
                <span
                  v-if="transfer.fee !== 'Free'"
                  :class="{
                    'text-green-600': club.name === transfer.from,
                    'text-red-600': club.name === transfer.to,
                  }"
                >
                  £{{ transfer.fee }} mil.
                </span>
                <span v-else>
                  {{ transfer.fee }}
                </span>
              </li>
            </ul>
          </dd>
        </div>
      </dl>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    club: {
      type: Object,
      required: true,
    },
    transfers: {
      type: Array,
      default: () => [],
    },
  },
}
</script>
