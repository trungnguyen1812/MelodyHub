<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class EmailTemplate
 * 
 * @property int $id
 * @property string $name
 * @property string $slug
 * @property string $subject
 * @property string $body
 * @property string|null $variables
 * @property string $category
 * @property bool $is_active
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Collection|EmailLog[] $email_logs
 *
 * @package App\Models
 */
class EmailTemplate extends Model
{
	protected $table = 'email_templates';

	protected $casts = [
		'is_active' => 'bool'
	];

	protected $fillable = [
		'name',
		'slug',
		'subject',
		'body',
		'variables',
		'category',
		'is_active'
	];

	public function email_logs()
	{
		return $this->hasMany(EmailLog::class, 'template_id');
	}
}
