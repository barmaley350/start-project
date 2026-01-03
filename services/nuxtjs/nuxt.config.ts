// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  // vue: {
  //   compilerOptions: {
  //     compatConfig: {
  //       MODE: 3 // Максимальная детализация ошибок
  //     }
  //   }
  // },
  devServer: {
    port: 5173,
    host: '0.0.0.0'  // Разрешить подключения из Docker
  },
  runtimeConfig: {
    baseURL: 'http://service.drf:8000/api/',
    public: {
    },
  },
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  modules: [
    '@nuxt/ui',
  ],
  css: [
    '~/assets/css/main.css',
  ],
})