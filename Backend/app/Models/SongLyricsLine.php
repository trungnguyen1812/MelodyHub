<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class SongLyricsLine
 * 
 * @property int $id
 * @property int $song_id
 * @property int $line_number
 * @property int $start_time_ms
 * @property string $text_line
 * 
 * @property Song $song
 *
 * @package App\Models
 */
class SongLyricsLine extends Model
{
	protected $table = 'song_lyrics_lines';
	public $timestamps = false;

	protected $casts = [
		'song_id' => 'int',
		'line_number' => 'int',
		'start_time_ms' => 'int'
	];

	protected $fillable = [
		'song_id',
		'line_number',
		'start_time_ms',
		'text_line'
	];

	public function song()
	{
		return $this->belongsTo(Song::class);
	}
}
