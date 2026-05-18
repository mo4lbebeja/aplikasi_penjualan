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
        return Inertia::render('Admin/Master/Supplier', [
            'items' => Supplier::latest()->get(),
        ]);
    }

    public function create()
    {
        return redirect()->route('admin.supplier.index');
    }

    public function edit(Supplier $supplier)
    {
        return redirect()->route('admin.supplier.index');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'kode_supplier' => ['nullable', 'string', 'max:50', 'unique:supplier,kode_supplier'],
            'nama' => ['required', 'string', 'max:255'],
            'nama_kontak' => ['nullable', 'string', 'max:255'],
            'telepon' => ['nullable', 'string', 'max:50'],
            'alamat' => ['nullable', 'string'],
            'aktif' => ['nullable', 'boolean'],
        ]);

        $data['kode_supplier'] = $data['kode_supplier'] ?: 'SUP'.now()->format('YmdHis');
        $data['aktif'] = $data['aktif'] ?? true;

        Supplier::create($data);

        return back()->with('success', 'Supplier berhasil dibuat.');
    }

    public function update(Request $request, Supplier $supplier)
    {
        $data = $request->validate([
            'kode_supplier' => ['nullable', 'string', 'max:50', 'unique:supplier,kode_supplier,'.$supplier->id],
            'nama' => ['required', 'string', 'max:255'],
            'nama_kontak' => ['nullable', 'string', 'max:255'],
            'telepon' => ['nullable', 'string', 'max:50'],
            'alamat' => ['nullable', 'string'],
            'aktif' => ['nullable', 'boolean'],
        ]);

        $data['kode_supplier'] = $data['kode_supplier'] ?: $supplier->kode_supplier;
        $data['aktif'] = $data['aktif'] ?? true;

        $supplier->update($data);

        return back()->with('success', 'Supplier berhasil diperbarui.');
    }

    public function destroy(Supplier $supplier)
    {
        $supplier->delete();

        return back()->with('success', 'Supplier berhasil dihapus.');
    }
}