#!/usr/bin/env bash
set -e

echo "== Memasang layout dashboard modern responsif =="

mkdir -p resources/js/components
mkdir -p resources/js/layouts

cat > resources/js/components/AppSidebar.vue <<'VUE'
<script setup lang="ts">
import { Link, usePage } from '@inertiajs/vue3';
import {
    LayoutDashboard,
    Package,
    Tags,
    Ruler,
    Users,
    Truck,
    UserCog,
    ShoppingCart,
    Archive,
    ReceiptText,
    BarChart3,
    LogOut,
    Store,
    X,
} from 'lucide-vue-next';

defineProps<{
    open?: boolean;
}>();

const emit = defineEmits<{
    close: [];
}>();

const page = usePage();
const user = page.props.auth?.user as any;

const adminMenus = [
    { title: 'Dashboard', href: '/admin/dashboard', icon: LayoutDashboard },
    { title: 'Produk', href: '/admin/produk', icon: Package },
    { title: 'Kategori', href: '/admin/kategori', icon: Tags },
    { title: 'Satuan', href: '/admin/satuan', icon: Ruler },
    { title: 'Supplier', href: '/admin/supplier', icon: Truck },
    { title: 'Pelanggan', href: '/admin/pelanggan', icon: Users },
    { title: 'Pengguna', href: '/admin/pengguna', icon: UserCog },
    { title: 'Stok Masuk', href: '/admin/stok', icon: Archive },
    { title: 'Transaksi', href: '/admin/transaksi', icon: ReceiptText },
    { title: 'Laporan', href: '/admin/laporan', icon: BarChart3 },
];

const kasirMenus = [
    { title: 'Kasir / POS', href: '/kasir', icon: ShoppingCart },
];

const menus = user?.peran === 'kasir' ? kasirMenus : adminMenus;

const isActive = (href: string) => {
    return page.url === href || page.url.startsWith(href + '/');
};

function closeOnMobile() {
    emit('close');
}
</script>

<template>
    <aside
        class="fixed inset-y-0 left-0 z-50 flex w-72 transform flex-col border-r border-slate-200 bg-white/95 shadow-xl backdrop-blur transition-transform duration-300 ease-out lg:static lg:z-auto lg:w-72 lg:translate-x-0 lg:shadow-none"
        :class="open ? 'translate-x-0' : '-translate-x-full'"
    >
        <div class="flex h-16 items-center justify-between border-b border-slate-100 px-4">
            <Link href="/dashboard" class="flex items-center gap-3" @click="closeOnMobile">
                <div class="flex h-10 w-10 items-center justify-center rounded-2xl bg-slate-950 text-white shadow-sm">
                    <Store class="h-5 w-5" />
                </div>
                <div>
                    <div class="text-sm font-bold leading-tight text-slate-900">SJL Penjualan</div>
                    <div class="text-xs text-slate-500">Point of Sales</div>
                </div>
            </Link>

            <button
                type="button"
                class="rounded-xl p-2 text-slate-500 hover:bg-slate-100 lg:hidden"
                @click="emit('close')"
            >
                <X class="h-5 w-5" />
            </button>
        </div>

        <div class="border-b border-slate-100 px-4 py-4">
            <div class="rounded-2xl bg-gradient-to-br from-slate-950 to-slate-700 p-4 text-white shadow-sm">
                <div class="text-sm font-semibold">
                    {{ user?.nama || user?.name || 'User' }}
                </div>
                <div class="mt-1 text-xs text-slate-200">
                    {{ user?.email }}
                </div>
                <div class="mt-3 inline-flex rounded-full bg-white/15 px-3 py-1 text-xs font-semibold uppercase tracking-wide">
                    {{ user?.peran || '-' }}
                </div>
            </div>
        </div>

        <nav class="flex-1 space-y-1 overflow-y-auto px-3 py-4">
            <Link
                v-for="item in menus"
                :key="item.href"
                :href="item.href"
                class="group flex items-center gap-3 rounded-2xl px-3 py-2.5 text-sm font-medium transition"
                :class="
                    isActive(item.href)
                        ? 'bg-slate-950 text-white shadow-sm'
                        : 'text-slate-600 hover:bg-slate-100 hover:text-slate-950'
                "
                @click="closeOnMobile"
            >
                <component
                    :is="item.icon"
                    class="h-4 w-4 shrink-0"
                    :class="isActive(item.href) ? 'text-white' : 'text-slate-400 group-hover:text-slate-700'"
                />
                <span>{{ item.title }}</span>
            </Link>
        </nav>

        <div class="border-t border-slate-100 p-3">
            <Link
                href="/logout"
                method="post"
                as="button"
                class="flex w-full items-center gap-3 rounded-2xl px-3 py-2.5 text-sm font-semibold text-red-600 transition hover:bg-red-50"
            >
                <LogOut class="h-4 w-4" />
                Logout
            </Link>
        </div>
    </aside>
</template>
VUE

cat > resources/js/layouts/AppLayout.vue <<'VUE'
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
VUE

cat > resources/js/pages/Admin/Dashboard.vue <<'VUE'
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
VUE

echo "== Selesai memasang layout modern =="
echo "Jalankan:"
echo "php artisan optimize:clear"
echo "npm run build"
echo "npm run dev"
