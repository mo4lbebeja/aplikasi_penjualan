// 2024_01_01_000014_create_return_pembelian_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('return_pembelian', function (Blueprint $table) {
            $table->id();
            $table->string('kode_return', 30)->unique(); // RPB-20240101-0001

            // Opsional: bisa return tanpa PO (misal barang rusak dari supplier lama)
            $table->foreignId('id_transaksi_pembelian')
                  ->nullable()
                  ->constrained('transaksi_pembelian')
                  ->nullOnDelete();
            $table->foreignId('id_supplier')
                  ->constrained('supplier')
                  ->restrictOnDelete();
            $table->foreignId('id_pengguna')
                  ->constrained('users')
                  ->restrictOnDelete();

            $table->decimal('total_return', 15, 2)->default(0);

            // Penyelesaian dengan supplier
            $table->enum('penyelesaian', ['kredit', 'ganti_barang', 'tunai'])
                  ->default('kredit');

            $table->enum('status', ['disiapkan', 'dikirim', 'diterima_supplier', 'selesai'])
                  ->default('disiapkan');

            $table->text('alasan')->nullable();
            $table->text('keterangan')->nullable();
            $table->timestamps();

            $table->index(['id_supplier', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('return_pembelian');
    }
};