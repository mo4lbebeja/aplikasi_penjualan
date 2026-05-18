<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { useForm } from '@inertiajs/vue3'

defineOptions({
    layout: AppLayout,
});
defineProps<{ produk: any[]; items: any }>()
const form = useForm({ produk_id: '', qty: 1, harga_beli: 0, tanggal: new Date().toISOString().slice(0,10), keterangan: '' })
</script>
<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">Stok Masuk</h1>
    <form @submit.prevent="form.post('/admin/stok')" class="grid gap-3 rounded-xl border p-4 md:grid-cols-5">
      <select v-model="form.produk_id" class="rounded border p-2"><option value="">Pilih produk</option><option v-for="p in produk" :key="p.id" :value="p.id">{{ p.nama }}</option></select>
      <input v-model="form.qty" type="number" class="rounded border p-2" placeholder="Qty" />
      <input v-model="form.harga_beli" type="number" class="rounded border p-2" placeholder="Harga beli" />
      <input v-model="form.tanggal" type="date" class="rounded border p-2" />
      <button class="rounded bg-black text-white">Simpan</button>
    </form>
  </div>
</template>
