<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';

defineOptions({
    layout: AppLayout,
});
defineProps<{ transaksi: any }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>
<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">{{ transaksi.nomor_transaksi }}</h1>
    <table class="w-full border text-sm"><tbody><tr v-for="d in transaksi.detail" :key="d.id" class="border-t"><td class="p-2">{{ d.produk?.nama }}</td><td>{{ d.qty }}</td><td>{{ rupiah(d.harga) }}</td><td class="text-right">{{ rupiah(d.subtotal) }}</td></tr></tbody></table>
  </div>
</template>
