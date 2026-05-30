<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class SoundalikeService
{
    protected $baseUrl;
    protected $threshold;
    
    public function __construct()
    {
        $this->baseUrl = config('services.soundalike.url');
        $this->threshold = config('services.soundalike.threshold', 60);
    }
    
    public function compare($url1, $url2, $fpcalcLength = 60)
    {
        $response = Http::timeout(120)->asForm()->post(
            $this->baseUrl . '/compare-urls',
            [
                'url1' => $url1,
                'url2' => $url2,
                'fpcalc_length' => $fpcalcLength,
            ]
        );
        
        if ($response->failed()) {
            return [
                'success' => false,
                'error' => $response->body(),
            ];
        }
        
        $result = $response->json();
        
        return [
            'success' => true,
            'similarity_raw' => $result['similarity_raw'],
            'similarity_percent' => $result['similarity_percent'],
            'is_violation' => $result['is_violation'],
        ];
    }
    
    public function health()
    {
        $response = Http::get($this->baseUrl . '/health');
        return $response->json();
    }
}