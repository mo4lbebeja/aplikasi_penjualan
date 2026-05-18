#!/usr/bin/env bash
set -e

echo "== Finalisasi halaman Produk =="

mkdir -p resources/js/pages/Admin/Produk

cat > resources/js/pages/Admin/Produk/Index.vue <<'VUE'
<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Link, router, useForm } from '@inertiajs/vue3';
import {
    AlertTriangle,
    Edit,
    Package,
    Plus,
    Search,
    Trash2,
    X,
} from 'lucide-vue-next';

defineOptions({
    layout: AppLayout,
});

const props = defineProps<{
    produk: any;
    filters: any;
    kategori: any[];
}>();

const form = useForm({
    q: props.filters?.q || '',
    kategori: props.filters?.kategori || '',
    status: props.filters?.status ?? '',
    stok: props.filters?.stok || '',
});

const rupiah = (n: number) =>
    new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0,
    }).format(Number(n || 0));

function search() {
    router.get('/admin/produk', {
        q: form.q,
        kategori: form.kategori,
        status: form.status,
        stok: form.stok,
    }, {
        preserveState: true,
        preserveScroll: true,
        replace: true,
    });
}

function resetFilter() {
    form.q = '';
    form.kategori = '';
    form.status = '';
    form.stok = '';

    router.get('/admin/produk', {}, {
        preserveState: true,
        preserveScroll: true,
        replace: true,
    });
}

function hapus(item: any) {
    if (!confirm(`Hapus/nonaktifkan produk "${item.nama}"?`)) return;

    router.delete(`/admin/produk/${item.id}`, {
        preserveScroll: true,
    });
}
</script>

<template>
    <div class="space-y-6">
        <section class="flex flex-col gap-4 rounded-3xl bg-white p-5 shadow-sm ring-1 ring-slate-200 sm:p-6 lg:flex-row lg:items-center lg:justify-between">
            <div class="flex items-center gap-3">
                <div class="rounded-2xl bg-slate-950 p-3 text-white">
                    <Package class="h-5 w-5" />
                </div>
                <div>
                    <h2 class="text-2xl font-bold text-slate-950">Produk</h2>
                    <p class="text-sm text-slate-500">Kelola produk, harga, barcode, dan stok toko.</p>
                </div>
            </div>

            <Link
                href="/admin/produk/create"
                class="inline-flex items-center justify-center gap-2 rounded-2xl bg-slate-950 px-4 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-slate-800"
            >
                <Plus class="h-4 w-4" />
                Tambah Produk
            </Link>
        </section>

        <section class="rounded-3xl border border-slate-200 bg-white p-4 shadow-sm sm:p-5">
            <form @submit.prevent="search" class="grid gap-3 lg:grid-cols-[1.5fr_1fr_1fr_1fr_auto]">
                <div class="relative">
                    <Search class="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                    <input
                        v-model="form.q"
                        class="w-full rounded-2xl border border-slate-200 bg-slate-50 py-2.5 pl-10 pr-3 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                        placeholder="Cari nama, kode produk, atau barcode..."
                    />
                </div>

                <select
                    v-model="form.kategori"
                    class="rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                >
                    <option value="">Semua Kategori</option>
                    <option v-for="item in kategori" :key="item.id" :value="item.id">
                        {{ item.nama }}
                    </option>
                </select>

                <select
                    v-model="form.status"
                    class="rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                >
                    <option value="">Semua Status</option>
                    <option value="1">Aktif</option>
                    <option value="0">Nonaktif</option>
                </select>

                <select
                    v-model="form.stok"
                    class="rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                >
                    <option value="">Semua Stok</option>
                    <option value="menipis">Stok Menipis</option>
                </select>

                <div class="flex gap-2">
                    <button
                        class="flex-1 rounded-2xl bg-slate-950 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-slate-800 lg:flex-none"
                    >
                        Cari
                    </button>
                    <button
                        type="button"
                        @click="resetFilter"
                        class="rounded-2xl border border-slate-200 px-3 py-2.5 text-slate-600 transition hover:bg-slate-50"
                    >
                        <X class="h-4 w-4" />
                    </button>
                </div>
            </form>
        </section>

        <section class="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm">
            <div class="hidden overflow-x-auto lg:block">
                <table class="w-full min-w-[900px] text-sm">
                    <thead class="bg-slate-50 text-xs uppercase tracking-wide text-slate-500">
                        <tr>
                            <th class="px-5 py-4 text-left">Produk</th>
                            <th class="px-5 py-4 text-left">Kategori</th>
                            <th class="px-5 py-4 text-left">Satuan</th>
                            <th class="px-5 py-4 text-right">Harga Beli</th>
                            <th class="px-5 py-4 text-right">Harga Jual</th>
                            <th class="px-5 py-4 text-center">Stok</th>
                            <th class="px-5 py-4 text-center">Status</th>
                            <th class="px-5 py-4 text-right">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="item in produk.data" :key="item.id" class="border-t border-slate-100">
                            <td class="px-5 py-4">
                                <div class="font-semibold text-slate-950">{{ item.nama }}</div>
                                <div class="mt-1 text-xs text-slate-500">
                                    {{ item.kode_produk }} <span v-if="item.barcode">• {{ item.barcode }}</span>
                                </div>
                            </td>
                            <td class="px-5 py-4 text-slate-600">{{ item.kategori?.nama || '-' }}</td>
                            <td class="px-5 py-4 text-slate-600">{{ item.satuan?.nama || '-' }}</td>
                            <td class="px-5 py-4 text-right font-medium">{{ rupiah(item.harga_beli) }}</td>
                            <td class="px-5 py-4 text-right font-bold">{{ rupiah(item.harga_jual) }}</td>
                            <td class="px-5 py-4 text-center">
                                <div class="inline-flex items-center gap-1 rounded-full px-3 py-1 text-xs font-semibold"
                                    :class="item.stok <= item.stok_minimum ? 'bg-orange-100 text-orange-700' : 'bg-emerald-100 text-emerald-700'"
                                >
                                    <AlertTriangle v-if="item.stok <= item.stok_minimum" class="h-3 w-3" />
                                    {{ item.stok }} {{ item.satuan?.singkatan || '' }}
                                </div>
                            </td>
                            <td class="px-5 py-4 text-center">
                                <span class="rounded-full px-3 py-1 text-xs font-semibold"
                                    :class="item.aktif ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700'"
                                >
                                    {{ item.aktif ? 'Aktif' : 'Nonaktif' }}
                                </span>
                            </td>
                            <td class="px-5 py-4">
                                <div class="flex justify-end gap-2">
                                    <Link
                                        :href="`/admin/produk/${item.id}/edit`"
                                        class="rounded-xl border border-slate-200 p-2 text-slate-600 transition hover:bg-slate-50"
                                    >
                                        <Edit class="h-4 w-4" />
                                    </Link>
                                    <button
                                        @click="hapus(item)"
                                        class="rounded-xl border border-red-200 p-2 text-red-600 transition hover:bg-red-50"
                                    >
                                        <Trash2 class="h-4 w-4" />
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr v-if="produk.data.length === 0">
                            <td colspan="8" class="px-5 py-12 text-center text-slate-500">
                                Belum ada produk yang sesuai filter.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="grid gap-3 p-4 lg:hidden">
                <article
                    v-for="item in produk.data"
                    :key="item.id"
                    class="rounded-3xl border border-slate-200 p-4"
                >
                    <div class="flex items-start justify-between gap-3">
                        <div>
                            <h3 class="font-bold text-slate-950">{{ item.nama }}</h3>
                            <p class="mt-1 text-xs text-slate-500">{{ item.kode_produk }}</p>
                        </div>
                        <span class="rounded-full px-3 py-1 text-xs font-semibold"
                            :class="item.aktif ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700'"
                        >
                            {{ item.aktif ? 'Aktif' : 'Nonaktif' }}
                        </span>
                    </div>

                    <div class="mt-4 grid grid-cols-2 gap-3 text-sm">
                        <div>
                            <div class="text-xs text-slate-500">Kategori</div>
                            <div class="font-semibold">{{ item.kategori?.nama || '-' }}</div>
                        </div>
                        <div>
                            <div class="text-xs text-slate-500">Satuan</div>
                            <div class="font-semibold">{{ item.satuan?.nama || '-' }}</div>
                        </div>
                        <div>
                            <div class="text-xs text-slate-500">Harga Jual</div>
                            <div class="font-semibold">{{ rupiah(item.harga_jual) }}</div>
                        </div>
                        <div>
                            <div class="text-xs text-slate-500">Stok</div>
                            <div class="font-semibold">{{ item.stok }} {{ item.satuan?.singkatan || '' }}</div>
                        </div>
                    </div>

                    <div class="mt-4 flex gap-2">
                        <Link
                            :href="`/admin/produk/${item.id}/edit`"
                            class="flex flex-1 items-center justify-center gap-2 rounded-2xl border border-slate-200 px-3 py-2 text-sm font-semibold"
                        >
                            <Edit class="h-4 w-4" />
                            Edit
                        </Link>
                        <button
                            @click="hapus(item)"
                            class="flex flex-1 items-center justify-center gap-2 rounded-2xl border border-red-200 px-3 py-2 text-sm font-semibold text-red-600"
                        >
                            <Trash2 class="h-4 w-4" />
                            Hapus
                        </button>
                    </div>
                </article>

                <div v-if="produk.data.length === 0" class="rounded-3xl border border-slate-200 p-8 text-center text-slate-500">
                    Belum ada produk yang sesuai filter.
                </div>
            </div>

            <div v-if="produk.links?.length > 3" class="flex flex-wrap items-center justify-between gap-3 border-t border-slate-100 px-4 py-4">
                <div class="text-sm text-slate-500">
                    Menampilkan {{ produk.from || 0 }} - {{ produk.to || 0 }} dari {{ produk.total || 0 }} produk
                </div>

                <div class="flex flex-wrap gap-1">
                    <Link
                        v-for="link in produk.links"
                        :key="link.label"
                        :href="link.url || '#'"
                        class="rounded-xl px-3 py-2 text-sm"
                        :class="[
                            link.active ? 'bg-slate-950 text-white' : 'border border-slate-200 text-slate-600 hover:bg-slate-50',
                            !link.url ? 'pointer-events-none opacity-40' : ''
                        ]"
                        v-html="link.label"
                    />
                </div>
            </div>
        </section>
    </div>
</template>
VUE

echo "== Halaman index produk selesai =="
