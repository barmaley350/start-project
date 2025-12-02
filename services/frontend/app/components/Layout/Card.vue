<template>
    <div class="flex flex-col gap-3">
        <div class="flex flex-col border border-gray-300 rounded-sm dark:border-gray-600">
            <div class="p-3 bg-gray-300 rounded-t-sm dark:bg-gray-700">
                <slot name="title" />
            </div>
            <div class="p-3">
                <slot name="description" />
            </div>
            <div v-if="$slots.fields" class="p-3 border-t border-t-gray-300 dark:border-t-gray-600">
                <slot name="fields" />
            </div>
            <div v-if="$slots.button" class="p-3 border-t border-t-gray-300 dark:border-t-gray-600">
                <slot name="button" />
            </div>
            <div v-if="$slots.footer" class="
                bg-gray-300
                dark:bg-gray-700 
                p-3
                ">
                <slot name="footer" />
            </div>
        </div>
    </div>
</template>