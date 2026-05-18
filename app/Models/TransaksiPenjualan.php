<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TransaksiPenjualan extends Model
{
    protected $table = 'transaksi_penjualan';

    protected $fillable = [
        'nomor_transaksi',
        'user_id',
        'pelanggan_id',
        'subtotal',
        'diskon',
        'total',
        'bayar',
        'kembalian',
        'status',
        'catatan',
    ];

    protected $casts = [
        'subtotal' => 'decimal:2',
        'diskon' => 'decimal:2',
        'total' => 'decimal:2',
        'bayar' => 'decimal:2',
        'kembalian' => 'decimal:2',
    ];

    public function kasir()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class, 'pelanggan_id');
    }

    public function detail()
    {
        return $this->hasMany(DetailTransaksi::class, 'transaksi_penjualan_id');
    }
}