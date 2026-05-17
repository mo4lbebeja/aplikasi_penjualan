// 2024_01_01_000005_create_produk_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('produk', function (Blueprint $table) {
            $table->id();
            $table->string('kode_produk', 30)->unique();  // PRD-0001
            $table->string('barcode', 50)->nullable()->unique();
            $table->string('nama', 200);
            $table->foreignId('id_kategori_produk')
                  ->constrained('kategori_produk')
                  ->restrictOnDelete();
            $table->foreignId('id_satuan')
                  ->constrained('satuan')
                  ->restrictOnDelete();
            $table->decimal('harga_beli', 15, 2)->default(0);
            $table->decimal('harga_jual', 15, 2);
            $table->integer('stok')->default(0);
            $table->integer('stok_minimum')->default(5); // ambang peringatan
            $table->string('gambar')->nullable();
            $table->text('keterangan')->nullable();
            $table->boolean('aktif')->default(true);
            $table->timestamps();
            $table->softDeletes();

            $table->index('nama');
            $table->index('aktif');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('produk');
    }
};