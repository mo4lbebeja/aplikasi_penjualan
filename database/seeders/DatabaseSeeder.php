<?php

namespace Database\Seeders;

use App\Models\KategoriProduk;
use App\Models\Produk;
use App\Models\Satuan;
use App\Models\Supplier;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // ── Pengguna ──────────────────────────────────────────────────────
        User::create([
            'nama'     => 'Administrator',
            'email'    => 'admin@toko.com',
            'password' => Hash::make('password'),
            'peran'    => 'admin',
            'aktif'    => true,
        ]);

        User::create([
            'nama'     => 'Siti Kasir',
            'email'    => 'kasir@toko.com',
            'password' => Hash::make('password'),
            'peran'    => 'kasir',
            'aktif'    => true,
        ]);

        // ── Satuan ────────────────────────────────────────────────────────
        $satuanData = [
            ['nama' => 'Kilogram',   'singkatan' => 'kg'],
            ['nama' => 'Gram',       'singkatan' => 'gr'],
            ['nama' => 'Liter',      'singkatan' => 'ltr'],
            ['nama' => 'Mililiter',  'singkatan' => 'ml'],
            ['nama' => 'Butir',      'singkatan' => 'btr'],
            ['nama' => 'Bungkus',    'singkatan' => 'bks'],
            ['nama' => 'Botol',      'singkatan' => 'btl'],
            ['nama' => 'Kaleng',     'singkatan' => 'klg'],
            ['nama' => 'Lusin',      'singkatan' => 'lsn'],
            ['nama' => 'Pcs',        'singkatan' => 'pcs'],
            ['nama' => 'Karton',     'singkatan' => 'ktn'],
        ];
        foreach ($satuanData as $s) {
            Satuan::create($s);
        }

        // ── Kategori ──────────────────────────────────────────────────────
        $kategoriData = [
            ['nama' => 'Beras & Tepung',    'keterangan' => 'Beras, tepung terigu, tepung beras, sagu'],
            ['nama' => 'Minyak & Lemak',    'keterangan' => 'Minyak goreng, margarin, mentega'],
            ['nama' => 'Bumbu & Rempah',    'keterangan' => 'Gula, garam, kecap, saus, bumbu dapur'],
            ['nama' => 'Mie & Pasta',       'keterangan' => 'Mie instan, bihun, soun, pasta'],
            ['nama' => 'Protein & Lauk',    'keterangan' => 'Telur, ikan kaleng, kornet, sarden'],
            ['nama' => 'Susu & Minuman',    'keterangan' => 'Susu, kopi, teh, minuman serbuk'],
            ['nama' => 'Snack & Camilan',   'keterangan' => 'Kerupuk, biskuit, wafer, permen'],
            ['nama' => 'Kebersihan Rumah',  'keterangan' => 'Sabun cuci, detergen, pewangi, pel'],
            ['nama' => 'Kebersihan Diri',   'keterangan' => 'Sabun mandi, sampo, pasta gigi, sikat gigi'],
            ['nama' => 'Rokok',             'keterangan' => 'Rokok kretek, rokok putih'],
        ];
        foreach ($kategoriData as $k) {
            KategoriProduk::create($k);
        }

        // ── Supplier ──────────────────────────────────────────────────────
        Supplier::create([
            'nama'        => 'CV Sumber Makmur',
            'nama_kontak' => 'Budi Santoso',
            'telepon'     => '081234567890',
            'alamat'      => 'Jl. Pasar Raya No.12, Bandung',
        ]);

        Supplier::create([
            'nama'        => 'PT Indofood Distributor',
            'nama_kontak' => 'Dian Pertiwi',
            'telepon'     => '082345678901',
            'alamat'      => 'Jl. Industri No.45, Jakarta',
        ]);

        // ── Produk Contoh ─────────────────────────────────────────────────
        $produkContoh = [
            // [nama, id_kategori, id_satuan, harga_beli, harga_jual, stok, stok_min]
            ['Beras Premium 5kg',       1, 11, 55000,  62000,  50, 10],
            ['Beras Medium 5kg',        1, 11, 47000,  53000,  80, 15],
            ['Tepung Terigu Cakra 1kg', 1,  1,  9500,  11500,  40,  8],
            ['Minyak Goreng 1L',        2,  3, 14500,  17000,  60, 10],
            ['Minyak Goreng 2L',        2,  3, 28000,  32000,  40, 10],
            ['Gula Pasir 1kg',          3,  1, 12000,  14500,  55, 10],
            ['Garam Halus',             3,  6,  1500,   2500,  80, 15],
            ['Kecap Manis 135ml',       3,  7,  7000,   9500,  35,  8],
            ['Indomie Goreng',          4,  6,  2800,   3500, 200, 30],
            ['Indomie Kuah',            4,  6,  2800,   3500, 150, 30],
            ['Telur Ayam',              5,  5,  2200,   2800, 150, 20],
            ['Sarden ABC 155gr',        5,  8,  9500,  12000,  25,  5],
            ['Susu Kental Manis',       6,  8, 10000,  13000,  30,  8],
            ['Kopi Sachet Good Day',    6,  6,  1500,   2000, 100, 20],
            ['Teh Celup Sosro 25pc',    6,  6,  7500,  10000,  40,  8],
            ['Sabun Cuci Rinso 800gr',  8,  6, 14000,  18000,  30,  6],
            ['Detergen Attack 800gr',   8,  6, 13500,  17000,  25,  6],
            ['Sabun Mandi Lifebuoy',    9,  6,  3500,   5000,  45, 10],
            ['Sampo Pantene 170ml',     9,  7, 18000,  23000,  20,  5],
            ['Pasta Gigi Pepsodent',    9,  6,  9000,  12000,  35,  8],
        ];

        $ids = collect($produkContoh)->map(function ($p) {
            return Produk::create([
                'nama'               => $p[0],
                'id_kategori_produk' => $p[1],
                'id_satuan'          => $p[2],
                'harga_beli'         => $p[3],
                'harga_jual'         => $p[4],
                'stok'               => $p[5],
                'stok_minimum'       => $p[6],
                'aktif'              => true,
            ]);
        });
    }
}
