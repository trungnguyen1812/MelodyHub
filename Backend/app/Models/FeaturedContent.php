<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class FeaturedContent
 * 
 * @property int $id
 * @property string $content_type
 * @property int $content_id
 * @property string $section
 * @property string|null $title
 * @property string|null $description
 * @property string|null $image_url
 * @property int $order
 * @property Carbon|null $start_date
 * @property Carbon|null $end_date
 * @property bool $is_active
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 *
 * @package App\Models
 */
class FeaturedContent extends Model
{
	protected $table = 'featured_content';

	protected $casts = [
		'content_id' => 'int',
		'order' => 'int',
		'start_date' => 'datetime',
		'end_date' => 'datetime',
		'is_active' => 'bool'
	];

	protected $fillable = [
		'content_type',
		'content_id',
		'section',
		'title',
		'description',
		'image_url',
		'order',
		'start_date',
		'end_date',
		'is_active'
	];
}
