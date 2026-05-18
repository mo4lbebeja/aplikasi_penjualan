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
