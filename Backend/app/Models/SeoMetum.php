<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class SeoMetum
 * 
 * @property int $id
 * @property string $entity_type
 * @property int|null $entity_id
 * @property string|null $url_path
 * @property string|null $title
 * @property string|null $description
 * @property string|null $keywords
 * @property string|null $og_title
 * @property string|null $og_description
 * @property string|null $og_image
 * @property string|null $twitter_title
 * @property string|null $twitter_description
 * @property string|null $twitter_image
 * @property string|null $canonical_url
 * @property string|null $robots
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 *
 * @package App\Models
 */
class SeoMetum extends Model
{
	protected $table = 'seo_meta';

	protected $casts = [
		'entity_id' => 'int'
	];

	protected $fillable = [
		'entity_type',
		'entity_id',
		'url_path',
		'title',
		'description',
		'keywords',
		'og_title',
		'og_description',
		'og_image',
		'twitter_title',
		'twitter_description',
		'twitter_image',
		'canonical_url',
		'robots'
	];
}
