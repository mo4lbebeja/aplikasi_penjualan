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
