#!/usr/bin/env bash
set -e

echo "== Memasang menu/sidebar dashboard =="

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
} from 'lucide-vue-next';

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
</script>

<template>
    <aside class="flex h-screen w-64 flex-col border-r bg-white">
        <div class="border-b p-4">
            <div class="text-lg font-bold">Aplikasi Penjualan</div>
            <div class="text-sm text-gray-500">
                {{ user?.nama || user?.name || 'User' }}
            </div>
            <div class="mt-1 inline-block rounded bg-gray-100 px-2 py-1 text-xs uppercase text-gray-600">
                {{ user?.peran || '-' }}
            </div>
        </div>

        <nav class="flex-1 space-y-1 overflow-y-auto p-3">
            <Link
                v-for="item in menus"
                :key="item.href"
                :href="item.href"
                class="flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition"
                :class="
                    isActive(item.href)
                        ? 'bg-black text-white'
                        : 'text-gray-700 hover:bg-gray-100'
                "
            >
                <component :is="item.icon" class="h-4 w-4" />
                <span>{{ item.title }}</span>
            </Link>
        </nav>

        <div class="border-t p-3">
            <Link
                href="/logout"
                method="post"
                as="button"
                class="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-red-600 hover:bg-red-50"
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
</script>

<template>
    <div class="flex min-h-screen bg-gray-50">
        <AppSidebar />

        <main class="min-w-0 flex-1">
            <slot />
        </main>
    </div>
</template>
VUE

python3 <<'PY'
from pathlib import Path

files = [
    'resources/js/pages/Admin/Dashboard.vue',
    'resources/js/pages/Admin/Laporan.vue',
    'resources/js/pages/Admin/Produk/Index.vue',
    'resources/js/pages/Admin/Produk/Form.vue',
    'resources/js/pages/Admin/Master/Kategori.vue',
    'resources/js/pages/Admin/Master/Satuan.vue',
    'resources/js/pages/Admin/Master/Supplier.vue',
    'resources/js/pages/Admin/Master/Pelanggan.vue',
    'resources/js/pages/Admin/Master/Pengguna.vue',
    'resources/js/pages/Admin/Transaksi/Index.vue',
    'resources/js/pages/Admin/Transaksi/Show.vue',
    'resources/js/pages/Admin/Stok/Index.vue',
    'resources/js/pages/Kasir/Index.vue',
    'resources/js/pages/Kasir/Struk.vue',
]

layout_import = "import AppLayout from '@/layouts/AppLayout.vue';"
layout_define = """defineOptions({
    layout: AppLayout,
});"""

for file in files:
    path = Path(file)
    if not path.exists():
        print(f"SKIP missing: {file}")
        continue

    text = path.read_text()

    if layout_import in text and "layout: AppLayout" in text:
        print(f"OK already: {file}")
        continue

    if "<script setup" not in text:
        text = f"""<script setup lang="ts">
{layout_import}

{layout_define}
</script>

""" + text
        path.write_text(text)
        print(f"PATCH no script: {file}")
        continue

    # Insert import after opening script tag if missing
    if layout_import not in text:
        lines = text.splitlines()
        for i, line in enumerate(lines):
            if line.strip().startswith("<script setup"):
                lines.insert(i + 1, layout_import)
                break
        text = "\n".join(lines) + ("\n" if text.endswith("\n") else "")

    # Insert defineOptions after imports if missing
    if "layout: AppLayout" not in text:
        lines = text.splitlines()
        insert_at = None
        for i, line in enumerate(lines):
            if line.strip().startswith("import "):
                insert_at = i + 1
        if insert_at is None:
            insert_at = 1
        lines.insert(insert_at, "")
        lines.insert(insert_at + 1, layout_define)
        text = "\n".join(lines) + ("\n" if text.endswith("\n") else "")

    path.write_text(text)
    print(f"PATCHED: {file}")
PY

echo "== Selesai =="
echo "Jalankan:"
echo "php artisan optimize:clear"
echo "npm run build"
echo "npm run dev"
