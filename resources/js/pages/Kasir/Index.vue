<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { computed, ref } from 'vue'
import { router, useForm } from '@inertiajs/vue3'

defineOptions({
    layout: AppLayout,
});
const props = defineProps<{ produkAwal: any[]; pelangganAwal: any[] }>()
const produk = ref(props.produkAwal)
const cart = ref<any[]>([])
const pelangganId = ref('')
const diskon = ref(0)
const bayar = ref(0)
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
const total = computed(() => cart.value.reduce((s, i) => s + i.qty * Number(i.harga_jual), 0))
const grandTotal = computed(() => Math.max(0, total.value - Number(diskon.value || 0)))
function tambah(p: any) { const item = cart.value.find(i => i.id === p.id); if (item) item.qty++; else cart.value.push({ ...p, qty: 1 }) }
function bayarTransaksi() { router.post('/kasir/bayar', { pelanggan_id: pelangganId.value || null, diskon: diskon.value || 0, bayar: bayar.value, items: cart.value.map(i => ({ produk_id: i.id, qty: i.qty })) }) }
</script>
<template>
  <div class="grid gap-6 p-6 lg:grid-cols-2">
    <div class="space-y-4">
      <h1 class="text-2xl font-bold">Kasir / POS</h1>
      <div class="grid gap-3 md:grid-cols-2">
        <button v-for="p in produk" :key="p.id" @click="tambah(p)" class="rounded-xl border p-3 text-left hover:bg-gray-50">
          <div class="font-semibold">{{ p.nama }}</div><div class="text-sm text-gray-500">Stok {{ p.stok }} • {{ rupiah(p.harga_jual) }}</div>
        </button>
      </div>
    </div>
    <div class="space-y-4 rounded-xl border p-4">
      <h2 class="text-xl font-bold">Keranjang</h2>
      <div v-for="i in cart" :key="i.id" class="flex items-center justify-between border-b py-2">
        <div><div class="font-medium">{{ i.nama }}</div><div class="text-sm">{{ rupiah(i.harga_jual) }}</div></div>
        <input v-model.number="i.qty" type="number" min="1" class="w-20 rounded border p-1 text-center" />
      </div>
      <select v-model="pelangganId" class="w-full rounded border p-2"><option value="">Umum</option><option v-for="p in pelangganAwal" :key="p.id" :value="p.id">{{ p.nama }}</option></select>
      <input v-model.number="diskon" type="number" placeholder="Diskon" class="w-full rounded border p-2" />
      <input v-model.number="bayar" type="number" placeholder="Bayar" class="w-full rounded border p-2" />
      <div class="text-right text-xl font-bold">Total: {{ rupiah(grandTotal) }}</div>
      <button @click="bayarTransaksi" class="w-full rounded bg-black p-3 text-white">Bayar</button>
    </div>
  </div>
</template>
