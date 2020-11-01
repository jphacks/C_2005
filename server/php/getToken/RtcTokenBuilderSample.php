<?php
include("../src/RtcTokenBuilder.php");

$appID = "a8c5bf6cfcac4f3a80c5e379becea87d";
$appCertificate = "afa3c3c889ae49c2acb2e3e3e961cfdc";
$channelName = $_GET["channelName"];
$uid = (isset($_GET["uid"]) && $_GET["uid"]) ? $_GET["uid"] : 0;
//$uidStr = "2882341273";
$role = RtcTokenBuilder::RoleAttendee;
$expireTimeInSeconds = 3600;
$currentTimestamp = (new DateTime("now", new DateTimeZone('UTC')))->getTimestamp();
$privilegeExpiredTs = $currentTimestamp + $expireTimeInSeconds;

$token = RtcTokenBuilder::buildTokenWithUid($appID, $appCertificate, $channelName, $uid, $role, $privilegeExpiredTs);
echo $token ;
/*
$token = RtcTokenBuilder::buildTokenWithUserAccount($appID, $appCertificate, $channelName, $uidStr, $role, $privilegeExpiredTs);
echo 'Token with user account: ' . $token . PHP_EOL;
*/
?>
