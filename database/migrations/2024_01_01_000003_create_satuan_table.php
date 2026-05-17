// 2024_01_01_000003_create_satuan_table.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('satuan', function (Blueprint $table) {
            $table->id();
            $table->string('nama', 50);       // Kilogram, Liter, Butir ...
            $table->string('singkatan', 10);  // kg, ltr, btr ...
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('satuan');
    }
};