<template>
  <nav
    class="border-t border-gray-200 px-4 flex items-center justify-between sm:px-0"
  >
    <div class="-mt-px w-0 flex-1 flex">
      <button
        class="border-t-2 border-transparent pt-4 pr-1 inline-flex items-center text-sm font-medium text-gray-700 hover:text-gray-900 hover:border-gray-300 disabled:text-gray-500 disabled:hover:border-transparent"
        :disabled="page === 1"
        @click="handleNav(page - 1)"
      >
        <!-- Heroicon name: solid/arrow-narrow-left -->
        <svg
          class="mr-3 h-5 w-5 text-gray-400"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
          fill="currentColor"
          aria-hidden="true"
        >
          <path
            fill-rule="evenodd"
            d="M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z"
            clip-rule="evenodd"
          />
        </svg>
        Previous
      </button>
    </div>
    <div class="md:-mt-px md:flex">{{ page }} of {{ lastPage }}</div>
    <div class="-mt-px w-0 flex-1 flex justify-end">
      <button
        href="#"
        class="border-t-2 border-transparent pt-4 pl-1 inline-flex items-center text-sm font-medium text-gray-700 hover:text-gray-900 hover:border-gray-300 disabled:text-gray-500 disabled:hover:border-transparent"
        :disabled="page === lastPage"
        @click="handleNav(page + 1)"
      >
        Next
        <!-- Heroicon name: solid/arrow-narrow-right -->
        <svg
          class="ml-3 h-5 w-5 text-gray-400"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
          fill="currentColor"
          aria-hidden="true"
        >
          <path
            fill-rule="evenodd"
            d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z"
            clip-rule="evenodd"
          />
        </svg>
      </button>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'PaginationComponent',
  props: {
    page: {
      type: Number,
      required: true,
    },
    total: {
      type: Number,
      required: true,
    },
    limit: {
      type: Number,
      required: true,
    },
  },
  computed: {
    lastPage() {
      return Math.ceil(this.total / this.limit)
    },
  },
  methods: {
    handleNav(page) {
      this.$emit('page', page)
    },
  },
}
</script>
