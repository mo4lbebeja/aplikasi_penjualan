// 2024_01_01_000006_create_pelanggan_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('pelanggan', function (Blueprint $table) {
            $table->id();
            $table->string('kode_pelanggan', 20)->unique(); // PLG-0001
            $table->string('nama', 150);
            $table->string('telepon', 20)->nullable()->unique();
            $table->text('alamat')->nullable();
            $table->integer('poin')->default(0);                       // program loyalitas
            $table->decimal('total_pembelian', 15, 2)->default(0);    // lifetime value
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pelanggan');
    }
};