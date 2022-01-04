<template>
  <div class="bg-white shadow overflow-hidden sm:rounded-lg">
    <div class="px-4 py-5 sm:px-6">
      <h3 class="text-xl leading-6 font-medium text-gray-900">
        {{ player.name }}
      </h3>
      <p class="mt-1 max-w-2xl text-sm text-gray-500">
        Basic info about the player.
      </p>
    </div>
    <div class="border-t border-gray-200 px-4 py-5 sm:px-6">
      <dl class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-3">
        <div class="sm:col-span-1">
          <dt class="text-sm font-medium text-gray-500">Full name</dt>
          <dd class="mt-1 text-sm text-gray-900">{{ player.name }}</dd>
        </div>
        <div class="sm:col-span-1">
          <dt class="text-sm font-medium text-gray-500">Age</dt>
          <dd class="mt-1 text-sm text-gray-900">{{ player.age }}</dd>
        </div>
        <div class="sm:col-span-1">
          <dt class="text-sm font-medium text-gray-500">Position</dt>
          <dd class="mt-1 text-sm text-gray-900">{{ player.position }}</dd>
        </div>
        <div class="sm:col-span-3">
          <dt class="text-sm font-medium text-gray-500">All transfers</dt>
          <dd class="mt-2 text-sm text-gray-900">
            <div v-if="!transfers.length">No transfers yet</div>
            <ul
              v-else
              role="list"
              class="border border-gray-200 rounded-md divide-y divide-gray-200"
            >
              <li
                v-for="transfer in transfers"
                :key="`${transfer.from} + ${transfer.to} + '${transfer.fee}'`"
                class="pl-3 pr-4 py-3 grid grid-cols-1 gap-4 sm:grid-cols-5 text-sm"
              >
                <span class="flex items-center">
                  <Icon name="switch" class="h-6 w-6" />
                  <span class="ml-2 flex-1">
                    {{ transfer.season }}
                  </span>
                </span>
                <span>
                  {{ transfer.from }}
                </span>
                <span>
                  <Icon name="arrow-narrow-right" class="h-6 w-6" />
                </span>
                <span>
                  {{ transfer.to }}
                </span>
                <span> £{{ transfer.fee }} mil. </span>
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
    player: {
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
