<?php

namespace App\Providers;

use App\Models\User;
use App\Policies\UserPolicy;
use Illuminate\Contracts\Auth\Access\Gate as GateContract;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    protected $policies = [
        User::class => UserPolicy::class,
    ];

    public function boot(GateContract $gate): void
    {
        $this->registerPolicies();

        $gate->define('delete-post', fn(User $user) => $user->isAdmin());
    }
}
