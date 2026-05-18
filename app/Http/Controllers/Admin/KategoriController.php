<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\KategoriProduk;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class KategoriController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Master/Kategori', [
            'items' => KategoriProduk::latest()->get(),
        ]);
    }

    public function create()
    {
        return redirect()->route('admin.kategori.index');
    }

    public function edit(KategoriProduk $kategori)
    {
        return redirect()->route('admin.kategori.index');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'nama' => ['required', 'string', 'max:255'],
            'keterangan' => ['nullable', 'string'],
        ]);

        $data['slug'] = Str::slug($data['nama']);

        KategoriProduk::create($data);

        return back()->with('success', 'Kategori berhasil dibuat.');
    }

    public function update(Request $request, KategoriProduk $kategori)
    {
        $data = $request->validate([
            'nama' => ['required', 'string', 'max:255'],
            'keterangan' => ['nullable', 'string'],
        ]);

        $data['slug'] = Str::slug($data['nama']);

        $kategori->update($data);

        return back()->with('success', 'Kategori berhasil diperbarui.');
    }

    public function destroy(KategoriProduk $kategori)
    {
        $kategori->delete();

        return back()->with('success', 'Kategori berhasil dihapus.');
    }
}