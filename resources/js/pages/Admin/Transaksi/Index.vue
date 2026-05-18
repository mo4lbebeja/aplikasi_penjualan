<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3'

defineOptions({
    layout: AppLayout,
});
defineProps<{ items: any }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>
<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">Transaksi</h1>
    <table class="w-full border text-sm"><tbody><tr v-for="t in items.data" :key="t.id" class="border-t"><td class="p-2"><Link :href="`/admin/transaksi/${t.id}`">{{ t.nomor_transaksi }}</Link></td><td>{{ t.kasir?.nama }}</td><td class="text-right">{{ rupiah(t.total) }}</td><td>{{ t.status }}</td></tr></tbody></table>
  </div>
</template>
