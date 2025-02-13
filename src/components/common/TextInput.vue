<template>
  <div class="relative">
    <XMarkIcon
      v-if="beforeClose && clearable"
      class="absolute right-2 top-1/2 z-10 h-3 w-3 -translate-y-1/2 cursor-pointer"
      @click="clearInput"
    />
    <input
      v-model="inputValue"
      type="text"
      :class="['input input-sm join-item input-bordered w-full', { 'pr-6': clearable }]"
      :placeholder="placeholder || ''"
      :name="name || ''"
      :autocomplete="autocomplete || ''"
    />
    <XMarkIcon
      v-if="!beforeClose && clearable"
      class="absolute right-2 top-1/2 z-10 h-3 w-3 -translate-y-1/2 cursor-pointer"
      @click="clearInput"
    />
  </div>
</template>

<script lang="ts" setup>
import { XMarkIcon } from '@heroicons/vue/24/outline'

defineProps<{
  placeholder?: string
  beforeClose?: boolean
  name?: string
  autocomplete?: string
  clearable?: boolean
}>()

const inputValue = defineModel<string>()
const clearInput = () => {
  inputValue.value = ''
}
</script>
