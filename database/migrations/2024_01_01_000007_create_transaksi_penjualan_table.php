// 2024_01_01_000007_create_transaksi_penjualan_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transaksi_penjualan', function (Blueprint $table) {
            $table->id();
            $table->string('kode_transaksi', 30)->unique(); // TRX-20240101-0001
            $table->foreignId('id_pelanggan')
                  ->nullable()
                  ->constrained('pelanggan')
                  ->nullOnDelete();
            $table->foreignId('id_pengguna')  // kasir yang memproses
                  ->constrained('users')
                  ->restrictOnDelete();
            $table->decimal('subtotal', 15, 2);
            $table->decimal('diskon', 15, 2)->default(0);
            $table->decimal('total', 15, 2);
            $table->decimal('total_bayar', 15, 2);
            $table->decimal('kembalian', 15, 2)->default(0);
            $table->enum('metode_bayar', ['tunai', 'debit', 'kredit', 'qris', 'transfer'])
                  ->default('tunai');
            $table->enum('status', ['selesai', 'batal', 'menunggu'])
                  ->default('selesai');
            $table->text('keterangan')->nullable();
            $table->timestamps();

            $table->index('kode_transaksi');
            $table->index(['created_at', 'status']); // untuk laporan per periode
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaksi_penjualan');
    }
};