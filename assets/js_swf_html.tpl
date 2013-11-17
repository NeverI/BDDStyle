<!DOCTYPE html>
<html>
<head>
    <title>BDD javascript/swf tests</title>
</head>
<body>
    <div id="haxe:trace" style="white-space:pre; height:500px"></div>
    <script type="application/javascript" src="%js%"></script>

    <div style="width: 100%; height: 500px">
        <object width="100%" height="100%">
            <param name="movie" value="%swf%">
            <embed src="%swf%" width="100%" height="100%"></embed>
        </object>
    </div>
    %liveReload%
</body>
</html>
