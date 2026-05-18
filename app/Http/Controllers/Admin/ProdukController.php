<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\KategoriProduk;
use App\Models\Produk;
use App\Models\Satuan;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ProdukController extends Controller
{
    public function index(Request $request)
    {
        return Inertia::render('Admin/Produk/Index', [
            'filters' => ['q' => $request->q],
            'produk' => Produk::with(['kategori', 'satuan'])
                ->when($request->q, fn ($q) => $q->where('nama', 'like', '%'.$request->q.'%')->orWhere('kode_produk', 'like', '%'.$request->q.'%'))
                ->latest()
                ->paginate(15)
                ->withQueryString(),
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Produk/Form', [
            'produk' => null,
            'kategori' => KategoriProduk::orderBy('nama')->get(),
            'satuan' => Satuan::orderBy('nama')->get(),
        ]);
    }

    public function store(Request $request)
    {
        Produk::create($this->validated($request) + [
            'kode_produk' => $request->kode_produk ?: 'PRD'.now()->format('YmdHis'),
        ]);

        return redirect()->route('admin.produk.index')->with('success', 'Produk berhasil dibuat.');
    }

    public function show(Produk $produk)
    {
        return redirect()->route('admin.produk.edit', $produk);
    }

    public function edit(Produk $produk)
    {
        return Inertia::render('Admin/Produk/Form', [
            'produk' => $produk,
            'kategori' => KategoriProduk::orderBy('nama')->get(),
            'satuan' => Satuan::orderBy('nama')->get(),
        ]);
    }

    public function update(Request $request, Produk $produk)
    {
        $produk->update($this->validated($request, $produk->id));

        return redirect()->route('admin.produk.index')->with('success', 'Produk berhasil diperbarui.');
    }

    public function destroy(Produk $produk)
    {
        $produk->delete();

        return back()->with('success', 'Produk berhasil dihapus.');
    }

    private function validated(Request $request, ?int $id = null): array
    {
        return $request->validate([
            'kode_produk' => ['nullable', 'string', 'max:100', 'unique:produk,kode_produk,'.$id],
            'barcode' => ['nullable', 'string', 'max:100', 'unique:produk,barcode,'.$id],
            'nama' => ['required', 'string', 'max:255'],
            'id_kategori_produk' => ['required', 'exists:kategori_produk,id'],
            'id_satuan' => ['required', 'exists:satuan,id'],
            'harga_beli' => ['required', 'numeric', 'min:0'],
            'harga_jual' => ['required', 'numeric', 'min:0'],
            'stok' => ['required', 'integer', 'min:0'],
            'stok_minimum' => ['required', 'integer', 'min:0'],
            'aktif' => ['boolean'],
        ]);
    }
}
