<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { useForm } from '@inertiajs/vue3'

defineOptions({
    layout: AppLayout,
});
const props = defineProps<{ produk: any | null; kategori: any[]; satuan: any[] }>()
const form = useForm({ kode_produk: props.produk?.kode_produk || '', barcode: props.produk?.barcode || '', nama: props.produk?.nama || '', id_kategori_produk: props.produk?.id_kategori_produk || '', id_satuan: props.produk?.id_satuan || '', harga_beli: props.produk?.harga_beli || 0, harga_jual: props.produk?.harga_jual || 0, stok: props.produk?.stok || 0, stok_minimum: props.produk?.stok_minimum || 0, aktif: props.produk?.aktif ?? true })
const submit = () => props.produk ? form.put(`/admin/produk/${props.produk.id}`) : form.post('/admin/produk')
</script>
<template>
  <div class="mx-auto max-w-3xl space-y-4 p-6">
    <h1 class="text-2xl font-bold">{{ produk ? 'Edit' : 'Tambah' }} Produk</h1>
    <form @submit.prevent="submit" class="grid gap-4 rounded-xl border p-4 md:grid-cols-2">
      <input v-model="form.kode_produk" placeholder="Kode produk otomatis jika kosong" class="rounded border p-2" />
      <input v-model="form.barcode" placeholder="Barcode" class="rounded border p-2" />
      <input v-model="form.nama" placeholder="Nama produk" class="rounded border p-2 md:col-span-2" />
      <select v-model="form.id_kategori_produk" class="rounded border p-2"><option value="">Pilih kategori</option><option v-for="k in kategori" :key="k.id" :value="k.id">{{ k.nama }}</option></select>
      <select v-model="form.id_satuan" class="rounded border p-2"><option value="">Pilih satuan</option><option v-for="s in satuan" :key="s.id" :value="s.id">{{ s.nama }}</option></select>
      <input v-model="form.harga_beli" type="number" placeholder="Harga beli" class="rounded border p-2" />
      <input v-model="form.harga_jual" type="number" placeholder="Harga jual" class="rounded border p-2" />
      <input v-model="form.stok" type="number" placeholder="Stok" class="rounded border p-2" />
      <input v-model="form.stok_minimum" type="number" placeholder="Stok minimum" class="rounded border p-2" />
      <button class="rounded bg-black p-2 text-white md:col-span-2">Simpan</button>
    </form>
  </div>
</template>
