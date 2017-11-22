#!/usr/bin/perl -w
#v1: add XML Reader.
$|=1;

sub read_xml($){
	$file_name=shift;
	open(XML, "$file_name");
	@config_content=<XML>;
	close(XML);
	chomp(@config_content);
	#print "@config_content\n";
	$config_content_string="@config_content";
	#print "$config_content_string\n";
	if($config_content_string=~/<profile_name>(.*)<\/profile_name>/){
		$profile_name=$1;
		print "\$profile_name=$profile_name\n";
	}
	if($config_content_string=~/<honeypot_ip>(.*)<\/honeypot_ip>/){
		$honeypot_ip=$1;
		print "\$honeypot_ip=$honeypot_ip\n";
	}
	if($config_content_string=~/<protocol>(.*)<\/protocol>/){
		$protocol=$1;
		print "\$protocol=$protocol\n";
	}
	if($config_content_string=~/<port>(.*)<\/port>/){
		$port=$1;
		print "\$port=$port\n";
	}
	if($config_content_string=~/<99>.*<close>(.*)<\/close>.*<\/99>/){
		$active_close=$1;
		print "\$active_close=$active_close\n";
	}
#Biggest number:
	for($count1=98; $count1>=0; $count1--){
		#print "$count1\n";
		if($config_content_string=~/<$count1>.*<\/$count1>/){
			$biggest_number=$count1;
			print "Biggest number: $biggest_number\n";
			last;
		}
	}
#Least number:
	$least_number=0;
	print "Least number: $least_number\n";
#Read each item:
	for($count2=$least_number; $count2<=$biggest_number; $count2++){
		if($config_content_string=~/<$count2>.*<active>(.*)<\/active>.*<content>(.*)<\/content>.*<\/$count2>/){
			$session{$count2}{'active'}=$1;
			$session{$count2}{'content'}=$2;
		}else{
			$session{$count2}{'active'}=0;
			$session{$count2}{'content'}='[NULL]';
		}
		print "$count2 : <active>$session{$count2}{'active'}<\/active><content>$session{$count2}{'content'}<\/content>\n";
	}
#Return
	return ($profile_name, $honeypot_ip, $protocol, $port, $active_close, $biggest_number, $least_number, %session);
}



#main()
#&read_xml("/usr/local/sbin/fatbee/0.0.0.0_ftp_tcp21.xml");


1;
