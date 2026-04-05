<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Artist;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use App\Helpers\FileUploadHelper;
use App\Services\ArtistSlugService;
use Illuminate\Support\Facades\Storage;


class ClientArtistsController extends Controller
{
    public function getArtist(Request $request)
    {
        $limit = $request->query('limit', 10);
        $artists = Artist::limit($limit)->get();
        return response()->json(['data' => $artists]);
    }

    public function getAllArtists()  {
        $artists = Artist::all();
        return response()->json($artists);
    }

    public function getArtistByPartnerId(Request $request)
    {
        $request->validate([
            'partner_id' => 'required|integer|exists:partners,id'
        ]);

        $query = Artist::query()->with(['partner']);
        
        if ($request->filled('partner_id')) {
            $query->where('partner_id', $request->partner_id);
        }
        
        $artists = $query->get();
        
        if ($artists->isEmpty()) {
            return response()->json([
                'success' => false,
                'message' => 'No artists were found for this partner.',
                'data' => []
            ], 404);
        }
        
        return response()->json([
            'success' => true,
            'message' => 'Get a list of successful artists',
            'data' => $artists,
            'total' => $artists->count()
        ]);
    }

    public function show(Artist $artist)
    {
        log::info($artist);
        return response()->json($artist);
    }

    public function search(Request $request)
    {
        $artists = Artist::query()
            ->search($request->q)
            ->latest()
            ->paginate(10);
        return response()->json([
            'status' => 'success',
            'data' => $artists
        ]);
    }

    public function statistics()
    {
        $statistics = Artist::getFullStatistics();
        
        return response()->json([
            'success' => true,
            'message' => 'Artist statistics retrieved successfully',
            'data' => $statistics
        ]);
    }

    public function update(Request $request, $id)
    {
        try {
            $artist = Artist::findOrFail($id);

            $request->merge([
                'verified' => filter_var($request->verified, FILTER_VALIDATE_BOOLEAN),
                'is_featured' => filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN),
            ]);

            $data = $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'nullable|string|max:255|unique:artists,slug,' . $artist->id,
                'monthly_listeners' => 'nullable|integer|min:0',
                'bio' => 'nullable|string',
                'avatar' => 'nullable|image|max:5120',
                'banner' => 'nullable|image|max:5120',
                'country' => 'nullable|string|max:100',
                'website' => 'nullable|url|max:255',
                'facebook_url' => 'nullable|url|max:255',
                'instagram_url' => 'nullable|url|max:255',
                'twitter_url' => 'nullable|url|max:255',
                'youtube_url' => 'nullable|url|max:255',
                'verified' => 'nullable|boolean',
                'is_featured' => 'nullable|boolean',
                'partner_id' => 'nullable|exists:partners,id',
                'status' => 'nullable|in:active,inactive',
                'seo_title' => 'nullable|string|max:255',
                'seo_description' => 'nullable|string|max:500',
                'seo_keywords' => 'nullable|string|max:255',
            ]);
            log::info($artist);
            $avatarPath = $artist->avatar_url;
            if ($request->hasFile('avatar') && $request->file('avatar')->isValid()) {
                $avatarPath = FileUploadHelper::upload($request->file('avatar'), 'avatars/artists');
                Log::info('Avatar uploaded during update: ' . $avatarPath);
            }

            $bannerPath = $artist->banner_url;
            if ($request->hasFile('banner') && $request->file('banner')->isValid()) {
                $bannerPath = FileUploadHelper::upload($request->file('banner'), 'banners/artists');
                Log::info('Banner uploaded during update: ' . $bannerPath);
            }

            $artist->update([
                ...$data,
                'slug' => $data['slug'] ?? ArtistSlugService::generate($data['name']),
                'avatar_url' => $avatarPath,
                'banner_url' => $bannerPath,
            ]);

            return response()->json([
                'status' => 'success',
                'data' => [
                    'name' => $artist->name,
                    'avatar_url' => $avatarPath ? Storage::url($avatarPath) : null,
                    'banner_url' => $bannerPath ? Storage::url($bannerPath) : null,
                ]
            ], 200);

        } catch (\Throwable $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function add(Request $request)
    {
        try {
            $request->merge([
                'verified' => filter_var($request->verified, FILTER_VALIDATE_BOOLEAN),
                'is_featured' => filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN),
            ]);
            
            $data = $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'nullable|string|max:255|unique:artists,slug',
                'monthly_listeners' => 'nullable|integer|min:0',
                'bio' => 'nullable|string',
                'avatar' => 'nullable|image|max:5120', 
                'banner' => 'nullable|image|max:5120', 
                'country' => 'nullable|string|max:100',
                'website' => 'nullable|url|max:255',
                'facebook_url' => 'nullable|url|max:255',
                'instagram_url' => 'nullable|url|max:255',
                'twitter_url' => 'nullable|url|max:255',
                'youtube_url' => 'nullable|url|max:255',
                'verified' => 'nullable|boolean',
                'is_featured' => 'nullable|boolean',
                'partner_id' => 'nullable|exists:partners,id',
                'status' => 'nullable|in:active,inactive',
                'seo_title' => 'nullable|string|max:255',
                'seo_description' => 'nullable|string|max:500',
                'seo_keywords' => 'nullable|string|max:255',
            ]);
            
            $avatarPath = null;
            if ($request->hasFile('avatar') && $request->file('avatar')->isValid()) {
                $avatarPath = FileUploadHelper::upload($request->file('avatar'), 'avatars/artists');
                Log::info('Avatar uploaded during add: ' . $avatarPath);
            }

            $bannerPath = null;
            if ($request->hasFile('banner') && $request->file('banner')->isValid()) {
                $bannerPath = FileUploadHelper::upload($request->file('banner'), 'banners/artists');
                Log::info('Banner uploaded during add: ' . $bannerPath);
            }

            $artist = Artist::create([
                ...$data,
                'slug' => $data['slug'] ?? ArtistSlugService::generate($data['name']), 
                'avatar_url' => $avatarPath,
                'banner_url' => $bannerPath,
            ]);

            return response()->json([
                'status' => 'success',
                'data' => [
                    'name' => $artist->name,
                    'avatar_url' => $avatarPath ? Storage::url($avatarPath) : null,
                    'banner_url' => $bannerPath ? Storage::url($bannerPath) : null,
                ]
            ], 201);
            
        } catch (\Throwable $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }
}
