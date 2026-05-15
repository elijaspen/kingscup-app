<?php

namespace Database\Seeders;

use App\Models\Barangay;
use Illuminate\Database\Seeder;

class BarangaySeeder extends Seeder
{
    public function run(): void
    {
        $barangays = [
            'Atabay', 'Badiang', 'Bariri', 'Bugarot', 'Cansadan', 'Dalañas', 'Durog', 'Funda-Dalipe',
            'Igbaclag', 'Inabasan', 'Madrangal', 'Magcalon', 'Malaiba', 'Maybato Norte', 'Maybato Sur',
            'Mojon', 'Pantao', 'Poblacion 1', 'Poblacion 2', 'Poblacion 3', 'Poblacion 4', 'Poblacion 5',
            'San Angel', 'San Fernando', 'San Pedro', 'Supa', 'Tubig',
        ];

        foreach ($barangays as $name) {
            Barangay::updateOrCreate(['name' => $name]);
        }
    }
}
