<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Country
 * 
 * @property string $code
 * @property string $code3
 * @property string $name_en
 * @property string $name_vi
 * @property string|null $flag_emoji
 * @property string|null $calling_code
 * @property bool $is_active
 * @property int $priority
 * 
 * @property Collection|TrendingSong[] $trending_songs
 * @property Collection|User[] $users
 *
 * @package App\Models
 */
class Country extends Model
{
	protected $table = 'countries';
	protected $primaryKey = 'code';
	public $incrementing = false;
	public $timestamps = false;

	protected $casts = [
		'is_active' => 'bool',
		'priority' => 'int'
	];

	protected $fillable = [
		'code3',
		'name_en',
		'name_vi',
		'flag_emoji',
		'calling_code',
		'is_active',
		'priority'
	];

	public function trending_songs()
	{
		return $this->hasMany(TrendingSong::class, 'country_code');
	}

	public function users()
	{
		return $this->hasMany(User::class, 'country');
	}
}
