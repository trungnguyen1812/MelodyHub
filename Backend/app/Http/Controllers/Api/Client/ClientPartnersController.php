<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Partner;
use App\Models\Role;
use Cloudinary\Cloudinary;
use Illuminate\Http\UploadedFile;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;

use Cloudinary\Configuration\Configuration;

class ClientPartnersController extends Controller
{
    protected Cloudinary $cloudinary; 

    public function __construct()
    {
        $this->cloudinary = new Cloudinary(
            new Configuration([
                'cloud' => [
                    'cloud_name' => config('cloudinary.cloud_name'),
                    'api_key'    => config('cloudinary.api_key'),
                    'api_secret' => config('cloudinary.api_secret'),
                ],
                'url' => [
                    'secure' => true,
                ],
            ])
        );
    }

    public function add(Request $request)
    {
        try {
            $request->validate([
                'partner_type_id'          => 'required|integer',
                'company_name'             => 'required|string|max:255',
                'company_email'            => 'required|email',
                'company_phone'            => 'nullable|string',
                'company_address'          => 'nullable|string',
                'tax_code'                 => 'nullable|string',
                'website'                  => 'nullable|string',
                'description'              => 'nullable|string',
                'logo_url'                 => 'nullable|string',

                'contract_number'          => 'required|string',
                'contract_start_date'      => 'required|date',
                'revenue_share_percentage' => 'nullable|numeric',
                'payment_threshold'        => 'nullable|numeric',
                'payment_frequency'        => 'nullable|in:weekly,monthly,quarterly',

                'bank_name'                => 'required|string',
                'bank_branch'              => 'nullable|string',
                'bank_account_number'      => 'required|string',
                'bank_account_name'        => 'required|string',

                'contract_file' => [
                    'required',
                    'file',
                    'max:10240',
                    function ($attribute, $value, $fail) {
                        $ext = strtolower($value->getClientOriginalExtension());
                        $allowed = ['pdf', 'doc', 'docx'];
                        if (!in_array($ext, $allowed)) {
                            $fail("The {$attribute} must be a valid contract file (pdf, doc, docx).");
                        }
                    },
                ],
            ]);

            DB::beginTransaction();

            $file     = $request->file('contract_file');
            $fileName = $request->contract_number . '_' . time();

            $uploaded = $this->cloudinary->uploadApi()->upload(
                $file->getRealPath(),
                [
                    'folder'        => 'contracts',
                    'public_id'     => $fileName,
                    'resource_type' => 'raw',
                ]
            );

            $userId = $request->user()?->id ?? $request->input('user_id');

            $partner = Partner::create([
                'user_id' => $userId,

                'partner_type_id'          => $request->partner_type_id,
                'company_name'             => $request->company_name,
                'company_email'            => $request->company_email,
                'company_phone'            => $request->company_phone,
                'company_address'          => $request->company_address,
                'tax_code'                 => $request->tax_code,
                'website'                  => $request->website,
                'description'              => $request->description,
                'logo_url'                 => $request->logo_url,

                'contract_number'          => $request->contract_number,
                'contract_file_url'        => $uploaded['secure_url'],
                'contract_start_date'      => $request->contract_start_date,
                'contract_end_date'        => now()->addYear(),
                'revenue_share_percentage' => $request->revenue_share_percentage,
                'payment_threshold'        => $request->payment_threshold,
                'payment_frequency'        => $request->payment_frequency,

                'bank_name'                => $request->bank_name,
                'bank_branch'              => $request->bank_branch,
                'bank_account_number'      => $request->bank_account_number,
                'bank_account_name'        => $request->bank_account_name,

                'status'                   => 'pending',
            ]);

            // Gán role 'partner' cho user - Sửa phần này
            $partnerRole = DB::table('roles')->where('name', 'partner')->first();
            
            // Nếu chưa có role partner thì tạo mới
            if (!$partnerRole) {
                $partnerRoleId = DB::table('roles')->insertGetId([
                    'name' => 'partner',
                    'description' => 'Partner/Producer',
                    'created_at' => now(),
                    'updated_at' => now()
                ]);
            } else {
                $partnerRoleId = $partnerRole->id;
            }
            
            // Kiểm tra xem user đã có role partner chưa
            $existingRole = DB::table('user_roles')
                ->where('user_id', $userId)
                ->where('role_id', $partnerRoleId)
                ->first();
            
            // Nếu chưa có thì gán role partner
            if (!$existingRole) {
                DB::table('user_roles')->insert([
                    'user_id' => $userId,
                    'role_id' => $partnerRoleId,
                    'assigned_by' => $request->user()?->id ?? null,
                    'assigned_at' => now(),
                    'is_primary' => 0
                ]);
            }

            DB::commit();

            return response()->json([
                'message' => 'Create partner success',
                'data'    => $partner,
            ], 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Validation failed',
                'errors'  => $e->errors(),
            ], 422);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Error creating partner',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    public function index() {
        $partner = Partner::all();
         return response()->json($partner);
    }
}
