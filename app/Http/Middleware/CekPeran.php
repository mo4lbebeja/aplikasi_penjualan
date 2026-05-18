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
