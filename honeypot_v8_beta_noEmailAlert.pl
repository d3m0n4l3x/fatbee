#!/usr/bin/perl -w
#v6: Added Correlation Analysis function
require "/usr/local/sbin/fatbee/check_ssmtp_v1.pl";
require "/usr/local/sbin/fatbee/xml_reader_v1.pl";
require "/usr/local/sbin/fatbee/write_log_v3.pl";
require "/usr/local/sbin/fatbee/send_syslog_v1.pl";
#require "/usr/local/sbin/fatbee/send_email_through_gmail_v3.pl";
require "/usr/local/sbin/fatbee/write_correlation_log_v2.pl";
use IO::Socket;
use Sys::Hostname;
$|=1;
$hostname=hostname();


sub honeypot($$$$$$$$%){
	($honeypot_log_file, $honeypot_name, $honeypot_ip_address, $honeypot_protocol, $honeypot_port, $honeypot_active_close, $session_biggest_number, $session_least_number, %honeypot_session)=@_;

	print "Honeypot \"$honeypot_name\" is listening on $honeypot_ip_address:$honeypot_protocol$honeypot_port!\n";

	$sock=IO::Socket::INET->new(Listen=>10,LocalHost=>$honeypot_ip_address,Proto=>$honeypot_protocol,LocalPort=>$honeypot_port) || die "$honeypot_ip_address:$honeypot_protocol$honeypot_port cannot be created!\n";
	
	GET_CLIENT: while(1){
		next unless $client_sock=$sock->accept();
		$client_sock->autoflush(1);
		$received_data_accumulated="";
		$current_time=`date +\"\%b \%d \%T \%Y\"`;
		chop($current_time);
		$client_ip=$client_sock->peerhost();
		$client_port=$client_sock->peerport();
		print "$current_time, \$client: $client_ip:$honeypot_protocol$client_port\n";
#Example of Syslog Message:
#<38>Dec 30 12:51:22 LinuxTest snort[2466]: [1:2009358:5] ET SCAN Nmap Scripting Engine User-Agent Detected (Nmap Scripting Engine) [Classification: Web Application Attack] [Priority: 1] {TCP} 184.0.172.222:39200 -> 184.0.1.189:80
		undef($syslog_message_about_session_commencement);
		$syslog_message_about_session_commencement='<38>'.$current_time." $hostname honeypot\[11\]: \[11:11:11\] ".
			'Honeypot is being connected '."\[Classification: Known malware command and control traffic\] \[Priority: 1\]".
			" \{$honeypot_protocol\} ".$client_ip.":".$client_port.' -> '.$honeypot_ip_address.
			":".$honeypot_port;
		&send_syslog($syslog_message_about_session_commencement);
		#&send_by_gmail("Alert!", $syslog_message_about_session_commencement);
		&write_correlation_log($client_ip, $honeypot_ip_address, $honeypot_protocol, $client_port, $honeypot_port);
		for($count3=$session_least_number; $count3<=$session_biggest_number; $count3++){
			#print "Active: ".$honeypot_session{$count3}{'active'}."\n";
			if($honeypot_session{$count3}{'active'}==1){
				$send_payload=$honeypot_session{$count3}{'content'};
				#print "Sending $send_payload!\n";
				if($send_payload=~/\\r/){
					$send_payload=~s/\\r/\r/g;
				}
				if($send_payload=~/\\n/){
					$send_payload=~s/\\n/\n/g;
				}
				#print "----\n\$send_payload: $send_payload----\n";		#Debug
				$client_sock->send($send_payload);
				&write_log($honeypot_log_file, $honeypot_ip_address, $client_ip, $honeypot_protocol, $honeypot_port, $client_port, $honeypot_session{$count3}{'content'});
			}else{
				$client_sock->recv($data, 1024);
				if(length($data)==0){
					$client_sock->close();
					$current_time=`date +\"\%b \%d \%T \%Y\"`;
					chop($current_time);
					$syslog_message_about_session_ending='<38>'.$current_time." $hostname honeypot\[11\]: \[11:11:11\] ".
						"The connection is closed! Content : $received_data_accumulated"." |  \[Classification: Known malware command and control traffic\]".
						" \[Priority: 1\]"." \{$honeypot_protocol\} ".$client_ip.":".$client_port.' -> '
						.$honeypot_ip_address.":".$honeypot_port;
					&send_syslog($syslog_message_about_session_ending);
					next GET_CLIENT;
				}
				$data_for_log=$data;
				if($data_for_log=~/\r/){
					$data_for_log=~s/\r/\\r/g;
				}
				if($data_for_log=~/\n/){
					$data_for_log=~s/\n/\\n/g;
				}
				&write_log($honeypot_log_file, $client_ip, $honeypot_ip_address, $honeypot_protocol, $client_port, $honeypot_port, $data_for_log);
				$received_data_accumulated=$received_data_accumulated.' | '.$data_for_log;
			}
		}
		if($honeypot_active_close==1){
			$client_sock->close();
			#print "Automatically closed!\n";				#Debug
			$current_time=`date +\"\%b \%d \%T \%Y\"`;
			chop($current_time);
			$syslog_message_about_session_ending='<38>'.$current_time." $hostname honeypot\[11\]: \[11:11:11\] ".
				"The connection is closed! Content : $received_data_accumulated"." |  \[Classification: Known malware command and control traffic\]".
				" \[Priority: 1\]"." \{$honeypot_protocol\} ".$client_ip.":".$client_port.' -> '
				.$honeypot_ip_address.":".$honeypot_port;
			&send_syslog($syslog_message_about_session_ending);
		}else{
			while(1){
				$client_sock->recv($data, 1024);
				if(length($data)==0){
					$client_sock->close();
					$current_time=`date +\"\%b \%d \%T \%Y\"`;
					chop($current_time);
					$syslog_message_about_session_ending='<38>'.$current_time." $hostname honeypot\[11\]: \[11:11:11\] ".
						"The connection is closed! Content : $received_data_accumulated"." |  \[Classification: Known malware command and control traffic\]".
						" \[Priority: 1\]"." \{$honeypot_protocol\} ".$client_ip.":".$client_port.' -> '
						.$honeypot_ip_address.":".$honeypot_port;
					&send_syslog($syslog_message_about_session_ending);
					next GET_CLIENT;
				}
				$data_for_log=$data;
				if($data_for_log=~/\r/){
					$data_for_log=~s/\r/\\r/g;
				}
				if($data_for_log=~/\n/){
					$data_for_log=~s/\n/\\n/g;
				}
				&write_log($honeypot_log_file, $client_ip, $honeypot_ip_address, $honeypot_protocol, $client_port, $honeypot_port, $data_for_log);
				$received_data_accumulated=$received_data_accumulated.' | '.$data_for_log;
			}
		}
	}

	print "Over!\n";
	$sock->close();
}


#main()
$config_file=shift;
$log_file=shift;
if(!defined($config_file) || !defined($log_file)){
	die "Usage: $0 CONFIG_FILE_PATH LOG_FILE_PATH\n";
}
if(-e $config_file){
	;
}else{
	die "$config_file does not exist!\n";
}
#&honeypot(&read_xml("./ftp.xml"));
&check_ssmtp();
&honeypot($log_file, &read_xml($config_file));
exit(1);
