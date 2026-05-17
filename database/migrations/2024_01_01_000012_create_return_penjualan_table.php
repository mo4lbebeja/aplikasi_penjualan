// 2024_01_01_000012_create_return_penjualan_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('return_penjualan', function (Blueprint $table) {
            $table->id();
            $table->string('kode_return', 30)->unique(); // RPS-20240101-0001

            // Harus terhubung ke transaksi penjualan asal
            $table->foreignId('id_transaksi_penjualan')
                  ->constrained('transaksi_penjualan')
                  ->restrictOnDelete();
            $table->foreignId('id_pengguna') // kasir/admin yang memproses return
                  ->constrained('users')
                  ->restrictOnDelete();

            $table->decimal('total_refund', 15, 2)->default(0);

            // Metode refund ke pelanggan
            $table->enum('metode_refund', ['tunai', 'poin', 'kredit_toko'])
                  ->default('tunai');

            $table->enum('status', ['diproses', 'selesai', 'ditolak'])
                  ->default('diproses');

            $table->text('alasan')->nullable();
            $table->text('keterangan')->nullable();
            $table->timestamps();

            $table->index('id_transaksi_penjualan');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('return_penjualan');
    }
};