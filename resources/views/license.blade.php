@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">Upload license</div>
                <div class="panel-body">
                    <form enctype="multipart/form-data" method="post">
                        {{ csrf_field() }}
                        <label for="license">Upload photo</label>
                        <input id="license" type="file" name="license"/>
                        <input type="submit" value="Submit"/>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
