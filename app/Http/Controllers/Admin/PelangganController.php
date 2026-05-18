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
