<?php

/**
 * Created by Reliese Model.
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
 * @property Copyright|null $copyright
 * @property Song $song
 * @property Partner|null $partner
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
		'resolved_by' => 'int',
		'resolved_at' => 'datetime'
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
		'ai_report_path',
		'status',
		'resolution_note',
		'resolved_by',
		'resolved_at'
	];

	public function copyright()
	{
		return $this->belongsTo(Copyright::class, 'claimant_copyright_id');
	}

	public function song()
	{
		return $this->belongsTo(Song::class, 'original_song_id');
	}

	public function partner()
	{
		return $this->belongsTo(Partner::class, 'reporter_partner_id');
	}
}
