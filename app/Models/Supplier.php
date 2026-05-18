<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Supplier extends Model
{
    protected $table = 'supplier';

    protected $fillable = [
        'kode_supplier',
        'nama',
        'nama_kontak',
        'telepon',
        'alamat',
        'aktif',
    ];
}