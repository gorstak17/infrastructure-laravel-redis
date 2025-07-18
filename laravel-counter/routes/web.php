<?php

use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    $count = Redis::incr('counter');
    return "Counter: $count";
});
