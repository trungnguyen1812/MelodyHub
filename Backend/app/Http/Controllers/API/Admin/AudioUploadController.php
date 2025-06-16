<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;

class AudioUploadController extends Controller
{
   public function upload(Request $request)
{
    if (!$request->hasFile('audio')) {
        return response()->json(['error' => 'No audio file found in request.'], 400);
    }

    $request->validate([
        'audio' => 'required|mimes:mp3,wav,ogg|max:10240', // Giới hạn 10MB
    ]);

    $uploadedFileUrl = Cloudinary::uploadFile(
        $request->file('audio')->getRealPath(),
        [
            'resource_type' => 'video',
            'folder' => 'melodyhub/audio',
        ]
    )->getSecurePath();

    return response()->json([
        'url' => $uploadedFileUrl,
        'message' => 'Upload thành công!',
    ]);
}

}
