<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthController extends Controller
{
    // -------------------------
    // REGISTER
    // -------------------------
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:4'
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'firstLogin' => true
        ]);

        $token = JWTAuth::fromUser($user);

        return response()->json([
            '_id' => (string)$user->id,
            'name' => $user->name,
            'email' => $user->email,
            'googleImage' => null,
            'googleId' => null,
            'isAdmin' => false,
            'token' => $token,
            'active' => true,
            'firstLogin' => true,
            'created' => $user->created_at
        ]);
    }

    // -------------------------
    // LOGIN (EMAIL + PASSWORD)
    // -------------------------
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        if (!$token = JWTAuth::attempt($credentials)) {
            return response("Invalid Email or Password.", 401); // PLAIN STRING (flutter expects)
        }

        $user = auth()->user();

        return response()->json([
            '_id' => (string)$user->id,
            'name' => $user->name,
            'email' => $user->email,
            'googleImage' => $user->googleImage,
            'googleId' => $user->googleId,
            'isAdmin' => $user->isAdmin,
            'token' => $token,
            'active' => $user->active,
            'firstLogin' => $user->firstLogin,
            'created' => $user->created_at
        ]);
    }

    // -------------------------
    // GOOGLE LOGIN
    // -------------------------
    public function googleLogin(Request $request)
    {
        $request->validate([
            'googleId' => 'required',
            'email' => 'required|email',
            'name' => 'required',
        ]);

        $user = User::where('googleId', $request->googleId)->first();

        if (!$user) {
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'googleId' => $request->googleId,
                'googleImage' => $request->googleImage,
                'password' => null,
                'firstLogin' => false
            ]);
        }

        $token = JWTAuth::fromUser($user);

        return response()->json([
            '_id' => (string)$user->id,
            'name' => $user->name,
            'email' => $user->email,
            'googleImage' => $user->googleImage,
            'googleId' => $user->googleId,
            'isAdmin' => $user->isAdmin,
            'token' => $token,
            'active' => $user->active,
            'firstLogin' => $user->firstLogin,
            'created' => $user->created_at
        ]);
    }

    // -------------------------
    // GET PROFILE (AUTHENTICATED USER)
    // -------------------------
    public function profile()
    {
        $user = auth()->user();

        return response()->json([
            '_id' => (string)$user->id,
            'name' => $user->name,
            'email' => $user->email,
            'googleImage' => $user->googleImage,
            'googleId' => $user->googleId,
            'isAdmin' => $user->isAdmin,
            'active' => $user->active,
            'firstLogin' => $user->firstLogin,
            'created' => $user->created_at
        ]);
    }

    // -------------------------
    // GET ALL USERS (ADMIN ONLY)
    // -------------------------
    public function allUsers()
    {
        $users = User::all();

        return response()->json([
            'users' => $users->map(function ($user) {
                return [
                    '_id' => (string)$user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'googleImage' => $user->googleImage,
                    'googleId' => $user->googleId,
                    'isAdmin' => $user->isAdmin,
                    'active' => $user->active,
                    'firstLogin' => $user->firstLogin,
                    'created' => $user->created_at
                ];
            })->toArray()
        ]);
    }

    // -------------------------
    // DELETE USER (ADMIN ONLY)
    // -------------------------
    public function deleteUser($id)
    {
        try {
            $user = User::find($id);
            if (!$user) {
                return response()->json(['message' => 'User not found'], 404);
            }
            $user->delete();
            return response()->json(['message' => 'User deleted successfully']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    // -------------------------
    // VERIFY EMAIL TOKEN (dummy)
    // -------------------------
    public function verifyEmail()
    {
        // Your Flutter app only checks if token is valid.
        return response()->json(['message' => 'Email verified']);
    }

    // -------------------------
    // PASSWORD RESET REQUEST (dummy)
    // -------------------------
    public function passwordResetRequest()
    {
        return response("Password reset email sent.", 200);
    }

    // -------------------------
    // PASSWORD RESET (dummy)
    // -------------------------
    public function passwordReset()
    {
        return response("Password reset successful.", 200);
    }
}
