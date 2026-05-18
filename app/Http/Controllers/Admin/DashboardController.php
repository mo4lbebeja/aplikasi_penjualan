<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use App\Models\TransaksiPenjualan;
use Illuminate\Http\Request;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Dashboard', [
            'stats' => [
                'produk' => Produk::count(),
                'stok_menipis' => Produk::whereColumn('stok', '<=', 'stok_minimum')->count(),
                'transaksi_hari_ini' => TransaksiPenjualan::whereDate('created_at', today())->count(),
                'penjualan_hari_ini' => TransaksiPenjualan::whereDate('created_at', today())
                    ->where('status', 'selesai')
                    ->sum('total'),
            ],
            'stokMenipis' => Produk::with(['kategori', 'satuan'])
                ->whereColumn('stok', '<=', 'stok_minimum')
                ->orderBy('stok')
                ->limit(10)
                ->get(),
            'transaksiTerbaru' => TransaksiPenjualan::with(['kasir', 'pelanggan'])
                ->latest()
                ->limit(10)
                ->get(),
        ]);
    }

    public function laporan(Request $request)
    {
        $mulai = $request->get('mulai', now()->startOfMonth()->toDateString());
        $selesai = $request->get('selesai', now()->toDateString());

        return Inertia::render('Admin/Laporan', [
            'filter' => compact('mulai', 'selesai'),
            'transaksi' => TransaksiPenjualan::with(['kasir', 'pelanggan'])
                ->whereBetween('created_at', [
                    $mulai . ' 00:00:00',
                    $selesai . ' 23:59:59',
                ])
                ->latest()
                ->get(),
        ]);
    }
}