#!/usr/bin/env bash
set -e

echo "== Memasang halaman CRUD master data =="

mkdir -p resources/js/pages/Admin/Master

cat > resources/js/pages/Admin/Master/Kategori.vue <<'VUE'
<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { router, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

defineOptions({
    layout: AppLayout,
});

defineProps<{ items: any[] }>();

const editingId = ref<number | null>(null);

const form = useForm({
    nama: '',
    keterangan: '',
});

function resetForm() {
    editingId.value = null;
    form.reset();
    form.clearErrors();
}

function edit(item: any) {
    editingId.value = item.id;
    form.nama = item.nama || '';
    form.keterangan = item.keterangan || '';
}

function submit() {
    if (editingId.value) {
        form.put(`/admin/kategori/${editingId.value}`, {
            preserveScroll: true,
            onSuccess: resetForm,
        });
        return;
    }

    form.post('/admin/kategori', {
        preserveScroll: true,
        onSuccess: resetForm,
    });
}

function hapus(item: any) {
    if (!confirm(`Hapus kategori "${item.nama}"?`)) return;

    router.delete(`/admin/kategori/${item.id}`, {
        preserveScroll: true,
    });
}
</script>

<template>
    <div class="space-y-6 p-6">
        <div>
            <h1 class="text-2xl font-bold">Kategori Produk</h1>
            <p class="text-sm text-gray-500">Kelola kategori produk toko.</p>
        </div>

        <form @submit.prevent="submit" class="grid gap-3 rounded-xl border bg-white p-4 md:grid-cols-3">
            <div>
                <label class="text-sm font-medium">Nama Kategori</label>
                <input v-model="form.nama" class="mt-1 w-full rounded border p-2" placeholder="Contoh: Beras & Tepung" />
                <div v-if="form.errors.nama" class="mt-1 text-xs text-red-600">{{ form.errors.nama }}</div>
            </div>

            <div>
                <label class="text-sm font-medium">Keterangan</label>
                <input v-model="form.keterangan" class="mt-1 w-full rounded border p-2" placeholder="Opsional" />
            </div>

            <div class="flex items-end gap-2">
                <button class="rounded bg-black px-4 py-2 text-white" :disabled="form.processing">
                    {{ editingId ? 'Update' : 'Simpan' }}
                </button>
                <button v-if="editingId" type="button" @click="resetForm" class="rounded border px-4 py-2">
                    Batal
                </button>
            </div>
        </form>

        <div class="overflow-hidden rounded-xl border bg-white">
            <table class="w-full text-sm">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-3 text-left">Nama</th>
                        <th class="p-3 text-left">Slug</th>
                        <th class="p-3 text-left">Keterangan</th>
                        <th class="p-3 text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in items" :key="item.id" class="border-t">
                        <td class="p-3 font-medium">{{ item.nama }}</td>
                        <td class="p-3 text-gray-500">{{ item.slug }}</td>
                        <td class="p-3">{{ item.keterangan || '-' }}</td>
                        <td class="space-x-2 p-3 text-right">
                            <button @click="edit(item)" class="rounded border px-3 py-1">Edit</button>
                            <button @click="hapus(item)" class="rounded border px-3 py-1 text-red-600">Hapus</button>
                        </td>
                    </tr>
                    <tr v-if="items.length === 0">
                        <td colspan="4" class="p-4 text-center text-gray-500">Belum ada data.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
VUE

cat > resources/js/pages/Admin/Master/Satuan.vue <<'VUE'
<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { router, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

defineOptions({
    layout: AppLayout,
});

defineProps<{ items: any[] }>();

const editingId = ref<number | null>(null);

const form = useForm({
    nama: '',
    singkatan: '',
});

function resetForm() {
    editingId.value = null;
    form.reset();
    form.clearErrors();
}

function edit(item: any) {
    editingId.value = item.id;
    form.nama = item.nama || '';
    form.singkatan = item.singkatan || '';
}

function submit() {
    if (editingId.value) {
        form.put(`/admin/satuan/${editingId.value}`, {
            preserveScroll: true,
            onSuccess: resetForm,
        });
        return;
    }

    form.post('/admin/satuan', {
        preserveScroll: true,
        onSuccess: resetForm,
    });
}

function hapus(item: any) {
    if (!confirm(`Hapus satuan "${item.nama}"?`)) return;

    router.delete(`/admin/satuan/${item.id}`, {
        preserveScroll: true,
    });
}
</script>

<template>
    <div class="space-y-6 p-6">
        <div>
            <h1 class="text-2xl font-bold">Satuan</h1>
            <p class="text-sm text-gray-500">Kelola satuan produk.</p>
        </div>

        <form @submit.prevent="submit" class="grid gap-3 rounded-xl border bg-white p-4 md:grid-cols-3">
            <div>
                <label class="text-sm font-medium">Nama Satuan</label>
                <input v-model="form.nama" class="mt-1 w-full rounded border p-2" placeholder="Contoh: Kilogram" />
                <div v-if="form.errors.nama" class="mt-1 text-xs text-red-600">{{ form.errors.nama }}</div>
            </div>

            <div>
                <label class="text-sm font-medium">Singkatan</label>
                <input v-model="form.singkatan" class="mt-1 w-full rounded border p-2" placeholder="Contoh: kg" />
            </div>

            <div class="flex items-end gap-2">
                <button class="rounded bg-black px-4 py-2 text-white" :disabled="form.processing">
                    {{ editingId ? 'Update' : 'Simpan' }}
                </button>
                <button v-if="editingId" type="button" @click="resetForm" class="rounded border px-4 py-2">
                    Batal
                </button>
            </div>
        </form>

        <div class="overflow-hidden rounded-xl border bg-white">
            <table class="w-full text-sm">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-3 text-left">Nama</th>
                        <th class="p-3 text-left">Singkatan</th>
                        <th class="p-3 text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in items" :key="item.id" class="border-t">
                        <td class="p-3 font-medium">{{ item.nama }}</td>
                        <td class="p-3">{{ item.singkatan || '-' }}</td>
                        <td class="space-x-2 p-3 text-right">
                            <button @click="edit(item)" class="rounded border px-3 py-1">Edit</button>
                            <button @click="hapus(item)" class="rounded border px-3 py-1 text-red-600">Hapus</button>
                        </td>
                    </tr>
                    <tr v-if="items.length === 0">
                        <td colspan="3" class="p-4 text-center text-gray-500">Belum ada data.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
VUE

cat > resources/js/pages/Admin/Master/Supplier.vue <<'VUE'
<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { router, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

defineOptions({
    layout: AppLayout,
});

defineProps<{ items: any[] }>();

const editingId = ref<number | null>(null);

const form = useForm({
    kode_supplier: '',
    nama: '',
    nama_kontak: '',
    telepon: '',
    alamat: '',
    aktif: true,
});

function resetForm() {
    editingId.value = null;
    form.reset();
    form.aktif = true;
    form.clearErrors();
}

function edit(item: any) {
    editingId.value = item.id;
    form.kode_supplier = item.kode_supplier || '';
    form.nama = item.nama || '';
    form.nama_kontak = item.nama_kontak || '';
    form.telepon = item.telepon || '';
    form.alamat = item.alamat || '';
    form.aktif = Boolean(item.aktif);
}

function submit() {
    if (editingId.value) {
        form.put(`/admin/supplier/${editingId.value}`, {
            preserveScroll: true,
            onSuccess: resetForm,
        });
        return;
    }

    form.post('/admin/supplier', {
        preserveScroll: true,
        onSuccess: resetForm,
    });
}

function hapus(item: any) {
    if (!confirm(`Hapus supplier "${item.nama}"?`)) return;

    router.delete(`/admin/supplier/${item.id}`, {
        preserveScroll: true,
    });
}
</script>

<template>
    <div class="space-y-6 p-6">
        <div>
            <h1 class="text-2xl font-bold">Supplier</h1>
            <p class="text-sm text-gray-500">Kelola data supplier.</p>
        </div>

        <form @submit.prevent="submit" class="grid gap-3 rounded-xl border bg-white p-4 md:grid-cols-3">
            <div>
                <label class="text-sm font-medium">Kode Supplier</label>
                <input v-model="form.kode_supplier" class="mt-1 w-full rounded border p-2" placeholder="Kosongkan untuk otomatis" />
            </div>

            <div>
                <label class="text-sm font-medium">Nama Supplier</label>
                <input v-model="form.nama" class="mt-1 w-full rounded border p-2" placeholder="Nama supplier" />
                <div v-if="form.errors.nama" class="mt-1 text-xs text-red-600">{{ form.errors.nama }}</div>
            </div>

            <div>
                <label class="text-sm font-medium">Nama Kontak</label>
                <input v-model="form.nama_kontak" class="mt-1 w-full rounded border p-2" placeholder="Nama kontak" />
            </div>

            <div>
                <label class="text-sm font-medium">Telepon</label>
                <input v-model="form.telepon" class="mt-1 w-full rounded border p-2" placeholder="Nomor telepon" />
            </div>

            <div class="md:col-span-2">
                <label class="text-sm font-medium">Alamat</label>
                <input v-model="form.alamat" class="mt-1 w-full rounded border p-2" placeholder="Alamat" />
            </div>

            <div class="flex items-end gap-2 md:col-span-3">
                <button class="rounded bg-black px-4 py-2 text-white" :disabled="form.processing">
                    {{ editingId ? 'Update' : 'Simpan' }}
                </button>
                <button v-if="editingId" type="button" @click="resetForm" class="rounded border px-4 py-2">
                    Batal
                </button>
            </div>
        </form>

        <div class="overflow-hidden rounded-xl border bg-white">
            <table class="w-full text-sm">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-3 text-left">Kode</th>
                        <th class="p-3 text-left">Nama</th>
                        <th class="p-3 text-left">Kontak</th>
                        <th class="p-3 text-left">Telepon</th>
                        <th class="p-3 text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in items" :key="item.id" class="border-t">
                        <td class="p-3">{{ item.kode_supplier }}</td>
                        <td class="p-3 font-medium">{{ item.nama }}</td>
                        <td class="p-3">{{ item.nama_kontak || '-' }}</td>
                        <td class="p-3">{{ item.telepon || '-' }}</td>
                        <td class="space-x-2 p-3 text-right">
                            <button @click="edit(item)" class="rounded border px-3 py-1">Edit</button>
                            <button @click="hapus(item)" class="rounded border px-3 py-1 text-red-600">Hapus</button>
                        </td>
                    </tr>
                    <tr v-if="items.length === 0">
                        <td colspan="5" class="p-4 text-center text-gray-500">Belum ada data.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
VUE

cat > resources/js/pages/Admin/Master/Pelanggan.vue <<'VUE'
<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { router, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

defineOptions({
    layout: AppLayout,
});

defineProps<{ items: any[] }>();

const editingId = ref<number | null>(null);

const form = useForm({
    nama: '',
    telepon: '',
    alamat: '',
});

function resetForm() {
    editingId.value = null;
    form.reset();
    form.clearErrors();
}

function edit(item: any) {
    editingId.value = item.id;
    form.nama = item.nama || '';
    form.telepon = item.telepon || '';
    form.alamat = item.alamat || '';
}

function submit() {
    if (editingId.value) {
        form.put(`/admin/pelanggan/${editingId.value}`, {
            preserveScroll: true,
            onSuccess: resetForm,
        });
        return;
    }

    form.post('/admin/pelanggan', {
        preserveScroll: true,
        onSuccess: resetForm,
    });
}

function hapus(item: any) {
    if (!confirm(`Hapus pelanggan "${item.nama}"?`)) return;

    router.delete(`/admin/pelanggan/${item.id}`, {
        preserveScroll: true,
    });
}
</script>

<template>
    <div class="space-y-6 p-6">
        <div>
            <h1 class="text-2xl font-bold">Pelanggan</h1>
            <p class="text-sm text-gray-500">Kelola data pelanggan.</p>
        </div>

        <form @submit.prevent="submit" class="grid gap-3 rounded-xl border bg-white p-4 md:grid-cols-3">
            <div>
                <label class="text-sm font-medium">Nama Pelanggan</label>
                <input v-model="form.nama" class="mt-1 w-full rounded border p-2" placeholder="Nama pelanggan" />
                <div v-if="form.errors.nama" class="mt-1 text-xs text-red-600">{{ form.errors.nama }}</div>
            </div>

            <div>
                <label class="text-sm font-medium">Telepon</label>
                <input v-model="form.telepon" class="mt-1 w-full rounded border p-2" placeholder="Nomor telepon" />
            </div>

            <div>
                <label class="text-sm font-medium">Alamat</label>
                <input v-model="form.alamat" class="mt-1 w-full rounded border p-2" placeholder="Alamat" />
            </div>

            <div class="flex items-end gap-2 md:col-span-3">
                <button class="rounded bg-black px-4 py-2 text-white" :disabled="form.processing">
                    {{ editingId ? 'Update' : 'Simpan' }}
                </button>
                <button v-if="editingId" type="button" @click="resetForm" class="rounded border px-4 py-2">
                    Batal
                </button>
            </div>
        </form>

        <div class="overflow-hidden rounded-xl border bg-white">
            <table class="w-full text-sm">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-3 text-left">Nama</th>
                        <th class="p-3 text-left">Telepon</th>
                        <th class="p-3 text-left">Alamat</th>
                        <th class="p-3 text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in items" :key="item.id" class="border-t">
                        <td class="p-3 font-medium">{{ item.nama }}</td>
                        <td class="p-3">{{ item.telepon || '-' }}</td>
                        <td class="p-3">{{ item.alamat || '-' }}</td>
                        <td class="space-x-2 p-3 text-right">
                            <button @click="edit(item)" class="rounded border px-3 py-1">Edit</button>
                            <button @click="hapus(item)" class="rounded border px-3 py-1 text-red-600">Hapus</button>
                        </td>
                    </tr>
                    <tr v-if="items.length === 0">
                        <td colspan="4" class="p-4 text-center text-gray-500">Belum ada data.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
VUE

cat > resources/js/pages/Admin/Master/Pengguna.vue <<'VUE'
<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { router, useForm, usePage } from '@inertiajs/vue3';
import { ref } from 'vue';

defineOptions({
    layout: AppLayout,
});

defineProps<{ items: any[] }>();

const page = usePage();
const currentUser = page.props.auth?.user as any;
const editingId = ref<number | null>(null);

const form = useForm({
    nama: '',
    email: '',
    peran: 'kasir',
    password: '',
    aktif: true,
});

function resetForm() {
    editingId.value = null;
    form.reset();
    form.peran = 'kasir';
    form.aktif = true;
    form.clearErrors();
}

function edit(item: any) {
    editingId.value = item.id;
    form.nama = item.nama || item.name || '';
    form.email = item.email || '';
    form.peran = item.peran || 'kasir';
    form.password = '';
    form.aktif = Boolean(item.aktif);
}

function submit() {
    if (editingId.value) {
        form.put(`/admin/pengguna/${editingId.value}`, {
            preserveScroll: true,
            onSuccess: resetForm,
        });
        return;
    }

    form.post('/admin/pengguna', {
        preserveScroll: true,
        onSuccess: resetForm,
    });
}

function hapus(item: any) {
    if (item.id === currentUser?.id) {
        alert('Tidak bisa menghapus akun sendiri.');
        return;
    }

    if (!confirm(`Hapus pengguna "${item.nama || item.name}"?`)) return;

    router.delete(`/admin/pengguna/${item.id}`, {
        preserveScroll: true,
    });
}
</script>

<template>
    <div class="space-y-6 p-6">
        <div>
            <h1 class="text-2xl font-bold">Pengguna</h1>
            <p class="text-sm text-gray-500">Kelola akun admin dan kasir.</p>
        </div>

        <form @submit.prevent="submit" class="grid gap-3 rounded-xl border bg-white p-4 md:grid-cols-3">
            <div>
                <label class="text-sm font-medium">Nama</label>
                <input v-model="form.nama" class="mt-1 w-full rounded border p-2" placeholder="Nama pengguna" />
                <div v-if="form.errors.nama" class="mt-1 text-xs text-red-600">{{ form.errors.nama }}</div>
            </div>

            <div>
                <label class="text-sm font-medium">Email</label>
                <input v-model="form.email" type="email" class="mt-1 w-full rounded border p-2" placeholder="Email" />
                <div v-if="form.errors.email" class="mt-1 text-xs text-red-600">{{ form.errors.email }}</div>
            </div>

            <div>
                <label class="text-sm font-medium">Peran</label>
                <select v-model="form.peran" class="mt-1 w-full rounded border p-2">
                    <option value="admin">Admin</option>
                    <option value="kasir">Kasir</option>
                </select>
            </div>

            <div>
                <label class="text-sm font-medium">Password</label>
                <input v-model="form.password" type="password" class="mt-1 w-full rounded border p-2" :placeholder="editingId ? 'Kosongkan jika tidak diubah' : 'Minimal 6 karakter'" />
                <div v-if="form.errors.password" class="mt-1 text-xs text-red-600">{{ form.errors.password }}</div>
            </div>

            <label class="flex items-end gap-2 pb-2">
                <input v-model="form.aktif" type="checkbox" />
                <span class="text-sm">Aktif</span>
            </label>

            <div class="flex items-end gap-2">
                <button class="rounded bg-black px-4 py-2 text-white" :disabled="form.processing">
                    {{ editingId ? 'Update' : 'Simpan' }}
                </button>
                <button v-if="editingId" type="button" @click="resetForm" class="rounded border px-4 py-2">
                    Batal
                </button>
            </div>
        </form>

        <div class="overflow-hidden rounded-xl border bg-white">
            <table class="w-full text-sm">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-3 text-left">Nama</th>
                        <th class="p-3 text-left">Email</th>
                        <th class="p-3 text-left">Peran</th>
                        <th class="p-3 text-left">Status</th>
                        <th class="p-3 text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in items" :key="item.id" class="border-t">
                        <td class="p-3 font-medium">{{ item.nama || item.name }}</td>
                        <td class="p-3">{{ item.email }}</td>
                        <td class="p-3 uppercase">{{ item.peran }}</td>
                        <td class="p-3">
                            <span :class="item.aktif ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'" class="rounded px-2 py-1 text-xs">
                                {{ item.aktif ? 'Aktif' : 'Nonaktif' }}
                            </span>
                        </td>
                        <td class="space-x-2 p-3 text-right">
                            <button @click="edit(item)" class="rounded border px-3 py-1">Edit</button>
                            <button @click="hapus(item)" class="rounded border px-3 py-1 text-red-600">Hapus</button>
                        </td>
                    </tr>
                    <tr v-if="items.length === 0">
                        <td colspan="5" class="p-4 text-center text-gray-500">Belum ada data.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
VUE

echo "== Selesai memasang CRUD master data =="
echo "Jalankan:"
echo "npm run build"
echo "npm run dev"
