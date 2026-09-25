<!-- LSP: vue_ls + vtsls. Главная проверка: gd на импорте из ./check.ts
     должен открыть check.ts — значит плагин Vue внутри tsserver работает -->

<script setup lang="ts">
import { ref, computed } from "vue";
import { type User, activeNames } from "./check";

const users = ref<User[]>([
  { id: 1, name: "Мария", active: true },
  { id: 2, name: "Иван", active: false },
]);

const names = computed(() => activeNames(users.value));
</script>

<template>
  <ul class="users">
    <li v-for="name in names" :key="name">{{ name }}</li>
  </ul>
</template>
