#!/usr/bin/env bash
set -e

echo "== Finalisasi form Produk =="

mkdir -p resources/js/pages/Admin/Produk

cat > resources/js/pages/Admin/Produk/Form.vue <<'VUE'
<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Link, useForm } from '@inertiajs/vue3';
import { ArrowLeft, Barcode, PackageCheck, Save } from 'lucide-vue-next';

defineOptions({
    layout: AppLayout,
});

const props = defineProps<{
    mode: 'create' | 'edit';
    produk: any | null;
    kategori: any[];
    satuan: any[];
}>();

const form = useForm({
    kode_produk: props.produk?.kode_produk || '',
    barcode: props.produk?.barcode || '',
    nama: props.produk?.nama || '',
    id_kategori_produk: props.produk?.id_kategori_produk || '',
    id_satuan: props.produk?.id_satuan || '',
    harga_beli: props.produk?.harga_beli || 0,
    harga_jual: props.produk?.harga_jual || 0,
    stok: props.produk?.stok || 0,
    stok_minimum: props.produk?.stok_minimum || 0,
    aktif: props.produk?.aktif ?? true,
});

const isEdit = props.mode === 'edit';

const rupiah = (n: number) =>
    new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0,
    }).format(Number(n || 0));

function submit() {
    if (isEdit) {
        form.put(`/admin/produk/${props.produk.id}`);
        return;
    }

    form.post('/admin/produk');
}
</script>

<template>
    <div class="space-y-6">
        <section class="flex flex-col gap-4 rounded-3xl bg-white p-5 shadow-sm ring-1 ring-slate-200 sm:p-6 lg:flex-row lg:items-center lg:justify-between">
            <div class="flex items-center gap-3">
                <div class="rounded-2xl bg-slate-950 p-3 text-white">
                    <PackageCheck class="h-5 w-5" />
                </div>
                <div>
                    <h2 class="text-2xl font-bold text-slate-950">
                        {{ isEdit ? 'Edit Produk' : 'Tambah Produk' }}
                    </h2>
                    <p class="text-sm text-slate-500">
                        Lengkapi data produk, harga, kategori, dan stok.
                    </p>
                </div>
            </div>

            <Link href="/admin/produk" class="inline-flex items-center justify-center gap-2 rounded-2xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">
                <ArrowLeft class="h-4 w-4" />
                Kembali
            </Link>
        </section>

        <form @submit.prevent="submit" class="grid gap-6 lg:grid-cols-3">
            <section class="space-y-5 rounded-3xl border border-slate-200 bg-white p-5 shadow-sm lg:col-span-2">
                <div>
                    <h3 class="font-bold text-slate-950">Informasi Produk</h3>
                    <p class="text-sm text-slate-500">Data utama yang tampil di katalog dan kasir.</p>
                </div>

                <div class="grid gap-4 sm:grid-cols-2">
                    <div>
                        <label class="text-sm font-semibold text-slate-700">Kode Produk</label>
                        <input
                            v-model="form.kode_produk"
                            class="mt-1 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                            placeholder="Kosongkan untuk otomatis"
                        />
                        <p class="mt-1 text-xs text-slate-400">Contoh: PRD00001</p>
                        <div v-if="form.errors.kode_produk" class="mt-1 text-xs text-red-600">{{ form.errors.kode_produk }}</div>
                    </div>

                    <div>
                        <label class="text-sm font-semibold text-slate-700">Barcode</label>
                        <div class="relative mt-1">
                            <Barcode class="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
                            <input
                                v-model="form.barcode"
                                class="w-full rounded-2xl border border-slate-200 bg-slate-50 py-2.5 pl-10 pr-3 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                                placeholder="Opsional"
                            />
                        </div>
                        <div v-if="form.errors.barcode" class="mt-1 text-xs text-red-600">{{ form.errors.barcode }}</div>
                    </div>

                    <div class="sm:col-span-2">
                        <label class="text-sm font-semibold text-slate-700">Nama Produk</label>
                        <input
                            v-model="form.nama"
                            class="mt-1 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                            placeholder="Contoh: Beras Premium 5kg"
                        />
                        <div v-if="form.errors.nama" class="mt-1 text-xs text-red-600">{{ form.errors.nama }}</div>
                    </div>

                    <div>
                        <label class="text-sm font-semibold text-slate-700">Kategori</label>
                        <select
                            v-model="form.id_kategori_produk"
                            class="mt-1 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                        >
                            <option value="">Pilih kategori</option>
                            <option v-for="item in kategori" :key="item.id" :value="item.id">
                                {{ item.nama }}
                            </option>
                        </select>
                        <div v-if="form.errors.id_kategori_produk" class="mt-1 text-xs text-red-600">{{ form.errors.id_kategori_produk }}</div>
                    </div>

                    <div>
                        <label class="text-sm font-semibold text-slate-700">Satuan</label>
                        <select
                            v-model="form.id_satuan"
                            class="mt-1 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                        >
                            <option value="">Pilih satuan</option>
                            <option v-for="item in satuan" :key="item.id" :value="item.id">
                                {{ item.nama }} {{ item.singkatan ? `(${item.singkatan})` : '' }}
                            </option>
                        </select>
                        <div v-if="form.errors.id_satuan" class="mt-1 text-xs text-red-600">{{ form.errors.id_satuan }}</div>
                    </div>
                </div>
            </section>

            <aside class="space-y-6">
                <section class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm">
                    <h3 class="font-bold text-slate-950">Harga & Stok</h3>
                    <p class="mb-4 text-sm text-slate-500">Pastikan harga dan stok awal sudah benar.</p>

                    <div class="space-y-4">
                        <div>
                            <label class="text-sm font-semibold text-slate-700">Harga Beli</label>
                            <input
                                v-model="form.harga_beli"
                                type="number"
                                min="0"
                                class="mt-1 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                            />
                            <div class="mt-1 text-xs text-slate-400">{{ rupiah(form.harga_beli) }}</div>
                            <div v-if="form.errors.harga_beli" class="mt-1 text-xs text-red-600">{{ form.errors.harga_beli }}</div>
                        </div>

                        <div>
                            <label class="text-sm font-semibold text-slate-700">Harga Jual</label>
                            <input
                                v-model="form.harga_jual"
                                type="number"
                                min="0"
                                class="mt-1 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                            />
                            <div class="mt-1 text-xs text-slate-400">{{ rupiah(form.harga_jual) }}</div>
                            <div v-if="form.errors.harga_jual" class="mt-1 text-xs text-red-600">{{ form.errors.harga_jual }}</div>
                        </div>

                        <div class="grid grid-cols-2 gap-3">
                            <div>
                                <label class="text-sm font-semibold text-slate-700">Stok</label>
                                <input
                                    v-model="form.stok"
                                    type="number"
                                    min="0"
                                    class="mt-1 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                                />
                                <div v-if="form.errors.stok" class="mt-1 text-xs text-red-600">{{ form.errors.stok }}</div>
                            </div>

                            <div>
                                <label class="text-sm font-semibold text-slate-700">Min.</label>
                                <input
                                    v-model="form.stok_minimum"
                                    type="number"
                                    min="0"
                                    class="mt-1 w-full rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm outline-none transition focus:border-slate-400 focus:bg-white"
                                />
                                <div v-if="form.errors.stok_minimum" class="mt-1 text-xs text-red-600">{{ form.errors.stok_minimum }}</div>
                            </div>
                        </div>

                        <label class="flex items-center gap-3 rounded-2xl border border-slate-200 bg-slate-50 p-3">
                            <input v-model="form.aktif" type="checkbox" class="h-4 w-4 rounded" />
                            <span>
                                <span class="block text-sm font-semibold text-slate-700">Produk Aktif</span>
                                <span class="block text-xs text-slate-500">Produk tampil di halaman kasir.</span>
                            </span>
                        </label>
                    </div>
                </section>

                <section class="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm">
                    <button
                        class="inline-flex w-full items-center justify-center gap-2 rounded-2xl bg-slate-950 px-4 py-3 text-sm font-semibold text-white shadow-sm transition hover:bg-slate-800 disabled:cursor-not-allowed disabled:opacity-60"
                        :disabled="form.processing"
                    >
                        <Save class="h-4 w-4" />
                        {{ form.processing ? 'Menyimpan...' : 'Simpan Produk' }}
                    </button>
                </section>
            </aside>
        </form>
    </div>
</template>
VUE

echo "== Form produk selesai =="
