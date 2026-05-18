<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';

defineOptions({
    layout: AppLayout,
});
defineProps<{ filter: any; transaksi: any[] }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>

<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">Laporan Penjualan</h1>
    <table class="w-full rounded-xl border text-sm">
      <thead><tr class="bg-gray-50"><th class="p-2 text-left">No</th><th>Kasir</th><th>Pelanggan</th><th class="text-right">Total</th><th>Status</th></tr></thead>
      <tbody><tr v-for="t in transaksi" :key="t.id" class="border-t"><td class="p-2">{{ t.nomor_transaksi }}</td><td>{{ t.kasir?.nama }}</td><td>{{ t.pelanggan?.nama || '-' }}</td><td class="text-right">{{ rupiah(t.total) }}</td><td>{{ t.status }}</td></tr></tbody>
    </table>
  </div>
</template>
