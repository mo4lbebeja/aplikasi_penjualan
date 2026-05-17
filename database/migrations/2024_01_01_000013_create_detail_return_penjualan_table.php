// 2024_01_01_000013_create_detail_return_penjualan_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('detail_return_penjualan', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_return_penjualan')
                  ->constrained('return_penjualan')
                  ->cascadeOnDelete();

            // Referensi ke item detail transaksi asal (untuk validasi)
            $table->foreignId('id_detail_transaksi')
                  ->constrained('detail_transaksi')
                  ->restrictOnDelete();
            $table->foreignId('id_produk')
                  ->constrained('produk')
                  ->restrictOnDelete();

            // Snapshot
            $table->string('nama_produk', 200);
            $table->decimal('harga_satuan', 15, 2);

            $table->integer('jumlah_return');

            // Kondisi barang yang dikembalikan:
            // baik  → stok dikembalikan ke gudang
            // rusak → stok TIDAK dikembalikan, barang dibuang/disisihkan
            $table->enum('kondisi_barang', ['baik', 'rusak'])->default('baik');

            $table->decimal('subtotal_refund', 15, 2);
            $table->timestamps();

            $table->index('id_return_penjualan');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('detail_return_penjualan');
    }
};