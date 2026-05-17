// 2024_01_01_000001_modify_users_table_tambah_peran.php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->renameColumn('name', 'nama');
            $table->enum('peran', ['admin', 'kasir'])->default('kasir')->after('email');
            $table->boolean('aktif')->default(true)->after('peran');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->renameColumn('nama', 'name');
            $table->dropColumn(['peran', 'aktif']);
        });
    }
};