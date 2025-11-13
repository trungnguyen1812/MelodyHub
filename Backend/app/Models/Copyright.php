<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Copyright
 * 
 * @property int $id
 * @property int $song_id
 * @property int $partner_id
 * @property string $copyright_type
 * @property string $owner_name
 * @property string|null $registration_number
 * @property Carbon|null $registration_date
 * @property string|null $registration_country
 * @property Carbon $valid_from
 * @property Carbon|null $valid_until
 * @property string|null $territory
 * @property string|null $rights_included
 * @property string|null $document_url
 * @property string|null $notes
 * @property string $status
 * @property Carbon|null $verified_at
 * @property int|null $verified_by
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Partner $partner
 * @property Song $song
 *
 * @package App\Models
 */
class Copyright extends Model
{
	protected $table = 'copyrights';

	protected $casts = [
		'song_id' => 'int',
		'partner_id' => 'int',
		'registration_date' => 'datetime',
		'valid_from' => 'datetime',
		'valid_until' => 'datetime',
		'verified_at' => 'datetime',
		'verified_by' => 'int'
	];

	protected $fillable = [
		'song_id',
		'partner_id',
		'copyright_type',
		'owner_name',
		'registration_number',
		'registration_date',
		'registration_country',
		'valid_from',
		'valid_until',
		'territory',
		'rights_included',
		'document_url',
		'notes',
		'status',
		'verified_at',
		'verified_by'
	];

	public function partner()
	{
		return $this->belongsTo(Partner::class);
	}

	public function song()
	{
		return $this->belongsTo(Song::class);
	}
}
