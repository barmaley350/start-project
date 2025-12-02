<script setup>
const props = defineProps({
    class: {
        type: [String, Array, Object],
        default: ''
    }
})
</script>

<template>
    <button class="bg-green-600 rounded-sm px-5 py-2 text-gray-100 shadow-sm" :class="class">
        <slot/>
    </button>
</template>