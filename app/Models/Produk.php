<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Produk extends Model
{
    protected $table = 'produk';

    protected $fillable = [
        'kode_produk',
        'barcode',
        'nama',
        'id_kategori_produk',
        'id_satuan',
        'harga_beli',
        'harga_jual',
        'stok',
        'stok_minimum',
        'aktif',
    ];

    protected $casts = [
        'aktif' => 'boolean',
        'harga_beli' => 'decimal:2',
        'harga_jual' => 'decimal:2',
    ];

    public function kategori()
    {
        return $this->belongsTo(KategoriProduk::class, 'id_kategori_produk');
    }

    public function satuan()
    {
        return $this->belongsTo(Satuan::class, 'id_satuan');
    }
}
