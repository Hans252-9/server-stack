<?php
date_default_timezone_set('Europe/Prague');
?>

<!DOCTYPE html>
<html>
<head>
    <title>Můj web</title>
<meta http-equiv="refresh" content="60">
<link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Vítej na mém serveru!</h1>
    <p>Dnešní datum a čas: <?php echo date("Y-m-d H:i:s"); ?></p>
    <hr>

    <h2>Stav serveru:</h2>
    <pre>
<?php readfile("/var/log/app/monitor.log"); ?>
    </pre>
<hr>
<p>
<a href="/iss.html">Aktualni poloha ISS</a><br>
<a href="/apod.jpg">Nasa picture of the day</a><br>
<a href="/airplanes.html">Airplanes MAP</a>
</p>
<hr>

    <h2>TEMPERATURES</h2>
    <pre>
<?php readfile("/var/log/app/weather.log"); ?>
    </pre>

    <h2>MY STONKS</h2>
    <pre>
<?php readfile("/var/log/app/portfolio.log"); ?>
    </pre>
<hr>
</body>
</html>
