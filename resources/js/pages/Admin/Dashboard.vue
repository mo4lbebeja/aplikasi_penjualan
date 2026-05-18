<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';
import {
    AlertTriangle,
    ArrowRight,
    Package,
    ReceiptText,
    TrendingUp,
    Wallet,
} from 'lucide-vue-next';

defineOptions({
    layout: AppLayout,
});

defineProps<{ stats: any; stokMenipis: any[]; transaksiTerbaru: any[] }>();

const rupiah = (n: number) =>
    new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0,
    }).format(Number(n || 0));
</script>

<template>
    <div class="space-y-6">
        <section class="overflow-hidden rounded-3xl bg-gradient-to-br from-slate-950 via-slate-800 to-slate-700 p-6 text-white shadow-sm sm:p-8">
            <div class="flex flex-col gap-5 md:flex-row md:items-center md:justify-between">
                <div>
                    <p class="text-sm font-medium text-slate-300">Selamat datang kembali</p>
                    <h2 class="mt-2 text-2xl font-bold sm:text-3xl">Dashboard Penjualan</h2>
                    <p class="mt-2 max-w-2xl text-sm text-slate-300">
                        Pantau stok, transaksi harian, dan performa penjualan toko dari satu tempat.
                    </p>
                </div>
                <Link href="/kasir" class="inline-flex items-center justify-center gap-2 rounded-2xl bg-white px-4 py-2.5 text-sm font-semibold text-slate-950 shadow-sm">
                    Buka Kasir
                    <ArrowRight class="h-4 w-4" />
                </Link>
            </div>
        </section>

        <section class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <div class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm">
                <div class="flex items-center justify-between">
                    <div class="rounded-2xl bg-slate-100 p-3 text-slate-700">
                        <Package class="h-5 w-5" />
                    </div>
                </div>
                <div class="mt-4 text-sm text-slate-500">Total Produk</div>
                <div class="mt-1 text-3xl font-bold text-slate-950">{{ stats.produk }}</div>
            </div>

            <div class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm">
                <div class="rounded-2xl bg-orange-100 p-3 text-orange-700">
                    <AlertTriangle class="h-5 w-5" />
                </div>
                <div class="mt-4 text-sm text-slate-500">Stok Menipis</div>
                <div class="mt-1 text-3xl font-bold text-slate-950">{{ stats.stok_menipis }}</div>
            </div>

            <div class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm">
                <div class="rounded-2xl bg-blue-100 p-3 text-blue-700">
                    <ReceiptText class="h-5 w-5" />
                </div>
                <div class="mt-4 text-sm text-slate-500">Transaksi Hari Ini</div>
                <div class="mt-1 text-3xl font-bold text-slate-950">{{ stats.transaksi_hari_ini }}</div>
            </div>

            <div class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm">
                <div class="rounded-2xl bg-emerald-100 p-3 text-emerald-700">
                    <Wallet class="h-5 w-5" />
                </div>
                <div class="mt-4 text-sm text-slate-500">Penjualan Hari Ini</div>
                <div class="mt-1 text-2xl font-bold text-slate-950">{{ rupiah(stats.penjualan_hari_ini) }}</div>
            </div>
        </section>

        <section class="grid gap-6 xl:grid-cols-3">
            <div class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm xl:col-span-2">
                <div class="mb-4 flex items-center justify-between">
                    <div>
                        <h3 class="text-lg font-bold text-slate-950">Transaksi Terbaru</h3>
                        <p class="text-sm text-slate-500">Aktivitas transaksi penjualan terakhir.</p>
                    </div>
                    <TrendingUp class="h-5 w-5 text-slate-400" />
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full min-w-[520px] text-sm">
                        <thead>
                            <tr class="border-b text-left text-xs uppercase tracking-wide text-slate-400">
                                <th class="pb-3">No Transaksi</th>
                                <th class="pb-3">Kasir</th>
                                <th class="pb-3 text-right">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="t in transaksiTerbaru" :key="t.id" class="border-b last:border-0">
                                <td class="py-3 font-semibold text-slate-800">{{ t.nomor_transaksi }}</td>
                                <td class="py-3 text-slate-600">{{ t.kasir?.nama || t.kasir?.name || '-' }}</td>
                                <td class="py-3 text-right font-bold">{{ rupiah(t.total) }}</td>
                            </tr>
                            <tr v-if="transaksiTerbaru.length === 0">
                                <td colspan="3" class="py-8 text-center text-slate-500">Belum ada transaksi.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm">
                <div class="mb-4">
                    <h3 class="text-lg font-bold text-slate-950">Stok Menipis</h3>
                    <p class="text-sm text-slate-500">Segera lakukan restock.</p>
                </div>

                <div class="space-y-3">
                    <div v-for="p in stokMenipis" :key="p.id" class="rounded-2xl border border-slate-100 p-3">
                        <div class="font-semibold text-slate-800">{{ p.nama }}</div>
                        <div class="mt-1 text-sm text-slate-500">
                            Stok {{ p.stok }} {{ p.satuan?.singkatan || '' }} • Minimum {{ p.stok_minimum }}
                        </div>
                    </div>
                    <div v-if="stokMenipis.length === 0" class="rounded-2xl bg-slate-50 p-4 text-sm text-slate-500">
                        Semua stok masih aman.
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>
