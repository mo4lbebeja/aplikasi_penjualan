// 2024_01_01_000016_modify_stok_masuk_tambah_sumber.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('stok_masuk', function (Blueprint $table) {
            // Sumber stok masuk:
            // pembelian   → dari transaksi_pembelian
            // penyesuaian → stok opname / koreksi manual
            // retur       → dari return_penjualan (barang kondisi baik)
            $table->enum('jenis', ['pembelian', 'penyesuaian', 'retur'])
                  ->default('pembelian')
                  ->after('kode_stok');

            // Link opsional ke transaksi pembelian
            $table->foreignId('id_transaksi_pembelian')
                  ->nullable()
                  ->after('jenis')
                  ->constrained('transaksi_pembelian')
                  ->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('stok_masuk', function (Blueprint $table) {
            $table->dropConstrainedForeignId('id_transaksi_pembelian');
            $table->dropColumn('jenis');
        });
    }
};