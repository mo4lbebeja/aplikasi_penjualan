// 2024_01_01_000010_create_transaksi_pembelian_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transaksi_pembelian', function (Blueprint $table) {
            $table->id();
            $table->string('kode_pembelian', 30)->unique(); // PBL-20240101-0001
            $table->foreignId('id_supplier')
                  ->constrained('supplier')
                  ->restrictOnDelete();
            $table->foreignId('id_pengguna')
                  ->constrained('users')
                  ->restrictOnDelete();

            // Status alur pembelian
            // draft     → PO dibuat, belum dikirim ke supplier
            // dipesan   → sudah dikirim ke supplier, menunggu barang
            // sebagian  → sebagian barang sudah diterima
            // diterima  → semua barang diterima, stok sudah diupdate
            // batal     → dibatalkan
            $table->enum('status', ['draft', 'dipesan', 'sebagian', 'diterima', 'batal'])
                  ->default('draft');

            $table->decimal('subtotal', 15, 2)->default(0);
            $table->decimal('diskon', 15, 2)->default(0);
            $table->decimal('biaya_kirim', 15, 2)->default(0);
            $table->decimal('total', 15, 2)->default(0);
            $table->decimal('total_bayar', 15, 2)->default(0); // sudah dibayar
            $table->decimal('sisa_tagihan', 15, 2)->default(0); // hutang ke supplier

            $table->enum('metode_bayar', ['tunai', 'transfer', 'tempo'])
                  ->default('tunai');
            $table->date('jatuh_tempo')->nullable(); // untuk metode tempo

            $table->string('no_faktur_supplier', 60)->nullable(); // nomor nota dari supplier
            $table->date('tanggal_faktur')->nullable();
            $table->text('keterangan')->nullable();
            $table->timestamps();

            $table->index(['id_supplier', 'status']);
            $table->index(['created_at', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaksi_pembelian');
    }
};