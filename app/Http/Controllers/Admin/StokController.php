<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use App\Models\StokMasuk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class StokController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Stok/Index', [
            'produk' => Produk::orderBy('nama')->get(),
            'items' => StokMasuk::with(['produk', 'user'])->latest()->paginate(20),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'produk_id' => 'required|exists:produk,id',
            'qty' => 'required|integer|min:1',
            'harga_beli' => 'nullable|numeric|min:0',
            'tanggal' => 'required|date',
            'keterangan' => 'nullable|string',
        ]);

        DB::transaction(function () use ($data) {
            StokMasuk::create($data + ['user_id' => auth()->id()]);
            Produk::whereKey($data['produk_id'])->increment('stok', $data['qty']);
            if (($data['harga_beli'] ?? 0) > 0) {
                Produk::whereKey($data['produk_id'])->update(['harga_beli' => $data['harga_beli']]);
            }
        });

        return back()->with('success', 'Stok masuk berhasil dicatat.');
    }
}
