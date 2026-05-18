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
