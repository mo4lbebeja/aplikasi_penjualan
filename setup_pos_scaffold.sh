#!/usr/bin/env bash
set -e

echo "== SJL POS scaffold generator =="
echo "Pastikan script ini dijalankan dari root project Laravel."

mkdir -p app/Http/Controllers/Admin
mkdir -p app/Http/Controllers/Kasir
mkdir -p app/Http/Middleware
mkdir -p app/Models
mkdir -p database/migrations
mkdir -p database/seeders
mkdir -p resources/js/pages/Admin
mkdir -p resources/js/pages/Admin/Produk
mkdir -p resources/js/pages/Admin/Master
mkdir -p resources/js/pages/Admin/Transaksi
mkdir -p resources/js/pages/Admin/Stok
mkdir -p resources/js/pages/Kasir

cat > routes/web.php <<'PHP'
<?php

use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\KategoriController;
use App\Http\Controllers\Admin\PelangganController;
use App\Http\Controllers\Admin\PenggunaController;
use App\Http\Controllers\Admin\ProdukController;
use App\Http\Controllers\Admin\SatuanController;
use App\Http\Controllers\Admin\StokController;
use App\Http\Controllers\Admin\SupplierController;
use App\Http\Controllers\Admin\TransaksiController;
use App\Http\Controllers\Kasir\KasirController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', fn () => redirect()->route('login'));

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/dashboard', function () {
        $user = auth()->user();

        if (($user->peran ?? null) === 'kasir') {
            return redirect()->route('kasir.pos');
        }

        return redirect()->route('admin.dashboard');
    })->name('dashboard');

    Route::middleware(['peran:admin,kasir'])
        ->prefix('kasir')
        ->name('kasir.')
        ->group(function () {
            Route::get('/', [KasirController::class, 'index'])->name('pos');
            Route::get('/produk', [KasirController::class, 'produk'])->name('produk');
            Route::get('/pelanggan', [KasirController::class, 'pelanggan'])->name('pelanggan');
            Route::post('/bayar', [KasirController::class, 'bayar'])->name('bayar');
            Route::get('/struk/{transaksi}', [KasirController::class, 'struk'])->name('struk');
        });

    Route::middleware(['peran:admin'])
        ->prefix('admin')
        ->name('admin.')
        ->group(function () {
            Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
            Route::get('/laporan', [DashboardController::class, 'laporan'])->name('laporan');

            Route::resource('produk', ProdukController::class);
            Route::resource('kategori', KategoriController::class)->except(['show']);
            Route::resource('satuan', SatuanController::class)->except(['show']);
            Route::resource('supplier', SupplierController::class)->except(['show']);
            Route::resource('pelanggan', PelangganController::class);
            Route::resource('pengguna', PenggunaController::class)->except(['show']);

            Route::get('/transaksi', [TransaksiController::class, 'index'])->name('transaksi.index');
            Route::get('/transaksi/{transaksi}', [TransaksiController::class, 'show'])->name('transaksi.show');
            Route::patch('/transaksi/{transaksi}/batal', [TransaksiController::class, 'batal'])->name('transaksi.batal');

            Route::get('/stok', [StokController::class, 'index'])->name('stok.index');
            Route::post('/stok', [StokController::class, 'store'])->name('stok.store');
        });
});

if (file_exists(__DIR__.'/settings.php')) {
    require __DIR__.'/settings.php';
}

if (file_exists(__DIR__.'/auth.php')) {
    require __DIR__.'/auth.php';
}
PHP

cat > app/Http/Middleware/CekPeran.php <<'PHP'
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CekPeran
{
    public function handle(Request $request, Closure $next, ...$peran)
    {
        $user = $request->user();

        if (! $user) {
            return redirect()->route('login');
        }

        if (isset($user->aktif) && ! $user->aktif) {
            auth()->logout();
            return redirect()->route('login')->withErrors(['email' => 'Akun tidak aktif.']);
        }

        if (! in_array($user->peran, $peran, true)) {
            abort(403, 'Anda tidak memiliki akses ke halaman ini.');
        }

        return $next($request);
    }
}
PHP

cat > bootstrap/app.php <<'PHP'
<?php

use App\Http\Middleware\HandleAppearance;
use App\Http\Middleware\HandleInertiaRequests;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: [
            __DIR__.'/../routes/web.php',
        ],
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->web(append: [
            HandleAppearance::class,
            HandleInertiaRequests::class,
        ]);

        $middleware->alias([
            'peran' => \App\Http\Middleware\CekPeran::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();
PHP

cat > app/Models/User.php <<'PHP'
<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use Notifiable;

    protected $fillable = [
        'name',
        'nama',
        'email',
        'password',
        'peran',
        'aktif',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'aktif' => 'boolean',
        ];
    }

    public function getNameAttribute($value)
    {
        return $value ?: ($this->attributes['nama'] ?? null);
    }
}
PHP

cat > app/Models/KategoriProduk.php <<'PHP'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KategoriProduk extends Model
{
    protected $table = 'kategori_produk';

    protected $fillable = ['nama', 'keterangan'];

    public function produk()
    {
        return $this->hasMany(Produk::class, 'id_kategori_produk');
    }
}
PHP

cat > app/Models/Satuan.php <<'PHP'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Satuan extends Model
{
    protected $table = 'satuan';

    protected $fillable = ['nama', 'singkatan'];

    public function produk()
    {
        return $this->hasMany(Produk::class, 'id_satuan');
    }
}
PHP

cat > app/Models/Supplier.php <<'PHP'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Supplier extends Model
{
    protected $table = 'supplier';

    protected $fillable = ['nama', 'nama_kontak', 'telepon', 'alamat'];
}
PHP

cat > app/Models/Pelanggan.php <<'PHP'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pelanggan extends Model
{
    protected $table = 'pelanggan';

    protected $fillable = ['nama', 'telepon', 'alamat', 'poin'];
}
PHP

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
PHP

cat > app/Models/TransaksiPenjualan.php <<'PHP'
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
        'tanggal',
        'subtotal',
        'diskon',
        'total',
        'bayar',
        'kembalian',
        'status',
        'catatan',
    ];

    protected $casts = [
        'tanggal' => 'datetime',
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
PHP

cat > app/Models/DetailTransaksi.php <<'PHP'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DetailTransaksi extends Model
{
    protected $table = 'detail_transaksi';

    protected $fillable = [
        'transaksi_penjualan_id',
        'produk_id',
        'qty',
        'harga',
        'subtotal',
    ];

    protected $casts = [
        'harga' => 'decimal:2',
        'subtotal' => 'decimal:2',
    ];

    public function transaksi()
    {
        return $this->belongsTo(TransaksiPenjualan::class, 'transaksi_penjualan_id');
    }

    public function produk()
    {
        return $this->belongsTo(Produk::class, 'produk_id');
    }
}
PHP

cat > app/Models/StokMasuk.php <<'PHP'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StokMasuk extends Model
{
    protected $table = 'stok_masuk';

    protected $fillable = [
        'produk_id',
        'user_id',
        'qty',
        'harga_beli',
        'tanggal',
        'keterangan',
    ];

    protected $casts = [
        'tanggal' => 'date',
        'harga_beli' => 'decimal:2',
    ];

    public function produk()
    {
        return $this->belongsTo(Produk::class, 'produk_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
PHP

cat > database/migrations/2026_05_18_000001_create_pos_tables.php <<'PHP'
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
PHP

cat > database/seeders/DatabaseSeeder.php <<'PHP'
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
        User::updateOrCreate(
            ['email' => 'admin@toko.com'],
            ['name' => 'Administrator', 'nama' => 'Administrator', 'password' => Hash::make('password'), 'peran' => 'admin', 'aktif' => true]
        );

        User::updateOrCreate(
            ['email' => 'kasir@toko.com'],
            ['name' => 'Siti Kasir', 'nama' => 'Siti Kasir', 'password' => Hash::make('password'), 'peran' => 'kasir', 'aktif' => true]
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
            KategoriProduk::firstOrCreate(['nama' => $kategori['nama']], $kategori);
        }

        Supplier::firstOrCreate(
            ['nama' => 'CV Sumber Makmur'],
            ['nama_kontak' => 'Budi Santoso', 'telepon' => '081234567890', 'alamat' => 'Bandung']
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
PHP

cat > app/Http/Controllers/Admin/DashboardController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use App\Models\TransaksiPenjualan;
use Illuminate\Http\Request;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Dashboard', [
            'stats' => [
                'produk' => Produk::count(),
                'stok_menipis' => Produk::whereColumn('stok', '<=', 'stok_minimum')->count(),
                'transaksi_hari_ini' => TransaksiPenjualan::whereDate('tanggal', today())->count(),
                'penjualan_hari_ini' => TransaksiPenjualan::whereDate('tanggal', today())->where('status', 'selesai')->sum('total'),
            ],
            'stokMenipis' => Produk::with(['kategori', 'satuan'])
                ->whereColumn('stok', '<=', 'stok_minimum')
                ->orderBy('stok')
                ->limit(10)
                ->get(),
            'transaksiTerbaru' => TransaksiPenjualan::with(['kasir', 'pelanggan'])
                ->latest()
                ->limit(10)
                ->get(),
        ]);
    }

    public function laporan(Request $request)
    {
        $mulai = $request->get('mulai', now()->startOfMonth()->toDateString());
        $selesai = $request->get('selesai', now()->toDateString());

        return Inertia::render('Admin/Laporan', [
            'filter' => compact('mulai', 'selesai'),
            'transaksi' => TransaksiPenjualan::with(['kasir', 'pelanggan'])
                ->whereBetween('tanggal', [$mulai.' 00:00:00', $selesai.' 23:59:59'])
                ->latest('tanggal')
                ->get(),
        ]);
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
use Inertia\Inertia;

class ProdukController extends Controller
{
    public function index(Request $request)
    {
        return Inertia::render('Admin/Produk/Index', [
            'filters' => ['q' => $request->q],
            'produk' => Produk::with(['kategori', 'satuan'])
                ->when($request->q, fn ($q) => $q->where('nama', 'like', '%'.$request->q.'%')->orWhere('kode_produk', 'like', '%'.$request->q.'%'))
                ->latest()
                ->paginate(15)
                ->withQueryString(),
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Produk/Form', [
            'produk' => null,
            'kategori' => KategoriProduk::orderBy('nama')->get(),
            'satuan' => Satuan::orderBy('nama')->get(),
        ]);
    }

    public function store(Request $request)
    {
        Produk::create($this->validated($request) + [
            'kode_produk' => $request->kode_produk ?: 'PRD'.now()->format('YmdHis'),
        ]);

        return redirect()->route('admin.produk.index')->with('success', 'Produk berhasil dibuat.');
    }

    public function show(Produk $produk)
    {
        return redirect()->route('admin.produk.edit', $produk);
    }

    public function edit(Produk $produk)
    {
        return Inertia::render('Admin/Produk/Form', [
            'produk' => $produk,
            'kategori' => KategoriProduk::orderBy('nama')->get(),
            'satuan' => Satuan::orderBy('nama')->get(),
        ]);
    }

    public function update(Request $request, Produk $produk)
    {
        $produk->update($this->validated($request, $produk->id));

        return redirect()->route('admin.produk.index')->with('success', 'Produk berhasil diperbarui.');
    }

    public function destroy(Produk $produk)
    {
        $produk->delete();

        return back()->with('success', 'Produk berhasil dihapus.');
    }

    private function validated(Request $request, ?int $id = null): array
    {
        return $request->validate([
            'kode_produk' => ['nullable', 'string', 'max:100', 'unique:produk,kode_produk,'.$id],
            'barcode' => ['nullable', 'string', 'max:100', 'unique:produk,barcode,'.$id],
            'nama' => ['required', 'string', 'max:255'],
            'id_kategori_produk' => ['required', 'exists:kategori_produk,id'],
            'id_satuan' => ['required', 'exists:satuan,id'],
            'harga_beli' => ['required', 'numeric', 'min:0'],
            'harga_jual' => ['required', 'numeric', 'min:0'],
            'stok' => ['required', 'integer', 'min:0'],
            'stok_minimum' => ['required', 'integer', 'min:0'],
            'aktif' => ['boolean'],
        ]);
    }
}
PHP

cat > app/Http/Controllers/Admin/KategoriController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\KategoriProduk;
use Illuminate\Http\Request;
use Inertia\Inertia;

class KategoriController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Master/Kategori', ['items' => KategoriProduk::latest()->get()]);
    }

    public function store(Request $request)
    {
        KategoriProduk::create($request->validate(['nama' => 'required|string|max:255', 'keterangan' => 'nullable|string']));
        return back()->with('success', 'Kategori berhasil dibuat.');
    }

    public function update(Request $request, KategoriProduk $kategori)
    {
        $kategori->update($request->validate(['nama' => 'required|string|max:255', 'keterangan' => 'nullable|string']));
        return back()->with('success', 'Kategori berhasil diperbarui.');
    }

    public function destroy(KategoriProduk $kategori)
    {
        $kategori->delete();
        return back()->with('success', 'Kategori berhasil dihapus.');
    }
}
PHP

cat > app/Http/Controllers/Admin/SatuanController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Satuan;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SatuanController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Master/Satuan', ['items' => Satuan::latest()->get()]);
    }

    public function store(Request $request)
    {
        Satuan::create($request->validate(['nama' => 'required|string|max:255', 'singkatan' => 'nullable|string|max:20']));
        return back()->with('success', 'Satuan berhasil dibuat.');
    }

    public function update(Request $request, Satuan $satuan)
    {
        $satuan->update($request->validate(['nama' => 'required|string|max:255', 'singkatan' => 'nullable|string|max:20']));
        return back()->with('success', 'Satuan berhasil diperbarui.');
    }

    public function destroy(Satuan $satuan)
    {
        $satuan->delete();
        return back()->with('success', 'Satuan berhasil dihapus.');
    }
}
PHP

cat > app/Http/Controllers/Admin/SupplierController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Supplier;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SupplierController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Master/Supplier', ['items' => Supplier::latest()->get()]);
    }

    public function store(Request $request)
    {
        Supplier::create($request->validate(['nama' => 'required|string|max:255', 'nama_kontak' => 'nullable|string|max:255', 'telepon' => 'nullable|string|max:50', 'alamat' => 'nullable|string']));
        return back()->with('success', 'Supplier berhasil dibuat.');
    }

    public function update(Request $request, Supplier $supplier)
    {
        $supplier->update($request->validate(['nama' => 'required|string|max:255', 'nama_kontak' => 'nullable|string|max:255', 'telepon' => 'nullable|string|max:50', 'alamat' => 'nullable|string']));
        return back()->with('success', 'Supplier berhasil diperbarui.');
    }

    public function destroy(Supplier $supplier)
    {
        $supplier->delete();
        return back()->with('success', 'Supplier berhasil dihapus.');
    }
}
PHP

cat > app/Http/Controllers/Admin/PelangganController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PelangganController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Master/Pelanggan', ['items' => Pelanggan::latest()->get()]);
    }

    public function create() { return redirect()->route('admin.pelanggan.index'); }
    public function show(Pelanggan $pelanggan) { return redirect()->route('admin.pelanggan.index'); }
    public function edit(Pelanggan $pelanggan) { return redirect()->route('admin.pelanggan.index'); }

    public function store(Request $request)
    {
        Pelanggan::create($request->validate(['nama' => 'required|string|max:255', 'telepon' => 'nullable|string|max:50', 'alamat' => 'nullable|string']));
        return back()->with('success', 'Pelanggan berhasil dibuat.');
    }

    public function update(Request $request, Pelanggan $pelanggan)
    {
        $pelanggan->update($request->validate(['nama' => 'required|string|max:255', 'telepon' => 'nullable|string|max:50', 'alamat' => 'nullable|string']));
        return back()->with('success', 'Pelanggan berhasil diperbarui.');
    }

    public function destroy(Pelanggan $pelanggan)
    {
        $pelanggan->delete();
        return back()->with('success', 'Pelanggan berhasil dihapus.');
    }
}
PHP

cat > app/Http/Controllers/Admin/PenggunaController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Inertia\Inertia;

class PenggunaController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Master/Pengguna', ['items' => User::latest()->get()]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'nama' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'peran' => 'required|in:admin,kasir',
            'password' => 'required|string|min:6',
            'aktif' => 'boolean',
        ]);
        $data['name'] = $data['nama'];
        $data['password'] = Hash::make($data['password']);
        User::create($data);
        return back()->with('success', 'Pengguna berhasil dibuat.');
    }

    public function update(Request $request, User $pengguna)
    {
        $data = $request->validate([
            'nama' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,'.$pengguna->id,
            'peran' => 'required|in:admin,kasir',
            'password' => 'nullable|string|min:6',
            'aktif' => 'boolean',
        ]);
        $data['name'] = $data['nama'];
        if (! empty($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        } else {
            unset($data['password']);
        }
        $pengguna->update($data);
        return back()->with('success', 'Pengguna berhasil diperbarui.');
    }

    public function destroy(User $pengguna)
    {
        abort_if($pengguna->id === auth()->id(), 422, 'Tidak bisa menghapus akun sendiri.');
        $pengguna->delete();
        return back()->with('success', 'Pengguna berhasil dihapus.');
    }
}
PHP

cat > app/Http/Controllers/Admin/TransaksiController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\TransaksiPenjualan;
use Inertia\Inertia;

class TransaksiController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Transaksi/Index', [
            'items' => TransaksiPenjualan::with(['kasir', 'pelanggan'])->latest('tanggal')->paginate(20),
        ]);
    }

    public function show(TransaksiPenjualan $transaksi)
    {
        return Inertia::render('Admin/Transaksi/Show', [
            'transaksi' => $transaksi->load(['kasir', 'pelanggan', 'detail.produk']),
        ]);
    }

    public function batal(TransaksiPenjualan $transaksi)
    {
        if ($transaksi->status === 'batal') {
            return back();
        }

        foreach ($transaksi->detail as $detail) {
            $detail->produk?->increment('stok', $detail->qty);
        }

        $transaksi->update(['status' => 'batal']);

        return back()->with('success', 'Transaksi dibatalkan dan stok dikembalikan.');
    }
}
PHP

cat > app/Http/Controllers/Admin/StokController.php <<'PHP'
<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use App\Models\StokMasuk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class StokController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Stok/Index', [
            'produk' => Produk::orderBy('nama')->get(),
            'items' => StokMasuk::with(['produk', 'user'])->latest()->paginate(20),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'produk_id' => 'required|exists:produk,id',
            'qty' => 'required|integer|min:1',
            'harga_beli' => 'nullable|numeric|min:0',
            'tanggal' => 'required|date',
            'keterangan' => 'nullable|string',
        ]);

        DB::transaction(function () use ($data) {
            StokMasuk::create($data + ['user_id' => auth()->id()]);
            Produk::whereKey($data['produk_id'])->increment('stok', $data['qty']);
            if (($data['harga_beli'] ?? 0) > 0) {
                Produk::whereKey($data['produk_id'])->update(['harga_beli' => $data['harga_beli']]);
            }
        });

        return back()->with('success', 'Stok masuk berhasil dicatat.');
    }
}
PHP

cat > app/Http/Controllers/Kasir/KasirController.php <<'PHP'
<?php

namespace App\Http\Controllers\Kasir;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use App\Models\Produk;
use App\Models\TransaksiPenjualan;
use App\Models\DetailTransaksi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class KasirController extends Controller
{
    public function index()
    {
        return Inertia::render('Kasir/Index', [
            'produkAwal' => Produk::with(['kategori', 'satuan'])->where('aktif', true)->where('stok', '>', 0)->orderBy('nama')->limit(20)->get(),
            'pelangganAwal' => Pelanggan::orderBy('nama')->limit(20)->get(),
        ]);
    }

    public function produk(Request $request)
    {
        return Produk::with(['kategori', 'satuan'])
            ->where('aktif', true)
            ->where('stok', '>', 0)
            ->when($request->q, fn ($q) => $q->where(function ($qq) use ($request) {
                $qq->where('nama', 'like', '%'.$request->q.'%')
                    ->orWhere('kode_produk', 'like', '%'.$request->q.'%')
                    ->orWhere('barcode', 'like', '%'.$request->q.'%');
            }))
            ->orderBy('nama')
            ->limit(30)
            ->get();
    }

    public function pelanggan(Request $request)
    {
        return Pelanggan::when($request->q, fn ($q) => $q->where('nama', 'like', '%'.$request->q.'%')->orWhere('telepon', 'like', '%'.$request->q.'%'))
            ->orderBy('nama')
            ->limit(30)
            ->get();
    }

    public function bayar(Request $request)
    {
        $data = $request->validate([
            'pelanggan_id' => 'nullable|exists:pelanggan,id',
            'items' => 'required|array|min:1',
            'items.*.produk_id' => 'required|exists:produk,id',
            'items.*.qty' => 'required|integer|min:1',
            'diskon' => 'nullable|numeric|min:0',
            'bayar' => 'required|numeric|min:0',
        ]);

        $transaksi = DB::transaction(function () use ($data) {
            $subtotal = 0;
            $itemsFinal = [];

            foreach ($data['items'] as $item) {
                $produk = Produk::lockForUpdate()->findOrFail($item['produk_id']);
                if ($produk->stok < $item['qty']) {
                    abort(422, 'Stok '.$produk->nama.' tidak cukup.');
                }
                $lineSubtotal = $produk->harga_jual * $item['qty'];
                $subtotal += $lineSubtotal;
                $itemsFinal[] = [$produk, $item['qty'], $produk->harga_jual, $lineSubtotal];
            }

            $diskon = (float) ($data['diskon'] ?? 0);
            $total = max(0, $subtotal - $diskon);
            $bayar = (float) $data['bayar'];

            if ($bayar < $total) {
                abort(422, 'Nominal bayar kurang.');
            }

            $transaksi = TransaksiPenjualan::create([
                'nomor_transaksi' => 'TRX'.now()->format('YmdHis'),
                'user_id' => auth()->id(),
                'pelanggan_id' => $data['pelanggan_id'] ?? null,
                'tanggal' => now(),
                'subtotal' => $subtotal,
                'diskon' => $diskon,
                'total' => $total,
                'bayar' => $bayar,
                'kembalian' => $bayar - $total,
                'status' => 'selesai',
            ]);

            foreach ($itemsFinal as [$produk, $qty, $harga, $lineSubtotal]) {
                DetailTransaksi::create([
                    'transaksi_penjualan_id' => $transaksi->id,
                    'produk_id' => $produk->id,
                    'qty' => $qty,
                    'harga' => $harga,
                    'subtotal' => $lineSubtotal,
                ]);

                $produk->decrement('stok', $qty);
            }

            return $transaksi;
        });

        return redirect()->route('kasir.struk', $transaksi)->with('success', 'Transaksi berhasil.');
    }

    public function struk(TransaksiPenjualan $transaksi)
    {
        return Inertia::render('Kasir/Struk', [
            'transaksi' => $transaksi->load(['kasir', 'pelanggan', 'detail.produk']),
        ]);
    }
}
PHP

cat > resources/js/pages/Admin/Dashboard.vue <<'VUE'
<script setup lang="ts">
defineProps<{ stats: any; stokMenipis: any[]; transaksiTerbaru: any[] }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>

<template>
  <div class="space-y-6 p-6">
    <h1 class="text-2xl font-bold">Dashboard Admin</h1>
    <div class="grid gap-4 md:grid-cols-4">
      <div class="rounded-xl border p-4"><div class="text-sm text-gray-500">Produk</div><div class="text-2xl font-bold">{{ stats.produk }}</div></div>
      <div class="rounded-xl border p-4"><div class="text-sm text-gray-500">Stok Menipis</div><div class="text-2xl font-bold">{{ stats.stok_menipis }}</div></div>
      <div class="rounded-xl border p-4"><div class="text-sm text-gray-500">Transaksi Hari Ini</div><div class="text-2xl font-bold">{{ stats.transaksi_hari_ini }}</div></div>
      <div class="rounded-xl border p-4"><div class="text-sm text-gray-500">Penjualan Hari Ini</div><div class="text-2xl font-bold">{{ rupiah(stats.penjualan_hari_ini) }}</div></div>
    </div>
    <div class="rounded-xl border p-4">
      <h2 class="mb-3 font-semibold">Transaksi Terbaru</h2>
      <table class="w-full text-sm"><tbody><tr v-for="t in transaksiTerbaru" :key="t.id" class="border-t"><td class="py-2">{{ t.nomor_transaksi }}</td><td>{{ t.kasir?.nama || t.kasir?.name }}</td><td class="text-right">{{ rupiah(t.total) }}</td></tr></tbody></table>
    </div>
  </div>
</template>
VUE

cat > resources/js/pages/Admin/Laporan.vue <<'VUE'
<script setup lang="ts">
defineProps<{ filter: any; transaksi: any[] }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>
<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">Laporan Penjualan</h1>
    <table class="w-full rounded-xl border text-sm">
      <thead><tr class="bg-gray-50"><th class="p-2 text-left">No</th><th>Kasir</th><th>Pelanggan</th><th class="text-right">Total</th><th>Status</th></tr></thead>
      <tbody><tr v-for="t in transaksi" :key="t.id" class="border-t"><td class="p-2">{{ t.nomor_transaksi }}</td><td>{{ t.kasir?.nama }}</td><td>{{ t.pelanggan?.nama || '-' }}</td><td class="text-right">{{ rupiah(t.total) }}</td><td>{{ t.status }}</td></tr></tbody>
    </table>
  </div>
</template>
VUE

cat > resources/js/pages/Admin/Produk/Index.vue <<'VUE'
<script setup lang="ts">
import { Link, router } from '@inertiajs/vue3'
defineProps<{ produk: any; filters: any }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
const hapus = (id: number) => { if (confirm('Hapus produk ini?')) router.delete(`/admin/produk/${id}`) }
</script>
<template>
  <div class="space-y-4 p-6">
    <div class="flex items-center justify-between"><h1 class="text-2xl font-bold">Produk</h1><Link href="/admin/produk/create" class="rounded bg-black px-4 py-2 text-white">Tambah</Link></div>
    <table class="w-full rounded-xl border text-sm">
      <thead><tr class="bg-gray-50"><th class="p-2 text-left">Kode</th><th>Nama</th><th>Kategori</th><th>Stok</th><th>Harga</th><th></th></tr></thead>
      <tbody><tr v-for="p in produk.data" :key="p.id" class="border-t"><td class="p-2">{{ p.kode_produk }}</td><td>{{ p.nama }}</td><td>{{ p.kategori?.nama }}</td><td>{{ p.stok }} {{ p.satuan?.singkatan }}</td><td>{{ rupiah(p.harga_jual) }}</td><td class="space-x-2 text-right"><Link :href="`/admin/produk/${p.id}/edit`">Edit</Link><button @click="hapus(p.id)">Hapus</button></td></tr></tbody>
    </table>
  </div>
</template>
VUE

cat > resources/js/pages/Admin/Produk/Form.vue <<'VUE'
<script setup lang="ts">
import { useForm } from '@inertiajs/vue3'
const props = defineProps<{ produk: any | null; kategori: any[]; satuan: any[] }>()
const form = useForm({ kode_produk: props.produk?.kode_produk || '', barcode: props.produk?.barcode || '', nama: props.produk?.nama || '', id_kategori_produk: props.produk?.id_kategori_produk || '', id_satuan: props.produk?.id_satuan || '', harga_beli: props.produk?.harga_beli || 0, harga_jual: props.produk?.harga_jual || 0, stok: props.produk?.stok || 0, stok_minimum: props.produk?.stok_minimum || 0, aktif: props.produk?.aktif ?? true })
const submit = () => props.produk ? form.put(`/admin/produk/${props.produk.id}`) : form.post('/admin/produk')
</script>
<template>
  <div class="mx-auto max-w-3xl space-y-4 p-6">
    <h1 class="text-2xl font-bold">{{ produk ? 'Edit' : 'Tambah' }} Produk</h1>
    <form @submit.prevent="submit" class="grid gap-4 rounded-xl border p-4 md:grid-cols-2">
      <input v-model="form.kode_produk" placeholder="Kode produk otomatis jika kosong" class="rounded border p-2" />
      <input v-model="form.barcode" placeholder="Barcode" class="rounded border p-2" />
      <input v-model="form.nama" placeholder="Nama produk" class="rounded border p-2 md:col-span-2" />
      <select v-model="form.id_kategori_produk" class="rounded border p-2"><option value="">Pilih kategori</option><option v-for="k in kategori" :key="k.id" :value="k.id">{{ k.nama }}</option></select>
      <select v-model="form.id_satuan" class="rounded border p-2"><option value="">Pilih satuan</option><option v-for="s in satuan" :key="s.id" :value="s.id">{{ s.nama }}</option></select>
      <input v-model="form.harga_beli" type="number" placeholder="Harga beli" class="rounded border p-2" />
      <input v-model="form.harga_jual" type="number" placeholder="Harga jual" class="rounded border p-2" />
      <input v-model="form.stok" type="number" placeholder="Stok" class="rounded border p-2" />
      <input v-model="form.stok_minimum" type="number" placeholder="Stok minimum" class="rounded border p-2" />
      <button class="rounded bg-black p-2 text-white md:col-span-2">Simpan</button>
    </form>
  </div>
</template>
VUE

cat > resources/js/pages/Kasir/Index.vue <<'VUE'
<script setup lang="ts">
import { computed, ref } from 'vue'
import { router, useForm } from '@inertiajs/vue3'
const props = defineProps<{ produkAwal: any[]; pelangganAwal: any[] }>()
const produk = ref(props.produkAwal)
const cart = ref<any[]>([])
const pelangganId = ref('')
const diskon = ref(0)
const bayar = ref(0)
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
const total = computed(() => cart.value.reduce((s, i) => s + i.qty * Number(i.harga_jual), 0))
const grandTotal = computed(() => Math.max(0, total.value - Number(diskon.value || 0)))
function tambah(p: any) { const item = cart.value.find(i => i.id === p.id); if (item) item.qty++; else cart.value.push({ ...p, qty: 1 }) }
function bayarTransaksi() { router.post('/kasir/bayar', { pelanggan_id: pelangganId.value || null, diskon: diskon.value || 0, bayar: bayar.value, items: cart.value.map(i => ({ produk_id: i.id, qty: i.qty })) }) }
</script>
<template>
  <div class="grid gap-6 p-6 lg:grid-cols-2">
    <div class="space-y-4">
      <h1 class="text-2xl font-bold">Kasir / POS</h1>
      <div class="grid gap-3 md:grid-cols-2">
        <button v-for="p in produk" :key="p.id" @click="tambah(p)" class="rounded-xl border p-3 text-left hover:bg-gray-50">
          <div class="font-semibold">{{ p.nama }}</div><div class="text-sm text-gray-500">Stok {{ p.stok }} • {{ rupiah(p.harga_jual) }}</div>
        </button>
      </div>
    </div>
    <div class="space-y-4 rounded-xl border p-4">
      <h2 class="text-xl font-bold">Keranjang</h2>
      <div v-for="i in cart" :key="i.id" class="flex items-center justify-between border-b py-2">
        <div><div class="font-medium">{{ i.nama }}</div><div class="text-sm">{{ rupiah(i.harga_jual) }}</div></div>
        <input v-model.number="i.qty" type="number" min="1" class="w-20 rounded border p-1 text-center" />
      </div>
      <select v-model="pelangganId" class="w-full rounded border p-2"><option value="">Umum</option><option v-for="p in pelangganAwal" :key="p.id" :value="p.id">{{ p.nama }}</option></select>
      <input v-model.number="diskon" type="number" placeholder="Diskon" class="w-full rounded border p-2" />
      <input v-model.number="bayar" type="number" placeholder="Bayar" class="w-full rounded border p-2" />
      <div class="text-right text-xl font-bold">Total: {{ rupiah(grandTotal) }}</div>
      <button @click="bayarTransaksi" class="w-full rounded bg-black p-3 text-white">Bayar</button>
    </div>
  </div>
</template>
VUE

cat > resources/js/pages/Kasir/Struk.vue <<'VUE'
<script setup lang="ts">
defineProps<{ transaksi: any }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>
<template>
  <div class="mx-auto max-w-md p-6">
    <div class="rounded-xl border p-4">
      <h1 class="text-center text-xl font-bold">STRUK PENJUALAN</h1>
      <p class="text-center text-sm">{{ transaksi.nomor_transaksi }}</p>
      <div class="my-4 border-t"></div>
      <div v-for="d in transaksi.detail" :key="d.id" class="flex justify-between py-1 text-sm">
        <span>{{ d.produk?.nama }} x {{ d.qty }}</span><span>{{ rupiah(d.subtotal) }}</span>
      </div>
      <div class="my-4 border-t"></div>
      <div class="flex justify-between"><span>Subtotal</span><b>{{ rupiah(transaksi.subtotal) }}</b></div>
      <div class="flex justify-between"><span>Diskon</span><b>{{ rupiah(transaksi.diskon) }}</b></div>
      <div class="flex justify-between"><span>Total</span><b>{{ rupiah(transaksi.total) }}</b></div>
      <div class="flex justify-between"><span>Bayar</span><b>{{ rupiah(transaksi.bayar) }}</b></div>
      <div class="flex justify-between"><span>Kembali</span><b>{{ rupiah(transaksi.kembalian) }}</b></div>
      <button onclick="window.print()" class="mt-4 w-full rounded bg-black p-2 text-white">Cetak</button>
    </div>
  </div>
</template>
VUE

cat > resources/js/pages/Admin/Transaksi/Index.vue <<'VUE'
<script setup lang="ts">
import { Link } from '@inertiajs/vue3'
defineProps<{ items: any }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>
<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">Transaksi</h1>
    <table class="w-full border text-sm"><tbody><tr v-for="t in items.data" :key="t.id" class="border-t"><td class="p-2"><Link :href="`/admin/transaksi/${t.id}`">{{ t.nomor_transaksi }}</Link></td><td>{{ t.kasir?.nama }}</td><td class="text-right">{{ rupiah(t.total) }}</td><td>{{ t.status }}</td></tr></tbody></table>
  </div>
</template>
VUE

cat > resources/js/pages/Admin/Transaksi/Show.vue <<'VUE'
<script setup lang="ts">
defineProps<{ transaksi: any }>()
const rupiah = (n: number) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(Number(n || 0))
</script>
<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">{{ transaksi.nomor_transaksi }}</h1>
    <table class="w-full border text-sm"><tbody><tr v-for="d in transaksi.detail" :key="d.id" class="border-t"><td class="p-2">{{ d.produk?.nama }}</td><td>{{ d.qty }}</td><td>{{ rupiah(d.harga) }}</td><td class="text-right">{{ rupiah(d.subtotal) }}</td></tr></tbody></table>
  </div>
</template>
VUE

cat > resources/js/pages/Admin/Stok/Index.vue <<'VUE'
<script setup lang="ts">
import { useForm } from '@inertiajs/vue3'
defineProps<{ produk: any[]; items: any }>()
const form = useForm({ produk_id: '', qty: 1, harga_beli: 0, tanggal: new Date().toISOString().slice(0,10), keterangan: '' })
</script>
<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">Stok Masuk</h1>
    <form @submit.prevent="form.post('/admin/stok')" class="grid gap-3 rounded-xl border p-4 md:grid-cols-5">
      <select v-model="form.produk_id" class="rounded border p-2"><option value="">Pilih produk</option><option v-for="p in produk" :key="p.id" :value="p.id">{{ p.nama }}</option></select>
      <input v-model="form.qty" type="number" class="rounded border p-2" placeholder="Qty" />
      <input v-model="form.harga_beli" type="number" class="rounded border p-2" placeholder="Harga beli" />
      <input v-model="form.tanggal" type="date" class="rounded border p-2" />
      <button class="rounded bg-black text-white">Simpan</button>
    </form>
  </div>
</template>
VUE

# Reusable simple master pages
for page in Kategori Satuan Supplier Pelanggan Pengguna; do
cat > "resources/js/pages/Admin/Master/${page}.vue" <<'VUE'
<script setup lang="ts">
defineProps<{ items: any[] }>()
</script>
<template>
  <div class="space-y-4 p-6">
    <h1 class="text-2xl font-bold">Data Master</h1>
    <p class="text-sm text-gray-500">Halaman ini sudah dibuat sebagai placeholder. CRUD backend sudah tersedia; form detail bisa dirapikan setelah route utama berhasil jalan.</p>
    <table class="w-full border text-sm">
      <tbody><tr v-for="item in items" :key="item.id" class="border-t"><td class="p-2">{{ item.nama || item.name }}</td><td>{{ item.email || item.telepon || item.singkatan || '-' }}</td></tr></tbody>
    </table>
  </div>
</template>
VUE
done

echo "== Selesai generate scaffold =="
echo "Jalankan:"
echo "composer dump-autoload"
echo "php artisan optimize:clear"
echo "php artisan migrate:fresh --seed"
echo "npm run dev"
echo "php artisan route:list"
