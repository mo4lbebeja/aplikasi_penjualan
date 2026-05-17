// 2024_01_01_000011_create_detail_pembelian_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('detail_pembelian', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_transaksi_pembelian')
                  ->constrained('transaksi_pembelian')
                  ->cascadeOnDelete();
            $table->foreignId('id_produk')
                  ->constrained('produk')
                  ->restrictOnDelete();

            // Snapshot nama & harga beli saat pembelian
            $table->string('nama_produk', 200);
            $table->decimal('harga_beli', 15, 2);

            $table->integer('jumlah_pesan');    // qty yang dipesan
            $table->integer('jumlah_diterima')->default(0); // qty yang benar-benar datang
                                                            // (bisa lebih sedikit dari pesan)
            $table->decimal('diskon_item', 15, 2)->default(0);
            $table->decimal('subtotal', 15, 2); // berdasarkan jumlah_diterima
            $table->timestamps();

            $table->index('id_transaksi_pembelian');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('detail_pembelian');
    }
};