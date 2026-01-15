<script setup>
const runtimeConfig = useRuntimeConfig()
const paginationPageNumber = ref(1)
let url = "baseURL" in runtimeConfig ? runtimeConfig.baseURL + 'project/' : window.location.origin + '/drf/api/v1/project/'

const { data, status, error, pending } = await useFetch(url, {
    query: {
        page: paginationPageNumber,
    },
})

const countFlats = computed(() => {
    if (status.value == "success") {
        return data.value["count"]
    }
})

</script>
<template>
    <div class="flex flex-col gap-3">
        <div class="block my-3">
            <UPagination v-model:page="paginationPageNumber" :total="countFlats" />
        </div>
        <div class="grid grid-cols-12 gap-3">
            <div class="col-span-9">
                <div class="flex flex-col gap-3" v-if="data">
                    <LayoutCard v-for="item in data.results" :key="item.id">
                        <template #title>
                            <LayoutBadges
                                class="flex text-xl mr-3 dark:bg-gray-800 bg-gray-200 rounded-md h-auto items-center">
                                #{{ item.id }}
                            </LayoutBadges>
                            <LayoutTitle class="text-xl grow font-bold">
                                {{ item.title }}
                            </LayoutTitle>
                            <LayoutBadges
                                class="flex flex-row gap-1 items-center text-xl ml-3 dark:bg-gray-800 bg-gray-200 rounded-md">
                                <Icon name="i-lucide:message-circle-more" /> {{ item.comments_count }}
                            </LayoutBadges>
                        </template>
                        <template #author>
                            <div class="text-gray-500">
                                @{{ item.owner.username }} /
                                {{ item.owner.email }} /
                                {{ item.owner.first_name }}
                                {{ item.owner.last_name }}
                            </div>
                        </template>
                        <template #description>
                            {{ item.description }}
                        </template>
                        <template #footer>
                            <div class="flex flex-row items-center text-xl">
                                <Icon name="i-lucide:tags" />
                                <LayoutBadges class="text-base ml-1 bg-gray-200 dark:bg-gray-700 rounded-md"
                                    v-for="tag in item.tags">
                                    {{ tag.name }}
                                </LayoutBadges>
                            </div>
                        </template>
                    </LayoutCard>
                </div>

            </div>
            <div class="col-span-3">
                <LayoutSidebarRight>
                    <LayoutCard>
                        <template #title>
                            <LayoutTitle class="text-xl font-bold">Фильтры</LayoutTitle>
                        </template>
                        <template #description>
                            Lorem, ipsum dolor sit amet consectetur adipisicing elit. Nesciunt adipisci necessitatibus
                            nostrum, maiores aliquid soluta laudantium at, minima molestiae commodi praesentium est
                            officia eius quae reprehenderit quibusdam rem distinctio accusantium.
                        </template>
                    </LayoutCard>
                    <LayoutCard>
                        <template #title>
                            <LayoutTitle class="text-xl font-bold">Статистика</LayoutTitle>
                        </template>
                        <template #description>
                            Lorem, ipsum dolor sit amet consectetur adipisicing elit. Nesciunt adipisci necessitatibus
                            nostrum, maiores aliquid soluta laudantium at, minima molestiae commodi praesentium est
                            officia eius quae reprehenderit quibusdam rem distinctio accusantium.
                        </template>
                    </LayoutCard>
                </LayoutSidebarRight>
            </div>
        </div>
        <div class="block my-3">
            <UPagination v-model:page="paginationPageNumber" :total="countFlats" />
        </div>
    </div>
</template>