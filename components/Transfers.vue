<template>
  <div class="overflow-hidden">
    <div class="flex flex-wrap gap-3">
      <div>
        <label for="season" class="block text-sm font-medium text-gray-700"
          >Season</label
        >
        <select
          id="season"
          name="season"
          class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"
          :value="pagination.filter.season"
          @change="handleSeasonSelect"
        >
          <option>2017/2018</option>
          <option>2018/2019</option>
          <option>2019/2020</option>
          <option>2020/2021</option>
        </select>
      </div>
    </div>
    <div class="mt-4 flex flex-col overflow-auto">
      <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
          <div
            class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg"
          >
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Player
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    From
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    To
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Fee (mil. £)
                  </th>
                  <th scope="col" class="relative px-6 py-3">
                    <span class="sr-only">Show Player</span>
                  </th>
                </tr>
              </thead>
              <tbody>
                <!-- Odd row -->
                <tr
                  v-for="(t, i) in transfers"
                  :key="t.player + t.fee + t.club"
                  :class="(i + 1) % 2 === 0 ? 'bg-gray-50' : 'bg-white'"
                >
                  <td
                    class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"
                  >
                    {{ t.player }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ t.movement === 'in' ? t.clubInvolved : t.club }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ t.movement === 'in' ? t.club : t.clubInvolved }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ t.fee }}
                  </td>
                  <td
                    class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium"
                  >
                    <a href="#" class="text-indigo-600 hover:text-indigo-900"
                      >Show Player</a
                    >
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <Pagination
        :total="pagination.total"
        :limit="pagination.limit"
        :page="currentPage"
        class="mt-4"
      />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    transfers: {
      type: Array,
      default: () => [],
    },
    pagination: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      currentPage: 1,
    }
  },
  methods: {
    handleSeasonSelect(e) {
      this.$emit('season', e.target.value)
    },
  },
}
</script>
