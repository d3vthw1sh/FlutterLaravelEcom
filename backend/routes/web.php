<?php

use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Response;

Route::get('/uploads/{filename}', function ($filename) {
    $path = public_path('uploads/' . $filename);

    if (!File::exists($path)) {
        abort(404);
    }

    $file = File::get($path);
    $type = File::mimeType($path);

    return Response::make($file, 200)->header("Content-Type", $type);
});

// Mock Payment Gateway Page
Route::get('/mock-payment', function () {
    return view('mock-payment');
});
