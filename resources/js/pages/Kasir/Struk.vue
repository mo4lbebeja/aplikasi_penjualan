<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';

defineOptions({
    layout: AppLayout,
});
defineProps<{ transaksi: any }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>
<template>
  <div class="mx-auto max-w-md p-6">
    <div class="rounded-xl border p-4">
      <h1 class="text-center text-xl font-bold">STRUK PENJUALAN</h1>
      <p class="text-center text-sm">{{ transaksi.nomor_transaksi }}</p>
      <div class="my-4 border-t"></div>
      <div v-for="d in transaksi.detail" :key="d.id" class="flex justify-between py-1 text-sm">
        <span>{{ d.produk?.nama }} x {{ d.qty }}</span><span>{{ rupiah(d.subtotal) }}</span>
      </div>
      <div class="my-4 border-t"></div>
      <div class="flex justify-between"><span>Subtotal</span><b>{{ rupiah(transaksi.subtotal) }}</b></div>
      <div class="flex justify-between"><span>Diskon</span><b>{{ rupiah(transaksi.diskon) }}</b></div>
      <div class="flex justify-between"><span>Total</span><b>{{ rupiah(transaksi.total) }}</b></div>
      <div class="flex justify-between"><span>Bayar</span><b>{{ rupiah(transaksi.bayar) }}</b></div>
      <div class="flex justify-between"><span>Kembali</span><b>{{ rupiah(transaksi.kembalian) }}</b></div>
      <button onclick="window.print()" class="mt-4 w-full rounded bg-black p-2 text-white">Cetak</button>
    </div>
  </div>
</template>
