<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Copyright;
use App\Models\Partner;
use App\Models\Song;
use Illuminate\Http\Request;

class ClientCopyrightController extends Controller
{
    /**
     * Lấy Cloudinary instance lazily — tránh crash khi config chưa sẵn sàng
     */
    private function getCloudinary(): \Cloudinary\Cloudinary
    {
        return app(\Cloudinary\Cloudinary::class);
    }

    /**
     * Upload file lên Cloudinary, trả về secure_url
     */
    private function uploadToCloudinary(\Illuminate\Http\UploadedFile $file, string $registrationNumber): string
    {
        $ext      = strtolower($file->getClientOriginalExtension());
        $fileName = $registrationNumber . '_' . time();

        $result = $this->getCloudinary()->uploadApi()->upload(
            $file->getRealPath(),
            [
                'folder'            => 'copyright_documents',
                'public_id'         => $fileName,
                'resource_type'     => 'auto',
                'format'            => $ext,
                'use_filename'      => true,
                'unique_filename'   => false,
                'filename_override' => "{$fileName}.{$ext}",
            ]
        );

        return $result['secure_url'];
    }

    /**
     * Đồng bộ songs.copyright_status dựa trên trạng thái copyright record.
     * - pending/disputed  → 'pending'
     * - active            → 'verified'
     * - revoked/expired   → 'unverified'
     */
    private function syncSongCopyrightStatus(Copyright $copyright): void
    {
        $map = [
            'pending'   => 'pending',
            'disputed'  => 'pending',
            'active'    => 'verified',
            'revoked'   => 'unverified',
            'expired'   => 'unverified',
        ];

        $newStatus = $map[$copyright->status] ?? null;
        if ($newStatus) {
            Song::where('id', $copyright->song_id)
                ->update(['copyright_status' => $newStatus]);
        }
    }    /**
     * Lấy danh sách bản quyền của partner hiện tại (có phân trang)
     */
    public function index(Request $request)
    {
        try {
            $partner = Partner::where('user_id', $request->user()->id)
                ->where('status', 'active')
                ->first();

            if (!$partner) {
                return response()->json([
                    'success' => false,
                    'message' => 'Partner not found or not active'
                ], 403);
            }

            $query = Copyright::with(['song', 'partner'])
                ->where('partner_id', $partner->id);

            // Filter theo status nếu có
            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            // Search theo tên bài hát hoặc owner
            if ($request->filled('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('owner_name', 'like', "%{$search}%")
                      ->orWhereHas('song', fn($sq) => $sq->where('title', 'like', "%{$search}%"));
                });
            }

            $perPage = $request->get('per_page', 15);
            $copyrights = $query->orderBy('created_at', 'desc')->paginate($perPage);

            return response()->json([
                'success' => true,
                'data'    => $copyrights->items(),
                'current_page' => $copyrights->currentPage(),
                'last_page'    => $copyrights->lastPage(),
                'per_page'     => $copyrights->perPage(),
                'total'        => $copyrights->total(),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'An error occurred',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Lấy chi tiết một bản quyền
     */
    public function show(Request $request, $id)
    {
        try {
            $partner = Partner::where('user_id', $request->user()->id)
                ->where('status', 'active')
                ->first();

            if (!$partner) {
                return response()->json([
                    'success' => false,
                    'message' => 'Partner not found or not active'
                ], 403);
            }

            $copyright = Copyright::with(['song', 'partner'])
                ->where('id', $id)
                ->where('partner_id', $partner->id)
                ->first();

            if (!$copyright) {
                return response()->json([
                    'success' => false,
                    'message' => 'Copyright not found'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data'    => $copyright
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'An error occurred',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Cập nhật bản quyền
     */
    public function update(Request $request, $id)
    {
        try {
            $partner = Partner::where('user_id', $request->user()->id)
                ->where('status', 'active')
                ->first();

            if (!$partner) {
                return response()->json([
                    'success' => false,
                    'message' => 'Partner not found or not active'
                ], 403);
            }

            $copyright = Copyright::where('id', $id)
                ->where('partner_id', $partner->id)
                ->first();

            if (!$copyright) {
                return response()->json([
                    'success' => false,
                    'message' => 'Copyright not found'
                ], 404);
            }

            // Không cho phép update nếu đã verified
            if ($copyright->verified_at) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot update a verified copyright record'
                ], 403);
            }

            $validated = $request->validate([
                'copyright_type'      => 'sometimes|in:author,performer,producer,publisher,exclusive,non_exclusive,creative_commons,public_domain',
                'owner_name'          => 'sometimes|string|max:255',
                'registration_number' => 'nullable|string|max:100|unique:copyrights,registration_number,' . $id,
                'registration_date'   => 'nullable|date|before_or_equal:today',
                'registration_country'=> 'nullable|string|max:100',
                'valid_from'          => 'sometimes|date',
                'valid_until'         => 'nullable|date|after:valid_from',
                'territory'           => 'nullable|string|max:255',
                'rights_included'     => 'nullable|string',
                'document_url'        => 'nullable|url|max:500',
                'notes'               => 'nullable|string',
                'status'              => 'sometimes|in:active,expired,pending,disputed,revoked',
                'contract_file'       => 'nullable|file|mimes:pdf,doc,docx,jpg,jpeg,png|max:10240',
            ]);

            // Xử lý upload file mới nếu có
            if ($request->hasFile('contract_file')) {
                $regNum = $validated['registration_number'] ?? $copyright->registration_number ?? 'no_reg';
                $validated['document_url'] = $this->uploadToCloudinary($request->file('contract_file'), $regNum);
            }

            $copyright->update($validated);
            $copyright->load(['partner', 'song']);

            // Đồng bộ copyright_status trên song theo status mới
            $this->syncSongCopyrightStatus($copyright);

            return response()->json([
                'success' => true,
                'message' => 'Copyright updated successfully',
                'data'    => $copyright
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors'  => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while updating copyright',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Xóa bản quyền (chỉ khi chưa verified)
     */
    public function destroy(Request $request, $id)
    {
        try {
            $partner = Partner::where('user_id', $request->user()->id)
                ->where('status', 'active')
                ->first();

            if (!$partner) {
                return response()->json([
                    'success' => false,
                    'message' => 'Partner not found or not active'
                ], 403);
            }

            $copyright = Copyright::where('id', $id)
                ->where('partner_id', $partner->id)
                ->first();

            if (!$copyright) {
                return response()->json([
                    'success' => false,
                    'message' => 'Copyright not found'
                ], 404);
            }

            if ($copyright->verified_at) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete a verified copyright record'
                ], 403);
            }

            $copyright->delete();

            return response()->json([
                'success' => true,
                'message' => 'Copyright deleted successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'An error occurred',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    public function add(Request $request)
    {
        try {
            // Lấy partner từ user đang login
            $partner = Partner::where('user_id', $request->user()->id)
                ->where('status', 'active')
                ->first();

            if (!$partner) {
                return response()->json([
                    'success' => false,
                    'message' => 'Partner not found or not active'
                ], 403);
            }

            // Tìm record cũ bị rejected/revoked của partner cho song này (nếu có) để loại trừ khỏi unique check
            $excludeId = Copyright::where('song_id', $request->song_id)
                ->where('partner_id', $partner->id)
                ->whereIn('status', ['rejected', 'revoked'])
                ->value('id');

            // Validation rules
            $uniqueRule = \Illuminate\Validation\Rule::unique('copyrights', 'registration_number');
            if ($excludeId) {
                $uniqueRule->ignore($excludeId);
            }

            $validated = $request->validate([
                'song_id'             => 'required|integer|exists:songs,id',
                'copyright_type'      => 'required|in:author,performer,producer,publisher,exclusive,non_exclusive,creative_commons,public_domain',
                'owner_name'          => 'required|string|max:255',
                'registration_number' => ['nullable', 'string', 'max:100', $uniqueRule],
                'registration_date'   => 'nullable|date|before_or_equal:today',
                'registration_country'=> 'nullable|string|max:100',
                'valid_from'          => 'required|date',
                'valid_until'         => 'nullable|date|after:valid_from',
                'territory'           => 'nullable|string|max:255',
                'rights_included'     => 'nullable|string',
                'document_url'        => 'nullable|url|max:500',
                'notes'               => 'nullable|string',
                'contract_file'       => 'nullable|file|mimes:pdf,doc,docx,jpg,jpeg,png|max:10240',
            ]);

            // Xử lý upload file lên Cloudinary
            $documentUrl = null;
            if ($request->hasFile('contract_file')) {
                $regNum      = $validated['registration_number'] ?? 'no_reg_number';
                $documentUrl = $this->uploadToCloudinary($request->file('contract_file'), $regNum);
            } elseif (isset($validated['document_url'])) {
                $documentUrl = $validated['document_url'];
            }

            // Kiểm tra trùng lặp — bỏ qua các record đã bị rejected hoặc revoked
            $existing = Copyright::where('song_id', $validated['song_id'])
                ->where('partner_id', $partner->id)
                ->whereNotIn('status', ['rejected', 'revoked'])
                ->first();

            if ($existing) {
                return response()->json([
                    'success' => false,
                    'message' => 'Copyright record already exists for this song and partner'
                ], 409);
            }

            // Tạo mới bản ghi — status mặc định là pending (chờ admin duyệt)
            $copyright = Copyright::create([
                'song_id'             => $validated['song_id'],
                'partner_id'          => $partner->id,
                'copyright_type'      => $validated['copyright_type'],
                'owner_name'          => $validated['owner_name'],
                'registration_number' => $validated['registration_number'] ?? null,
                'registration_date'   => $validated['registration_date'] ?? null,
                'registration_country'=> $validated['registration_country'] ?? null,
                'valid_from'          => $validated['valid_from'],
                'valid_until'         => $validated['valid_until'] ?? null,
                'territory'           => $validated['territory'] ?? 'Worldwide',
                'rights_included'     => $validated['rights_included'] ?? null,
                'document_url'        => $documentUrl,
                'notes'               => $validated['notes'] ?? null,
                'status'              => 'pending',
            ]);

            $copyright->load(['partner', 'song']);

            // Đồng bộ copyright_status trên song → 'pending'
            $this->syncSongCopyrightStatus($copyright);

            return response()->json([
                'success' => true,
                'message' => 'Copyright registration submitted successfully',
                'data'    => $copyright
            ], 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors'  => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while creating copyright',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Upload file contract riêng lẻ cho một bản quyền
     */
    public function uploadContract(Request $request, $id)
    {
        try {
            $partner = Partner::where('user_id', $request->user()->id)
                ->where('status', 'active')
                ->first();

            if (!$partner) {
                return response()->json([
                    'success' => false,
                    'message' => 'Partner not found or not active'
                ], 403);
            }

            $copyright = Copyright::where('id', $id)
                ->where('partner_id', $partner->id)
                ->first();

            if (!$copyright) {
                return response()->json([
                    'success' => false,
                    'message' => 'Copyright not found'
                ], 404);
            }

            if ($copyright->verified_at) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot update a verified copyright record'
                ], 403);
            }

            $request->validate([
                'contract_file' => 'required|file|mimes:pdf,doc,docx,jpg,jpeg,png|max:10240',
            ]);

            $file = $request->file('contract_file');
            $regNum = $copyright->registration_number ?? 'no_reg';
            $docUrl = $this->uploadToCloudinary($file, $regNum);

            $copyright->update(['document_url' => $docUrl]);

            return response()->json([
                'success'      => true,
                'message'      => 'Contract uploaded successfully',
                'document_url' => $docUrl,
                'data'         => $copyright->fresh(['partner', 'song'])
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors'  => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while uploading contract',
                'error'   => $e->getMessage()
            ], 500);
        }
    }
}