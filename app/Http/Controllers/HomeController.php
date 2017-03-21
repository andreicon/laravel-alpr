<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Filesystem\Filesystem as Filesystem;
use Illuminate\Support\Facades\Storage;
use Licenceplate;
class HomeController extends Controller
{
    public function getLicense()
    {
        return view('license');
    }
    public function postLicense(Request $request)
    {
        $all = $request->all();
        $url = Storage::putFile('public', $all['license'], 'public');
        $data['license'] = Licenceplate::recognize( storage_path('app/'.$url) );
        $data['image'] = '<img class="img-responsive" src="'.Storage::url($url).'">';
        return view('showlicense', $data);
    }
}
