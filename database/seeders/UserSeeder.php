<?php

namespace Database\Seeders;

use App\Enums\UserRole;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // Default Customer
        User::updateOrCreate(
            ['email' => 'customer@kcs.com'],
            [
                'name' => 'Sample Customer',
                'password' => Hash::make('password'),
                'role' => UserRole::Customer,
            ]
        );

        // Default Barista
        User::updateOrCreate(
            ['email' => 'barista@kcs.com'],
            [
                'name' => 'Master Barista',
                'password' => Hash::make('password'),
                'role' => UserRole::Barista,
            ]
        );
    }
}
