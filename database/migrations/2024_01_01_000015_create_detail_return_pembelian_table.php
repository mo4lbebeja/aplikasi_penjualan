// 2024_01_01_000015_create_detail_return_pembelian_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('detail_return_pembelian', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_return_pembelian')
                  ->constrained('return_pembelian')
                  ->cascadeOnDelete();
            $table->foreignId('id_produk')
                  ->constrained('produk')
                  ->restrictOnDelete();

            // Snapshot
            $table->string('nama_produk', 200);
            $table->decimal('harga_beli', 15, 2);
            $table->integer('jumlah');
            $table->decimal('subtotal', 15, 2);

            // Alasan per-item
            $table->enum('alasan_item', ['rusak', 'kadaluarsa', 'salah_kirim', 'kelebihan'])
                  ->default('rusak');

            $table->timestamps();

            $table->index('id_return_pembelian');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('detail_return_pembelian');
    }
};