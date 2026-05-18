<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\TransaksiPenjualan;
use Inertia\Inertia;

class TransaksiController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Transaksi/Index', [
            'items' => TransaksiPenjualan::with(['kasir', 'pelanggan'])->latest('tanggal')->paginate(20),
        ]);
    }

    public function show(TransaksiPenjualan $transaksi)
    {
        return Inertia::render('Admin/Transaksi/Show', [
            'transaksi' => $transaksi->load(['kasir', 'pelanggan', 'detail.produk']),
        ]);
    }

    public function batal(TransaksiPenjualan $transaksi)
    {
        if ($transaksi->status === 'batal') {
            return back();
        }

        foreach ($transaksi->detail as $detail) {
            $detail->produk?->increment('stok', $detail->qty);
        }

        $transaksi->update(['status' => 'batal']);

        return back()->with('success', 'Transaksi dibatalkan dan stok dikembalikan.');
    }
}
