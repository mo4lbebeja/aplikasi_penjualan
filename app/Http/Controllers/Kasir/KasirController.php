<?php

namespace App\Http\Controllers\Kasir;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use App\Models\Produk;
use App\Models\TransaksiPenjualan;
use App\Models\DetailTransaksi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class KasirController extends Controller
{
    public function index()
    {
        return Inertia::render('Kasir/Index', [
            'produkAwal' => Produk::with(['kategori', 'satuan'])->where('aktif', true)->where('stok', '>', 0)->orderBy('nama')->limit(20)->get(),
            'pelangganAwal' => Pelanggan::orderBy('nama')->limit(20)->get(),
        ]);
    }

    public function produk(Request $request)
    {
        return Produk::with(['kategori', 'satuan'])
            ->where('aktif', true)
            ->where('stok', '>', 0)
            ->when($request->q, fn ($q) => $q->where(function ($qq) use ($request) {
                $qq->where('nama', 'like', '%'.$request->q.'%')
                    ->orWhere('kode_produk', 'like', '%'.$request->q.'%')
                    ->orWhere('barcode', 'like', '%'.$request->q.'%');
            }))
            ->orderBy('nama')
            ->limit(30)
            ->get();
    }

    public function pelanggan(Request $request)
    {
        return Pelanggan::when($request->q, fn ($q) => $q->where('nama', 'like', '%'.$request->q.'%')->orWhere('telepon', 'like', '%'.$request->q.'%'))
            ->orderBy('nama')
            ->limit(30)
            ->get();
    }

    public function bayar(Request $request)
    {
        $data = $request->validate([
            'pelanggan_id' => 'nullable|exists:pelanggan,id',
            'items' => 'required|array|min:1',
            'items.*.produk_id' => 'required|exists:produk,id',
            'items.*.qty' => 'required|integer|min:1',
            'diskon' => 'nullable|numeric|min:0',
            'bayar' => 'required|numeric|min:0',
        ]);

        $transaksi = DB::transaction(function () use ($data) {
            $subtotal = 0;
            $itemsFinal = [];

            foreach ($data['items'] as $item) {
                $produk = Produk::lockForUpdate()->findOrFail($item['produk_id']);
                if ($produk->stok < $item['qty']) {
                    abort(422, 'Stok '.$produk->nama.' tidak cukup.');
                }
                $lineSubtotal = $produk->harga_jual * $item['qty'];
                $subtotal += $lineSubtotal;
                $itemsFinal[] = [$produk, $item['qty'], $produk->harga_jual, $lineSubtotal];
            }

            $diskon = (float) ($data['diskon'] ?? 0);
            $total = max(0, $subtotal - $diskon);
            $bayar = (float) $data['bayar'];

            if ($bayar < $total) {
                abort(422, 'Nominal bayar kurang.');
            }

            $transaksi = TransaksiPenjualan::create([
                'nomor_transaksi' => 'TRX'.now()->format('YmdHis'),
                'user_id' => auth()->id(),
                'pelanggan_id' => $data['pelanggan_id'] ?? null,
                'tanggal' => now(),
                'subtotal' => $subtotal,
                'diskon' => $diskon,
                'total' => $total,
                'bayar' => $bayar,
                'kembalian' => $bayar - $total,
                'status' => 'selesai',
            ]);

            foreach ($itemsFinal as [$produk, $qty, $harga, $lineSubtotal]) {
                DetailTransaksi::create([
                    'transaksi_penjualan_id' => $transaksi->id,
                    'produk_id' => $produk->id,
                    'qty' => $qty,
                    'harga' => $harga,
                    'subtotal' => $lineSubtotal,
                ]);

                $produk->decrement('stok', $qty);
            }

            return $transaksi;
        });

        return redirect()->route('kasir.struk', $transaksi)->with('success', 'Transaksi berhasil.');
    }

    public function struk(TransaksiPenjualan $transaksi)
    {
        return Inertia::render('Kasir/Struk', [
            'transaksi' => $transaksi->load(['kasir', 'pelanggan', 'detail.produk']),
        ]);
    }
}
