<?php

namespace Database\Seeders;

use App\Models\KategoriProduk;
use App\Models\Produk;
use App\Models\Satuan;
use App\Models\Supplier;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'admin@toko.com'],
            [
                'nama' => 'Administrator',
                'password' => Hash::make('password'),
                'peran' => 'admin',
                'aktif' => true,
            ]
        );

        User::updateOrCreate(
            ['email' => 'kasir@toko.com'],
            [
                'nama' => 'Siti Kasir',
                'password' => Hash::make('password'),
                'peran' => 'kasir',
                'aktif' => true,
            ]
        );

        $satuans = [
            ['nama' => 'Kilogram', 'singkatan' => 'kg'],
            ['nama' => 'Liter', 'singkatan' => 'ltr'],
            ['nama' => 'Bungkus', 'singkatan' => 'bks'],
            ['nama' => 'Botol', 'singkatan' => 'btl'],
            ['nama' => 'Kaleng', 'singkatan' => 'klg'],
            ['nama' => 'Pcs', 'singkatan' => 'pcs'],
            ['nama' => 'Karton', 'singkatan' => 'ktn'],
        ];

        foreach ($satuans as $satuan) {
            Satuan::firstOrCreate(['nama' => $satuan['nama']], $satuan);
        }

        $kategoris = [
            ['nama' => 'Beras & Tepung', 'keterangan' => 'Beras, tepung, sagu'],
            ['nama' => 'Minyak & Lemak', 'keterangan' => 'Minyak goreng, margarin'],
            ['nama' => 'Bumbu & Rempah', 'keterangan' => 'Gula, garam, kecap, saus'],
            ['nama' => 'Mie & Pasta', 'keterangan' => 'Mie instan, bihun, pasta'],
            ['nama' => 'Susu & Minuman', 'keterangan' => 'Susu, kopi, teh'],
            ['nama' => 'Kebersihan', 'keterangan' => 'Sabun, detergen, sampo'],
        ];

        foreach ($kategoris as $kategori) {
            KategoriProduk::firstOrCreate(
                ['slug' => Str::slug($kategori['nama'])],
                [
                    'nama' => $kategori['nama'],
                    'slug' => Str::slug($kategori['nama']),
                    'keterangan' => $kategori['keterangan'] ?? null,
                ]
            );
        }

        Supplier::firstOrCreate(
            ['kode_supplier' => 'SUP0001'],
            [
                'kode_supplier' => 'SUP0001',
                'nama' => 'CV Sumber Makmur',
                'nama_kontak' => 'Budi Santoso',
                'telepon' => '081234567890',
                'alamat' => 'Bandung',
                'aktif' => true,
            ]
        );

        $produk = [
            ['Beras Premium 5kg', 1, 7, 55000, 62000, 50, 10],
            ['Tepung Terigu 1kg', 1, 1, 9500, 11500, 40, 8],
            ['Minyak Goreng 1L', 2, 2, 14500, 17000, 60, 10],
            ['Gula Pasir 1kg', 3, 1, 12000, 14500, 55, 10],
            ['Garam Halus', 3, 3, 1500, 2500, 80, 15],
            ['Kecap Manis 135ml', 3, 4, 7000, 9500, 35, 8],
            ['Indomie Goreng', 4, 3, 2800, 3500, 200, 30],
            ['Susu Kental Manis', 5, 5, 10000, 13000, 30, 8],
            ['Kopi Sachet', 5, 3, 1500, 2000, 100, 20],
            ['Sabun Mandi', 6, 6, 3500, 5000, 45, 10],
        ];

        foreach ($produk as $index => $p) {
            Produk::updateOrCreate(
                ['kode_produk' => 'PRD'.str_pad((string) ($index + 1), 4, '0', STR_PAD_LEFT)],
                [
                    'nama' => $p[0],
                    'id_kategori_produk' => $p[1],
                    'id_satuan' => $p[2],
                    'harga_beli' => $p[3],
                    'harga_jual' => $p[4],
                    'stok' => $p[5],
                    'stok_minimum' => $p[6],
                    'aktif' => true,
                ]
            );
        }
    }
}
