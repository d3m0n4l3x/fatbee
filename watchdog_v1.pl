#!/usr/bin/perl -w
#Watchdog v1 for FatBee
$|=1;


$amount_of_honeypot_processes = 3;
$amount_of_correlation_analysis_engine = 1;


$result_for_fatbee=`ps -aef|grep perl|grep honeypot|grep -v watch|grep -v grep|wc -l`;
chop($result_for_fatbee);

$result_for_correlation_analysis_engine=`ps -aef|grep perl|grep correlation|grep -v watch|grep -v grep|wc -l`;
chop($result_for_correlation_analysis_engine);

if(($result_for_fatbee != $amount_of_honeypot_processes) || ($result_for_correlation_analysis_engine != $amount_of_correlation_analysis_engine)){
	print "Restarting rc.local...";
	system("/etc/init.d/rc.local restart");
	print "Done!\n";
}else{
	print "Okay!\n";
}


exit(1);