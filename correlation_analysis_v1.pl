#!/usr/bin/perl -w
#Correlation Analysis Engine for Fatbee
#When an attack's IP address exists for many times within a specific period, warn Administrator.
#Updated on 20171202
require "/usr/local/sbin/fatbee/send_email_through_gmail_v3.pl";
$|=1;
$time_slot=2*60;								#Time Slot is 2 minutes.
$repeat_limits=5;
$correlation_analysis_log_file="/usr/local/sbin/fatbee/correlation/correlation_analysis_log.log";
$dangerous_ip_log_file="/usr/local/sbin/fatbee/correlation/dangerous_ip_log_after_analyzing.log";


#Main Function
while(1){
	#Start: Create the log file if it does not exist!
	if (-e $correlation_analysis_log_file){
		;
	}else{
		system("touch $correlation_analysis_log_file");
	}
	#End: Create the log file if it does not exist!

	#Start: Read the correlation analysis log file being written by other security engines.
	open(LOGFILE_READ, "$correlation_analysis_log_file");
	@log_content=<LOGFILE_READ>;
	chomp(@log_content);
	#
	#Example of @log_content:
	#2017-Dec,Dec-2,tcp,216.36.187.97,57962,0.0.0.0,25
	#2017-Dec,Dec-2,tcp,109.230.219.194,55546,0.0.0.0,25
	#2017-Dec,Dec-2,tcp,46.102.196.66,63502,0.0.0.0,25
	#
	close(LOGFILE_READ);
	#End: Read the correlation analysis pairs file.
	
	#&correlation_analysis_rule_2(\@log_content);

	#Start: Truncate the correlation_analysis_log_file
	open(LOGFILE_EMPTY, ">$correlation_analysis_log_file");
	print LOGFILE_EMPTY "";
	close(LOGFILE_EMPTY);	
	#End: Truncate the correlation_analysis_log_file

	#Start: Take those attackers' IP addresses
	undef(@attackers_ip_addressess);
	foreach $each_log (@log_content){
		if($each_log=~/(.*),(.*),(.*),(.*),(.*),(.*),(.*)/){
			push(@attackers_ip_addressess, $4);
		}
	}
	#End: Take those attackers' IP addresses

	#Start: Aggregate those duplicated logs.
	#The example of aggregation:
	#root@LinuxTest:~/test/Correlation_Analysis# cat ./test.pl
	##!/usr/bin/perl -w
	#use strict;
	#use warnings;
	#my @array=("abc", "def", "abc", "ghi", "gih", "abc", "gih");
	#my %hash=map {$_=>1} @array;
	#my @unique=keys %hash;
	#print "@unique\n";
	#root@LinuxTest:~/test/Correlation_Analysis# ./test.pl
	#abc gih def ghi
	%hash_attackers_ip_addressess=map {$_=>1} @attackers_ip_addressess;
	@unique_attackers_ip_addressess=keys %hash_attackers_ip_addressess;
	#End: Aggregate those duplicated logs.
	
	#Start: Count the dangerous IP addresses
	undef(@dangerous_ip_addresses); @dangerous_ip_addresses=();
	foreach $an_unique_attackers_ip_address (@unique_attackers_ip_addressess){
		$counter_a=0;
		foreach $a_attacker_ip_address (@attackers_ip_addressess){
			if($a_attacker_ip_address eq $an_unique_attackers_ip_address){
				$counter_a++;
			}
		}
		if($counter_a >= $repeat_limits){
			push(@dangerous_ip_addresses, $an_unique_attackers_ip_address);
		}
	}
	print "\@dangerous_ip_addresses : @dangerous_ip_addresses\n";		#Debug
	#End: Count the dangerous IP addresses

	$dangerous_ip_addresses_size=@dangerous_ip_addresses;
	if($dangerous_ip_addresses_size > 0){
		#Start: Organize the output of Correlation Analysis
		$current_time_a=`date +\"\%b \%d \%T \%Y\"`;
		chop($current_time_a);
		$content_regarding_correlation_analysis_alert=$current_time_a.", the following IP address\(es\) must be dangerous: \[@dangerous_ip_addresses\].\n";
		#End: Organize the output of Correlation Analysis

		#Start: Write down the aforementioned IP to a log
		open(DANGEROUS_IP_LOG, ">>$dangerous_ip_log_file");
		print DANGEROUS_IP_LOG $content_regarding_correlation_analysis_alert;
		close(DANGEROUS_IP_LOG);
		#End: Write down the aforementioned IP to a log

		#Start: Send an email regarding those dangerous IP addresses
		&send_by_gmail("Correlation Analysis Alert!", $content_regarding_correlation_analysis_alert);
		#End: Send an email regarding those dangerous IP addresses
	}

	sleep($time_slot);
}
exit(1);

