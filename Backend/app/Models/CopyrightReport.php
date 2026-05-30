<?php

/**
 * Updated CopyrightReport Model for soundalike integration
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class CopyrightReport
 * 
 * @property int $id
 * @property string $reporter_type
 * @property int|null $reporter_partner_id
 * @property int|null $reporter_user_id
 * @property int|null $claimant_copyright_id
 * @property int $original_song_id
 * @property int $infringing_song_id
 * @property string|null $violation_type
 * @property string|null $description
 * @property array|null $evidence_files
 * @property float|null $similarity_score
 * @property string|null $ai_report_path
 * @property string|null $status
 * @property string|null $resolution_note
 * @property int|null $resolved_by
 * @property Carbon|null $resolved_at
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * NEW FIELDS (add to your table first):
 * @property float|null $similarity_raw
 * @property int|null $comparison_duration_ms
 * @property bool|null $fingerprint_cache_hit
 * 
 * @property Copyright|null $copyright
 * @property Song $originalSong
 * @property Song $infringingSong
 * @property Partner|null $reporterPartner
 * @property User|null $reporterUser
 * @property Admin|null $resolvedBy
 *
 * @package App\Models
 */
class CopyrightReport extends Model
{
	protected $table = 'copyright_reports';

	protected $casts = [
		'reporter_partner_id' => 'int',
		'reporter_user_id' => 'int',
		'claimant_copyright_id' => 'int',
		'original_song_id' => 'int',
		'infringing_song_id' => 'int',
		'evidence_files' => 'json',
		'similarity_score' => 'float',
		'similarity_raw' => 'float',  // NEW
		'comparison_duration_ms' => 'int',  // NEW
		'fingerprint_cache_hit' => 'boolean',  // NEW
		'resolved_by' => 'int',
		'resolved_at' => 'datetime',
		'created_at' => 'datetime',
		'updated_at' => 'datetime'
	];

	protected $fillable = [
		'reporter_type',
		'reporter_partner_id',
		'reporter_user_id',
		'claimant_copyright_id',
		'original_song_id',
		'infringing_song_id',
		'violation_type',
		'description',
		'evidence_files',
		'similarity_score',
		'similarity_raw',  // NEW
		'ai_report_path',
		'status',
		'resolution_note',
		'resolved_by',
		'resolved_at',
		'comparison_duration_ms',  // NEW
		'fingerprint_cache_hit'  // NEW
	];

	// ============ Relationships ============
	
	/**
	 * Relationship to the copyright claim (if any)
	 */
	public function copyright()
	{
		return $this->belongsTo(Copyright::class, 'claimant_copyright_id');
	}

	/**
	 * ORIGINAL song (the copyrighted song)
	 */
	public function originalSong()
	{
		return $this->belongsTo(Song::class, 'original_song_id');
	}

	/**
	 * INFRINGING song (the song being reported)
	 */
	public function infringingSong()
	{
		return $this->belongsTo(Song::class, 'infringing_song_id');
	}

	/**
	 * Reporter as Partner
	 */
	public function reporterPartner()
	{
		return $this->belongsTo(Partner::class, 'reporter_partner_id');
	}

	/**
	 * Reporter as User (normal user)
	 */
	public function reporterUser()
	{
		return $this->belongsTo(User::class, 'reporter_user_id');
	}

	/**
	 * Admin who resolved this report
	 */
	public function resolvedBy()
	{
		return $this->belongsTo(User::class, 'resolved_by');
	}

	// ============ Accessors & Mutators ============
	
	/**
	 * Get similarity percentage (alias for similarity_score)
	 */
	public function getSimilarityPercentageAttribute(): ?float
	{
		return $this->similarity_score;
	}
	
	/**
	 * Get human-readable status
	 */
	public function getStatusLabelAttribute(): string
	{
		return [
			'pending' => 'Pending',
			'ai_scanning' => 'AI Scanning',
			'auto_rejected' => 'Auto Rejected (Below 60%)',
			'reviewing' => 'Under Review',
			'resolved_removed' => 'Resolved - Song Removed',
			'resolved_kept' => 'Resolved - Song Kept',
			'rejected' => 'Rejected'
		][$this->status] ?? $this->status;
	}
	
	/**
	 * Get status color for UI
	 */
	public function getStatusColorAttribute(): string
	{
		return [
			'pending' => 'warning',
			'ai_scanning' => 'info',
			'auto_rejected' => 'success',
			'reviewing' => 'danger',
			'resolved_removed' => 'dark',
			'resolved_kept' => 'secondary',
			'rejected' => 'light'
		][$this->status] ?? 'secondary';
	}
	
	/**
	 * Check if report is a violation (similarity >= 60%)
	 */
	public function getIsViolationAttribute(): bool
	{
		return ($this->similarity_score ?? 0) >= 60;
	}
	
	/**
	 * Get AI report as array
	 */
	public function getAiReportAttribute(): ?array
	{
		if (!$this->ai_report_path) {
			return null;
		}
		
		return json_decode($this->ai_report_path, true);
	}
	
	/**
	 * Check if report needs admin attention
	 */
	public function needsAdminAttention(): bool
	{
		return $this->status === 'reviewing' || 
		       ($this->status === 'pending' && ($this->similarity_score ?? 0) >= 60);
	}

	// ============ Scopes ============
	
	/**
	 * Scope for pending reports (waiting for AI scan)
	 */
	public function scopePending($query)
	{
		return $query->where('status', 'pending');
	}
	
	/**
	 * Scope for reports needing admin review
	 */
	public function scopeNeedsReview($query)
	{
		return $query->where('status', 'reviewing')
		             ->where('similarity_score', '>=', 60);
	}
	
	/**
	 * Scope for auto-rejected reports (below threshold)
	 */
	public function scopeAutoRejected($query)
	{
		return $query->where('status', 'auto_rejected');
	}
	
	/**
	 * Scope for high similarity reports (for admin to prioritize)
	 */
	public function scopeHighSimilarity($query, float $threshold = 80)
	{
		return $query->where('similarity_score', '>=', $threshold);
	}
	
	/**
	 * Scope for reports by a specific partner
	 */
	public function scopeByPartner($query, int $partnerId)
	{
		return $query->where('reporter_partner_id', $partnerId);
	}
	
	/**
	 * Scope for reports by a specific user
	 */
	public function scopeByUser($query, int $userId)
	{
		return $query->where('reporter_user_id', $userId);
	}
	
	/**
	 * Scope for resolved reports
	 */
	public function scopeResolved($query)
	{
		return $query->whereIn('status', ['resolved_removed', 'resolved_kept', 'rejected']);
	}

	// ============ Helper Methods ============
	
	/**
	 * Approve this report (admin action)
	 */
	public function approve(string $note = null, int $adminId): bool
	{
		return $this->update([
			'status' => 'resolved_removed',
			'resolution_note' => $note,
			'resolved_by' => $adminId,
			'resolved_at' => now()
		]);
	}
	
	/**
	 * Reject this report (admin action)
	 */
	public function reject(string $note = null, int $adminId): bool
	{
		return $this->update([
			'status' => 'rejected',
			'resolution_note' => $note,
			'resolved_by' => $adminId,
			'resolved_at' => now()
		]);
	}
	
	/**
	 * Auto-reject (similarity below threshold)
	 */
	public function autoReject(): bool
	{
		return $this->update([
			'status' => 'auto_rejected'
		]);
	}
	
	/**
	 * Mark as AI scanning
	 */
	public function markAsScanning(): bool
	{
		return $this->update([
			'status' => 'ai_scanning'
		]);
	}
	
	/**
	 * Save soundalike result
	 */
	public function saveSoundalikeResult(
		float $similarityRaw, 
		float $similarityPercent, 
		array $aiReport,
		int $durationMs,
		bool $cacheHit = false
	): bool {
		return $this->update([
			'similarity_raw' => $similarityRaw,
			'similarity_score' => $similarityPercent,
			'ai_report_path' => json_encode($aiReport),
			'comparison_duration_ms' => $durationMs,
			'fingerprint_cache_hit' => $cacheHit,
			'status' => $similarityPercent >= 60 ? 'reviewing' : 'auto_rejected'
		]);
	}
}