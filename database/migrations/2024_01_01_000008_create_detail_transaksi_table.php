// 2024_01_01_000008_create_detail_transaksi_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('detail_transaksi', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_transaksi')
                  ->constrained('transaksi_penjualan')
                  ->cascadeOnDelete();
            $table->foreignId('id_produk')
                  ->constrained('produk')
                  ->restrictOnDelete();
            // Snapshot nama & harga saat transaksi terjadi
            // (harga produk bisa berubah di masa depan)
            $table->string('nama_produk', 200);
            $table->decimal('harga_satuan', 15, 2);
            $table->integer('jumlah');
            $table->decimal('diskon_item', 15, 2)->default(0);
            $table->decimal('subtotal', 15, 2);
            $table->timestamps();

            $table->index('id_transaksi');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('detail_transaksi');
    }
};