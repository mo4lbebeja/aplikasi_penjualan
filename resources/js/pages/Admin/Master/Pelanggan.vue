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
