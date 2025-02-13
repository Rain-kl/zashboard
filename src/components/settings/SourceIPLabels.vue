<template>
  <div>{{ $t('sourceIPLabels') }}</div>
  <div class="flex flex-col gap-2 p-1 pr-0">
    <Draggable
      class="flex flex-1 flex-col gap-2"
      v-model="sourceIPLabelList"
      group="list"
      :animation="150"
      :handle="'.drag-handle'"
      :item-key="'uuid'"
      @start="disableSwipe = true"
      @end="disableSwipe = false"
    >
      <template #item="{ element: { id, key, label } }">
        <div
          :key="id"
          class="flex items-center gap-2"
        >
          <ChevronUpDownIcon class="drag-handle h-4 w-4 shrink-0 cursor-grab" />
          <input
            class="input input-sm input-bordered w-36 sm:w-64"
            :value="key"
            @input="(e) => handlerLabelKeyChange(e, id, 'key')"
            @click="handlerIPInputFocus"
          />
          <ArrowRightCircleIcon class="h-4 w-4 shrink-0" />
          <input
            class="input input-sm input-bordered w-0 max-w-40 flex-1"
            :value="label"
            @input="(e) => handlerLabelKeyChange(e, id, 'label')"
          />
          <button
            class="btn btn-circle btn-sm"
            @click="() => handlerLabelRemove(id)"
          >
            <XMarkIcon class="h-4 w-4" />
          </button>
        </div>
      </template>
    </Draggable>

    <div class="flex w-full items-center gap-2">
      <TagIcon class="h-4 w-4 shrink-0" />
      <input
        class="input input-sm input-bordered w-36 sm:w-64"
        v-model="newLabelForIP.ip"
        @click="handlerIPInputFocus"
        placeholder="IP / eui64 / Regex"
      />
      <ArrowRightCircleIcon class="h-4 w-4 shrink-0" />
      <input
        class="input input-sm input-bordered w-0 max-w-40 flex-1"
        v-model="newLabelForIP.label"
        @keypress.enter="handlerLabelAdd"
        :placeholder="$t('label')"
      />
      <button
        class="btn btn-circle btn-sm"
        @click="handlerLabelAdd"
      >
        <PlusIcon class="h-4 w-4" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { disableSwipe } from '@/composables/swipe'
import { useTooltip } from '@/helper/tooltip'
import { connections } from '@/store/connections'
import { sourceIPLabelList } from '@/store/settings'
import {
  ArrowRightCircleIcon,
  ChevronUpDownIcon,
  PlusIcon,
  TagIcon,
  XMarkIcon,
} from '@heroicons/vue/24/outline'
import { uniq } from 'lodash'
import { v4 as uuid } from 'uuid'
import { reactive } from 'vue'
import Draggable from 'vuedraggable'

const { showTip, destroyTip } = useTooltip()

const handlerIPInputFocus = (e: Event) => {
  const source = uniq(connections.value.map((conn) => conn.metadata.sourceIP))
    .filter(Boolean)
    .sort()

  if (!source.length) {
    return
  }
  const ipMenu = document.createElement('div')

  for (const ip of source) {
    const ipItem = document.createElement('div')

    ipItem.className = 'cursor-pointer p-1 transition-transform hover:scale-105'

    ipItem.textContent = ip
    ipItem.addEventListener('click', () => {
      newLabelForIP.ip = ip
      destroyTip()
    })
    ipMenu.appendChild(ipItem)
  }

  showTip(e, ipMenu, {
    placement: 'bottom-start',
    trigger: 'click',
    interactive: true,
    arrow: false,
  })
}

const newLabelForIP = reactive({
  ip: '',
  label: '',
})

const handlerLabelAdd = () => {
  if (!newLabelForIP.ip || !newLabelForIP.label) {
    return
  }

  sourceIPLabelList.value.push({
    key: newLabelForIP.ip,
    label: newLabelForIP.label,
    id: uuid(),
  })

  newLabelForIP.ip = ''
  newLabelForIP.label = ''
}

const handlerLabelRemove = (id: string) => {
  sourceIPLabelList.value.splice(
    sourceIPLabelList.value.findIndex((item) => item.id === id),
    1,
  )
}

const handlerLabelKeyChange = (e: Event, id: string, path: 'key' | 'label') => {
  const target = e.target as HTMLInputElement
  const key = target.value
  const source = sourceIPLabelList.value.find((item) => item.id === id)

  if (source) {
    source[path] = key
  }
}
</script>
