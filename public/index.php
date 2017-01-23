<?php
error_reporting(E_ALL);

require_once '../vendor/autoload.php';

$continue = require_once "../app/asset_fallback.php";

if ($continue ===  false) {
    return false;
}

$pageViews = require_once "../app/page_views.php";

?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Capistrano Demo</title>
</head>
<body>
    <h1>New title</h1>
    <p>This page has been seen <?php echo $pageViews; ?> times</p>
    <img src="/assets/m/ijwsd/502014250/ijwsd_id-502014250.art/502014250_univ_pnr_lg.jpg" alt="Downloading">
    <img src="/assets/m/ijwsd/502014291/ijwsd_id-502014291.art/502014291_univ_pnr_lg.jpg" alt="Downloading">
    <img src="/assets/m/ijwsd/502016720/ijwsd_id-502016720.art/502016720_univ_pnr_lg.jpg" alt="Downloading">
    <img src="/assets/m/ijwsd/502016721/ijwsd_id-502016721.art/502016721_univ_pnr_lg.jpg" alt="Downloading">

    <small>Pictures from <a href="http://jw.org">jw.org</a> </small>
</body>
</html>
