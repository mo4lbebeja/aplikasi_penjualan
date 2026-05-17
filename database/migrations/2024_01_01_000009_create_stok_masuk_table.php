// 2024_01_01_000009_create_stok_masuk_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('stok_masuk', function (Blueprint $table) {
            $table->id();
            $table->string('kode_stok', 30)->unique();  // STK-20240101-0001
            $table->foreignId('id_produk')
                  ->constrained('produk')
                  ->restrictOnDelete();
            $table->foreignId('id_supplier')
                  ->nullable()
                  ->constrained('supplier')
                  ->nullOnDelete();
            $table->foreignId('id_pengguna')
                  ->constrained('users')
                  ->restrictOnDelete();
            $table->integer('jumlah');
            $table->integer('stok_sebelum');   // untuk audit trail
            $table->integer('stok_sesudah');
            $table->decimal('harga_beli', 15, 2)->default(0);
            $table->decimal('total_harga', 15, 2)->default(0);
            $table->string('no_faktur', 50)->nullable();
            $table->text('keterangan')->nullable();
            $table->timestamps();

            $table->index(['id_produk', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('stok_masuk');
    }
};