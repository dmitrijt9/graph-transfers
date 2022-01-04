<template>
  <header class="bg-indigo-600">
    <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" aria-label="Top">
      <div
        class="w-full py-6 flex items-center justify-between border-b border-indigo-500 lg:border-none"
      >
        <div class="flex items-center">
          <NuxtLink to="/">
            <span class="text-xl text-white underline">Graph Transfers</span>
          </NuxtLink>
          <div class="hidden ml-10 space-x-8 lg:block">
            <NuxtLink
              to="/transfers"
              class="text-base font-medium text-white hover:text-indigo-50"
              key="Transfers"
            >
              All transfers
            </NuxtLink>
          </div>
        </div>
        <div class="ml-10 space-x-4">
          <a
            href="https://github.com/dmitrijt9/graph-transfers"
            class="flex items-center gap-2 bg-indigo-500 py-2 px-4 border border-transparent rounded-md text-base font-medium text-white hover:bg-opacity-75"
          >
            <Icon name="github" class="h-5 w-5" />
            Github
          </a>
        </div>
      </div>
      <div class="py-4 flex flex-wrap justify-center space-x-6 lg:hidden">
        <NuxtLink
          to="/transfers"
          class="text-base font-medium text-white hover:text-indigo-50"
          key="Transfers"
        >
          All transfers
        </NuxtLink>
      </div>
    </nav>
  </header>
</template>
