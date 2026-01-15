<script setup>
const menus = {
    m1:
    {
        title: "Title 1",
        urls: [
            { title: "Как это работает", url: "/test/" },
            { title: "Услуги и цены", url: "/test/" },
            { title: "Пользовательское соглашение", url: "/test/" },
        ],
    },
    m2:
    {
        title: "Title 2",
        urls: [
            { title: "Вход", url: "/test/" },
            { title: "Регистрация", url: "/test/" },
        ],
    },
    m3:
    {
        title: "Title 3",
        urls: [
            { title: "", url: "" },
        ],
    },
    m4:
    {
        title: "Title 3",
        urls: [
            { title: "© 2026 barmaley", url: "" },
            { title: "Все права защищены", url: "" },
        ],
    },
}
</script>
<template>
    <div
        class="grid grid-cols-4 gap-5 bg-white dark:bg-gray-900 mt-20 border-t p-5 border-gray-200 dark:border-gray-600">
        <div v-for="menu in menus" class="flex gap-1 p-3">
            <LayoutText>
                <template #header_primary>
                    <!-- <LayoutTitle class="text-2xl font-bold text-left">
                        {{ menu.title }}
                    </LayoutTitle> -->
                </template>
                <template #header_secondary>
                    <div v-for="url in menu.urls">
                        <ul v-if="url.url">
                            <li>
                                <NuxtLink :to=url.url>
                                    <LayoutTitle class="text-xl text-gray-500 dark:text-gray-300 text-left">
                                        {{ url.title }}
                                    </LayoutTitle>
                                </NuxtLink>
                            </li>
                        </ul>
                        <div v-else>
                            <LayoutTitle class="text-xl text-gray-500 dark:text-gray-300 text-left">
                                {{ url.title }}
                            </LayoutTitle>
                        </div>
                    </div>

                </template>
            </LayoutText>
        </div>
    </div>
</template>