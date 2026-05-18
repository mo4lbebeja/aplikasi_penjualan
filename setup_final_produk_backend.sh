#!/usr/bin/env bash
set -e

echo "== Finalisasi backend modul Produk =="

mkdir -p app/Models
mkdir -p app/Http/Controllers/Admin

cat > app/Models/Produk.php <<'PHP'
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
        'harga_beli' => 'decimal:2',
        'harga_jual' => 'decimal:2',
        'stok' => 'integer',
        'stok_minimum' => 'integer',
        'aktif' => 'boolean',
    ];

    public function kategori()
    {
        return $this->belongsTo(KategoriProduk::class, 'id_kategori_produk');
    }

    public function satuan()
    {
        return $this->belongsTo(Satuan::class, 'id_satuan');
    }

    public function detailTransaksi()
    {
        return $this->hasMany(DetailTransaksi::class, 'produk_id');
    }
}
PHP

cat > app/Http/Controllers/Admin/ProdukController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\KategoriProduk;
use App\Models\Produk;
use App\Models\Satuan;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;

class ProdukController extends Controller
{
    public function index(Request $request)
    {
        $query = Produk::query()
            ->with(['kategori', 'satuan'])
            ->when($request->q, function ($q) use ($request) {
                $keyword = $request->q;

                $q->where(function ($sub) use ($keyword) {
                    $sub->where('nama', 'like', "%{$keyword}%")
                        ->orWhere('kode_produk', 'like', "%{$keyword}%")
                        ->orWhere('barcode', 'like', "%{$keyword}%");
                });
            })
            ->when($request->kategori, function ($q) use ($request) {
                $q->where('id_kategori_produk', $request->kategori);
            })
            ->when($request->status !== null && $request->status !== '', function ($q) use ($request) {
                $q->where('aktif', (bool) $request->status);
            })
            ->when($request->stok === 'menipis', function ($q) {
                $q->whereColumn('stok', '<=', 'stok_minimum');
            })
            ->latest();

        return Inertia::render('Admin/Produk/Index', [
            'filters' => [
                'q' => $request->q,
                'kategori' => $request->kategori,
                'status' => $request->status,
                'stok' => $request->stok,
            ],
            'kategori' => KategoriProduk::orderBy('nama')->get(),
            'produk' => $query->paginate(12)->withQueryString(),
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Produk/Form', [
            'mode' => 'create',
            'produk' => null,
            'kategori' => KategoriProduk::orderBy('nama')->get(),
            'satuan' => Satuan::orderBy('nama')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $data = $this->validated($request);

        $data['kode_produk'] = $data['kode_produk'] ?: $this->generateKodeProduk();
        $data['aktif'] = $request->boolean('aktif', true);

        Produk::create($data);

        return redirect()
            ->route('admin.produk.index')
            ->with('success', 'Produk berhasil ditambahkan.');
    }

    public function show(Produk $produk)
    {
        return redirect()->route('admin.produk.edit', $produk);
    }

    public function edit(Produk $produk)
    {
        return Inertia::render('Admin/Produk/Form', [
            'mode' => 'edit',
            'produk' => $produk->load(['kategori', 'satuan']),
            'kategori' => KategoriProduk::orderBy('nama')->get(),
            'satuan' => Satuan::orderBy('nama')->get(),
        ]);
    }

    public function update(Request $request, Produk $produk)
    {
        $data = $this->validated($request, $produk->id);

        $data['kode_produk'] = $data['kode_produk'] ?: $produk->kode_produk;
        $data['aktif'] = $request->boolean('aktif', true);

        $produk->update($data);

        return redirect()
            ->route('admin.produk.index')
            ->with('success', 'Produk berhasil diperbarui.');
    }

    public function destroy(Produk $produk)
    {
        if ($produk->detailTransaksi()->exists()) {
            $produk->update(['aktif' => false]);

            return back()->with('success', 'Produk sudah pernah transaksi, sehingga dinonaktifkan.');
        }

        $produk->delete();

        return back()->with('success', 'Produk berhasil dihapus.');
    }

    private function validated(Request $request, ?int $id = null): array
    {
        return $request->validate([
            'kode_produk' => [
                'nullable',
                'string',
                'max:100',
                Rule::unique('produk', 'kode_produk')->ignore($id),
            ],
            'barcode' => [
                'nullable',
                'string',
                'max:100',
                Rule::unique('produk', 'barcode')->ignore($id),
            ],
            'nama' => ['required', 'string', 'max:255'],
            'id_kategori_produk' => ['required', 'exists:kategori_produk,id'],
            'id_satuan' => ['required', 'exists:satuan,id'],
            'harga_beli' => ['required', 'numeric', 'min:0'],
            'harga_jual' => ['required', 'numeric', 'min:0'],
            'stok' => ['required', 'integer', 'min:0'],
            'stok_minimum' => ['required', 'integer', 'min:0'],
            'aktif' => ['nullable', 'boolean'],
        ], [
            'nama.required' => 'Nama produk wajib diisi.',
            'id_kategori_produk.required' => 'Kategori produk wajib dipilih.',
            'id_satuan.required' => 'Satuan produk wajib dipilih.',
            'harga_beli.required' => 'Harga beli wajib diisi.',
            'harga_jual.required' => 'Harga jual wajib diisi.',
            'stok.required' => 'Stok wajib diisi.',
            'stok_minimum.required' => 'Stok minimum wajib diisi.',
            'kode_produk.unique' => 'Kode produk sudah digunakan.',
            'barcode.unique' => 'Barcode sudah digunakan.',
        ]);
    }

    private function generateKodeProduk(): string
    {
        $last = Produk::query()
            ->where('kode_produk', 'like', 'PRD%')
            ->orderByDesc('id')
            ->first();

        $number = 1;

        if ($last && preg_match('/PRD(\d+)/', $last->kode_produk, $matches)) {
            $number = ((int) $matches[1]) + 1;
        }

        return 'PRD'.str_pad((string) $number, 5, '0', STR_PAD_LEFT);
    }
}
PHP

echo "== Backend Produk selesai =="
