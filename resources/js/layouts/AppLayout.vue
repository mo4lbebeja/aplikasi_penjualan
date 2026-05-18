<script setup lang="ts">
import AppSidebar from '@/components/AppSidebar.vue';
import { usePage } from '@inertiajs/vue3';
import { Menu, Search } from 'lucide-vue-next';
import { computed, ref } from 'vue';

const sidebarOpen = ref(false);
const page = usePage();
const user = computed(() => page.props.auth?.user as any);

const pageTitle = computed(() => {
    const url = page.url;

    if (url.startsWith('/admin/dashboard')) return 'Dashboard';
    if (url.startsWith('/admin/produk')) return 'Produk';
    if (url.startsWith('/admin/kategori')) return 'Kategori Produk';
    if (url.startsWith('/admin/satuan')) return 'Satuan';
    if (url.startsWith('/admin/supplier')) return 'Supplier';
    if (url.startsWith('/admin/pelanggan')) return 'Pelanggan';
    if (url.startsWith('/admin/pengguna')) return 'Pengguna';
    if (url.startsWith('/admin/stok')) return 'Stok Masuk';
    if (url.startsWith('/admin/transaksi')) return 'Transaksi';
    if (url.startsWith('/admin/laporan')) return 'Laporan';
    if (url.startsWith('/kasir')) return 'Kasir / POS';

    return 'Aplikasi Penjualan';
});
</script>

<template>
    <div class="min-h-screen bg-slate-100 text-slate-900">
        <div
            v-if="sidebarOpen"
            class="fixed inset-0 z-40 bg-slate-950/40 backdrop-blur-sm lg:hidden"
            @click="sidebarOpen = false"
        />

        <div class="flex min-h-screen">
            <AppSidebar :open="sidebarOpen" @close="sidebarOpen = false" />

            <div class="flex min-w-0 flex-1 flex-col">
                <header class="sticky top-0 z-30 border-b border-slate-200 bg-white/85 backdrop-blur">
                    <div class="flex h-16 items-center justify-between gap-3 px-4 sm:px-6">
                        <div class="flex min-w-0 items-center gap-3">
                            <button
                                type="button"
                                class="rounded-2xl border border-slate-200 bg-white p-2 text-slate-700 shadow-sm lg:hidden"
                                @click="sidebarOpen = true"
                            >
                                <Menu class="h-5 w-5" />
                            </button>

                            <div class="min-w-0">
                                <h1 class="truncate text-base font-bold text-slate-950 sm:text-xl">
                                    {{ pageTitle }}
                                </h1>
                                <p class="hidden text-xs text-slate-500 sm:block">
                                    Kelola operasional penjualan toko dengan cepat dan rapi.
                                </p>
                            </div>
                        </div>

                        <div class="hidden min-w-0 max-w-md flex-1 items-center rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2 md:flex">
                            <Search class="mr-2 h-4 w-4 text-slate-400" />
                            <input
                                class="w-full bg-transparent text-sm outline-none placeholder:text-slate-400"
                                placeholder="Cari menu atau data..."
                                disabled
                            />
                        </div>

                        <div class="flex items-center gap-3">
                            <div class="hidden text-right sm:block">
                                <div class="text-sm font-semibold leading-tight">
                                    {{ user?.nama || user?.name || 'User' }}
                                </div>
                                <div class="text-xs uppercase text-slate-500">
                                    {{ user?.peran || '-' }}
                                </div>
                            </div>
                            <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-slate-950 text-sm font-bold text-white shadow-sm">
                                {{ (user?.nama || user?.name || 'U').slice(0, 1).toUpperCase() }}
                            </div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 p-4 sm:p-6 lg:p-8">
                    <div class="mx-auto w-full max-w-7xl">
                        <slot />
                    </div>
                </main>
            </div>
        </div>
    </div>
</template>
