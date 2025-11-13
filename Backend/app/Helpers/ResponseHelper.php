<?php

namespace App\Helpers;

use Illuminate\Http\JsonResponse;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

class ResponseHelper
{
    /**
     * Cấu hình mặc định
     */
    private static $config = [
        'include_timestamp' => true,
        'include_trace_id' => true,
        'include_version' => true,
        'api_version' => 'v1',
        'wrap_data' => true,
        'meta_enabled' => true
    ];

    /**
     * Cập nhật cấu hình
     */
    public static function configure(array $config)
    {
        self::$config = array_merge(self::$config, $config);
    }

    /**
     * Response thành công cơ bản
     */
    public static function success($data = [], $message = 'Success', $code = 200)
    {
        return self::buildResponse(true, $message, $data, null, $code);
    }

    /**
     * Response lỗi cơ bản
     */
    public static function error($message = 'Error', $code = 400, $errors = [])
    {
        return self::buildResponse(false, $message, null, $errors, $code);
    }

    /**
     * Response với pagination
     */
    public static function paginated(LengthAwarePaginator $paginator, $message = 'Success', $code = 200)
    {
        return self::buildResponse(true, $message, [
            'items' => $paginator->items(),
            'pagination' => [
                'total' => $paginator->total(),
                'per_page' => $paginator->perPage(),
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'from' => $paginator->firstItem(),
                'to' => $paginator->lastItem(),
                'has_more' => $paginator->hasMorePages(),
                'links' => [
                    'first' => $paginator->url(1),
                    'last' => $paginator->url($paginator->lastPage()),
                    'prev' => $paginator->previousPageUrl(),
                    'next' => $paginator->nextPageUrl(),
                ]
            ]
        ], null, $code);
    }

    /**
     * Response với collection và meta data
     */
    public static function collection($collection, $message = 'Success', array $meta = [], $code = 200)
    {
        $data = $collection instanceof Collection ? $collection->toArray() : $collection;
        
        return self::buildResponse(true, $message, [
            'items' => $data,
            'meta' => array_merge([
                'count' => count($data),
                'total' => count($data)
            ], $meta)
        ], null, $code);
    }

    /**
     * Response validation error
     */
    public static function validation($errors, $message = 'Validation Error', $code = 422)
    {
        return self::buildResponse(false, $message, null, 
            self::formatValidationErrors($errors), $code);
    }

    /**
     * Response created (201)
     */
    public static function created($data = [], $message = 'Resource created successfully', $resourceUrl = null)
    {
        $response = self::buildResponse(true, $message, $data, null, 201);
        
        if ($resourceUrl) {
            $response->header('Location', $resourceUrl);
        }
        
        return $response;
    }

    /**
     * Response no content (204)
     */
    public static function noContent()
    {
        return response()->json(null, 204);
    }

    /**
     * Response accepted (202) - cho async operations
     */
    public static function accepted($data = [], $message = 'Request accepted for processing', $jobId = null)
    {
        $responseData = $data;
        
        if ($jobId) {
            $responseData['job_id'] = $jobId;
            $responseData['status_url'] = url("/api/jobs/{$jobId}/status");
        }
        
        return self::buildResponse(true, $message, $responseData, null, 202);
    }

    /**
     * Response unauthorized (401)
     */
    public static function unauthorized($message = 'Unauthorized', $errors = [])
    {
        return self::buildResponse(false, $message, null, $errors, 401);
    }

    /**
     * Response forbidden (403)
     */
    public static function forbidden($message = 'Forbidden', $errors = [])
    {
        return self::buildResponse(false, $message, null, $errors, 403);
    }

    /**
     * Response not found (404)
     */
    public static function notFound($message = 'Resource not found', $resource = null)
    {
        $errors = $resource ? ['resource' => $resource] : [];
        return self::buildResponse(false, $message, null, $errors, 404);
    }

    /**
     * Response conflict (409)
     */
    public static function conflict($message = 'Resource conflict', $errors = [])
    {
        return self::buildResponse(false, $message, null, $errors, 409);
    }

    /**
     * Response unprocessable entity (422)
     */
    public static function unprocessable($message = 'Unprocessable entity', $errors = [])
    {
        return self::buildResponse(false, $message, null, $errors, 422);
    }

    /**
     * Response too many requests (429)
     */
    public static function tooManyRequests($message = 'Too many requests', $retryAfter = 60)
    {
        $response = self::buildResponse(false, $message, null, [
            'retry_after' => $retryAfter
        ], 429);
        
        return $response->header('Retry-After', $retryAfter);
    }

    /**
     * Response server error (500)
     */
    public static function serverError($message = 'Internal server error', $debug = [])
    {
        $errors = config('app.debug') ? $debug : [];
        return self::buildResponse(false, $message, null, $errors, 500);
    }

    /**
     * Response service unavailable (503)
     */
    public static function serviceUnavailable($message = 'Service temporarily unavailable', $retryAfter = null)
    {
        $errors = $retryAfter ? ['retry_after' => $retryAfter] : [];
        $response = self::buildResponse(false, $message, null, $errors, 503);
        
        if ($retryAfter) {
            $response->header('Retry-After', $retryAfter);
        }
        
        return $response;
    }

    /**
     * Response với HATEOAS links
     */
    public static function withLinks($data, array $links, $message = 'Success', $code = 200)
    {
        return self::buildResponse(true, $message, [
            'data' => $data,
            'links' => self::formatLinks($links)
        ], null, $code);
    }

    /**
     * Response với included resources (JSON API style)
     */
    public static function withIncluded($data, array $included, $message = 'Success', $code = 200)
    {
        return self::buildResponse(true, $message, [
            'data' => $data,
            'included' => $included
        ], null, $code);
    }

    /**
     * Bulk operation response
     */
    public static function bulk(array $results, $message = 'Bulk operation completed')
    {
        $success = array_filter($results, fn($r) => $r['success'] ?? false);
        $failed = array_filter($results, fn($r) => !($r['success'] ?? false));
        
        return self::buildResponse(true, $message, [
            'total' => count($results),
            'successful' => count($success),
            'failed' => count($failed),
            'results' => $results
        ], null, 200);
    }

    /**
     * Response với warnings (success nhưng có cảnh báo)
     */
    public static function withWarnings($data, array $warnings, $message = 'Success with warnings', $code = 200)
    {
        return self::buildResponse(true, $message, $data, null, $code, ['warnings' => $warnings]);
    }

    /**
     * Streaming response cho large data
     */
    public static function stream($callback, $filename = 'export.json')
    {
        return response()->stream(function() use ($callback) {
            $callback();
        }, 200, [
            'Content-Type' => 'application/json',
            'Content-Disposition' => "attachment; filename=\"{$filename}\"",
            'Cache-Control' => 'no-cache',
        ]);
    }

    /**
     * Download response
     */
    public static function download($filePath, $filename = null, array $headers = [])
    {
        return response()->download($filePath, $filename, $headers);
    }

    /**
     * Redirect response
     */
    public static function redirect($url, $message = null, $code = 302)
    {
        $response = redirect($url, $code);
        
        if ($message) {
            $response->with('message', $message);
        }
        
        return $response;
    }

    /**
     * Response với custom headers
     */
    public static function withHeaders($data, array $headers, $message = 'Success', $code = 200)
    {
        $response = self::buildResponse(true, $message, $data, null, $code);
        
        foreach ($headers as $key => $value) {
            $response->header($key, $value);
        }
        
        return $response;
    }

    /**
     * Response với ETag cho caching
     */
    public static function withETag($data, $message = 'Success', $code = 200)
    {
        $etag = md5(json_encode($data));
        $response = self::buildResponse(true, $message, $data, null, $code);
        
        return $response->header('ETag', $etag);
    }

    /**
     * Conditional response (304 Not Modified)
     */
    public static function notModified()
    {
        return response()->json(null, 304);
    }

    /**
     * Response với rate limit headers
     */
    public static function withRateLimit($data, $limit, $remaining, $reset, $message = 'Success', $code = 200)
    {
        $response = self::buildResponse(true, $message, $data, null, $code);
        
        return $response
            ->header('X-RateLimit-Limit', $limit)
            ->header('X-RateLimit-Remaining', $remaining)
            ->header('X-RateLimit-Reset', $reset);
    }

    /**
     * Health check response
     */
    public static function health(array $checks = [])
    {
        $status = !in_array(false, array_column($checks, 'status'));
        
        return self::buildResponse($status, 
            $status ? 'System healthy' : 'System unhealthy', 
            [
                'status' => $status ? 'up' : 'down',
                'checks' => $checks
            ], 
            null, 
            $status ? 200 : 503
        );
    }

    /**
     * API version deprecation warning
     */
    public static function deprecated($data, $deprecationDate, $sunsetDate, $newVersion, $message = 'Success')
    {
        $response = self::buildResponse(true, $message, $data, null, 200, [
            'deprecation' => [
                'deprecated_at' => $deprecationDate,
                'sunset_at' => $sunsetDate,
                'new_version' => $newVersion,
                'migration_guide' => url("/docs/migration/{$newVersion}")
            ]
        ]);
        
        return $response
            ->header('Deprecation', $deprecationDate)
            ->header('Sunset', $sunsetDate)
            ->header('Link', "<{$newVersion}>; rel=\"successor-version\"");
    }

    /**
     * Build response structure
     */
    private static function buildResponse($success, $message, $data, $errors, $code, array $extra = []): JsonResponse
    {
        $response = [
            'status' => $success,
            'message' => $message,
        ];

        // Add data
        if ($data !== null) {
            $response[self::$config['wrap_data'] ? 'data' : 'result'] = $data;
        }

        // Add errors
        if ($errors !== null && !empty($errors)) {
            $response['errors'] = $errors;
        }

        // Add extra fields
        if (!empty($extra)) {
            $response = array_merge($response, $extra);
        }

        // Add metadata
        if (self::$config['meta_enabled']) {
            $response['meta'] = self::buildMeta();
        }

        return response()->json($response, $code);
    }

    /**
     * Build metadata
     */
    private static function buildMeta(): array
    {
        $meta = [];

        if (self::$config['include_timestamp']) {
            $meta['timestamp'] = now()->toIso8601String();
            $meta['timezone'] = config('app.timezone', 'UTC');
        }

        if (self::$config['include_trace_id']) {
            $meta['trace_id'] = request()->header('X-Request-ID') ?? uniqid('trace_', true);
        }

        if (self::$config['include_version']) {
            $meta['api_version'] = self::$config['api_version'];
        }

        return $meta;
    }

    /**
     * Format validation errors
     */
    private static function formatValidationErrors($errors): array
    {
        if ($errors instanceof \Illuminate\Support\MessageBag) {
            return $errors->toArray();
        }

        if (is_array($errors)) {
            return $errors;
        }

        return ['general' => [$errors]];
    }

    /**
     * Format HATEOAS links
     */
    private static function formatLinks(array $links): array
    {
        $formatted = [];

        foreach ($links as $rel => $href) {
            if (is_array($href)) {
                $formatted[] = array_merge(['rel' => $rel], $href);
            } else {
                $formatted[] = [
                    'rel' => $rel,
                    'href' => $href,
                    'method' => 'GET'
                ];
            }
        }

        return $formatted;
    }

    /**
     * Transform exception to response
     */
    public static function fromException(\Throwable $exception, $code = 500)
    {
        $message = $exception->getMessage() ?: 'An error occurred';
        
        $debug = config('app.debug') ? [
            'exception' => get_class($exception),
            'file' => $exception->getFile(),
            'line' => $exception->getLine(),
            'trace' => collect($exception->getTrace())->take(5)->toArray()
        ] : [];

        return self::buildResponse(false, $message, null, $debug, $code);
    }

    /**
     * Custom response builder
     */
    public static function custom(array $data, $code = 200): JsonResponse
    {
        return response()->json($data, $code);
    }
}