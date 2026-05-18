<?php

use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\KategoriController;
use App\Http\Controllers\Admin\PelangganController;
use App\Http\Controllers\Admin\PenggunaController;
use App\Http\Controllers\Admin\ProdukController;
use App\Http\Controllers\Admin\SatuanController;
use App\Http\Controllers\Admin\StokController;
use App\Http\Controllers\Admin\SupplierController;
use App\Http\Controllers\Admin\TransaksiController;
use App\Http\Controllers\Kasir\KasirController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', fn () => redirect()->route('login'));

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/dashboard', function () {
        $user = auth()->user();

        if (($user->peran ?? null) === 'kasir') {
            return redirect()->route('kasir.pos');
        }

        return redirect()->route('admin.dashboard');
    })->name('dashboard');

    Route::middleware(['peran:admin,kasir'])
        ->prefix('kasir')
        ->name('kasir.')
        ->group(function () {
            Route::get('/', [KasirController::class, 'index'])->name('pos');
            Route::get('/produk', [KasirController::class, 'produk'])->name('produk');
            Route::get('/pelanggan', [KasirController::class, 'pelanggan'])->name('pelanggan');
            Route::post('/bayar', [KasirController::class, 'bayar'])->name('bayar');
            Route::get('/struk/{transaksi}', [KasirController::class, 'struk'])->name('struk');
        });

    Route::middleware(['peran:admin'])
        ->prefix('admin')
        ->name('admin.')
        ->group(function () {
            Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
            Route::get('/laporan', [DashboardController::class, 'laporan'])->name('laporan');

            Route::resource('produk', ProdukController::class);
            Route::resource('kategori', KategoriController::class)->except(['show']);
            Route::resource('satuan', SatuanController::class)->except(['show']);
            Route::resource('supplier', SupplierController::class)->except(['show']);
            Route::resource('pelanggan', PelangganController::class);
            Route::resource('pengguna', PenggunaController::class)->except(['show']);

            Route::get('/transaksi', [TransaksiController::class, 'index'])->name('transaksi.index');
            Route::get('/transaksi/{transaksi}', [TransaksiController::class, 'show'])->name('transaksi.show');
            Route::patch('/transaksi/{transaksi}/batal', [TransaksiController::class, 'batal'])->name('transaksi.batal');

            Route::get('/stok', [StokController::class, 'index'])->name('stok.index');
            Route::post('/stok', [StokController::class, 'store'])->name('stok.store');
        });
});

if (file_exists(__DIR__.'/settings.php')) {
    require __DIR__.'/settings.php';
}

if (file_exists(__DIR__.'/auth.php')) {
    require __DIR__.'/auth.php';
}
