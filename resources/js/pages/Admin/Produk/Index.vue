<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Link, router } from '@inertiajs/vue3'

defineOptions({
    layout: AppLayout,
});
defineProps<{ produk: any; filters: any }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
const hapus = (id: number) => { if (confirm('Hapus produk ini?')) router.delete(`/admin/produk/${id}`) }
</script>
<template>
  <div class="space-y-4 p-6">
    <div class="flex items-center justify-between"><h1 class="text-2xl font-bold">Produk</h1><Link href="/admin/produk/create" class="rounded bg-black px-4 py-2 text-white">Tambah</Link></div>
    <table class="w-full rounded-xl border text-sm">
      <thead><tr class="bg-gray-50"><th class="p-2 text-left">Kode</th><th>Nama</th><th>Kategori</th><th>Stok</th><th>Harga</th><th></th></tr></thead>
      <tbody><tr v-for="p in produk.data" :key="p.id" class="border-t"><td class="p-2">{{ p.kode_produk }}</td><td>{{ p.nama }}</td><td>{{ p.kategori?.nama }}</td><td>{{ p.stok }} {{ p.satuan?.singkatan }}</td><td>{{ rupiah(p.harga_jual) }}</td><td class="space-x-2 text-right"><Link :href="`/admin/produk/${p.id}/edit`">Edit</Link><button @click="hapus(p.id)">Hapus</button></td></tr></tbody>
    </table>
  </div>
</template>
