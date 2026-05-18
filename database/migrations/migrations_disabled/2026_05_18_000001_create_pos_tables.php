<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasColumn('users', 'nama')) {
            Schema::table('users', function (Blueprint $table) {
                $table->string('nama')->nullable()->after('name');
                $table->string('peran')->default('kasir')->after('password');
                $table->boolean('aktif')->default(true)->after('peran');
            });
        }

        Schema::create('kategori_produk', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->text('keterangan')->nullable();
            $table->timestamps();
        });

        Schema::create('satuan', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->string('singkatan', 20)->nullable();
            $table->timestamps();
        });

        Schema::create('supplier', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->string('nama_kontak')->nullable();
            $table->string('telepon')->nullable();
            $table->text('alamat')->nullable();
            $table->timestamps();
        });

        Schema::create('pelanggan', function (Blueprint $table) {
            $table->id();
            $table->string('nama');
            $table->string('telepon')->nullable();
            $table->text('alamat')->nullable();
            $table->integer('poin')->default(0);
            $table->timestamps();
        });

        Schema::create('produk', function (Blueprint $table) {
            $table->id();
            $table->string('kode_produk')->unique();
            $table->string('barcode')->nullable()->unique();
            $table->string('nama');
            $table->foreignId('id_kategori_produk')->constrained('kategori_produk')->cascadeOnUpdate()->restrictOnDelete();
            $table->foreignId('id_satuan')->constrained('satuan')->cascadeOnUpdate()->restrictOnDelete();
            $table->decimal('harga_beli', 15, 2)->default(0);
            $table->decimal('harga_jual', 15, 2)->default(0);
            $table->integer('stok')->default(0);
            $table->integer('stok_minimum')->default(0);
            $table->boolean('aktif')->default(true);
            $table->timestamps();
        });

        Schema::create('transaksi_penjualan', function (Blueprint $table) {
            $table->id();
            $table->string('nomor_transaksi')->unique();
            $table->foreignId('user_id')->constrained('users')->cascadeOnUpdate()->restrictOnDelete();
            $table->foreignId('pelanggan_id')->nullable()->constrained('pelanggan')->nullOnDelete();
            $table->dateTime('tanggal');
            $table->decimal('subtotal', 15, 2)->default(0);
            $table->decimal('diskon', 15, 2)->default(0);
            $table->decimal('total', 15, 2)->default(0);
            $table->decimal('bayar', 15, 2)->default(0);
            $table->decimal('kembalian', 15, 2)->default(0);
            $table->string('status')->default('selesai');
            $table->text('catatan')->nullable();
            $table->timestamps();
        });

        Schema::create('detail_transaksi', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaksi_penjualan_id')->constrained('transaksi_penjualan')->cascadeOnDelete();
            $table->foreignId('produk_id')->constrained('produk')->cascadeOnUpdate()->restrictOnDelete();
            $table->integer('qty');
            $table->decimal('harga', 15, 2)->default(0);
            $table->decimal('subtotal', 15, 2)->default(0);
            $table->timestamps();
        });

        Schema::create('stok_masuk', function (Blueprint $table) {
            $table->id();
            $table->foreignId('produk_id')->constrained('produk')->cascadeOnUpdate()->restrictOnDelete();
            $table->foreignId('user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->integer('qty');
            $table->decimal('harga_beli', 15, 2)->default(0);
            $table->date('tanggal');
            $table->text('keterangan')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('stok_masuk');
        Schema::dropIfExists('detail_transaksi');
        Schema::dropIfExists('transaksi_penjualan');
        Schema::dropIfExists('produk');
        Schema::dropIfExists('pelanggan');
        Schema::dropIfExists('supplier');
        Schema::dropIfExists('satuan');
        Schema::dropIfExists('kategori_produk');
    }
};
