#!/usr/bin/perl -w
$|=1;

sub write_correlation_log($$$$$){
	@log_files_path_for_correlation=("/usr/local/sbin/fatbee/correlation/all.log","/usr/local/sbin/fatbee/correlation/correlation_analysis_log.log");
	$src_ip_for_correlation=shift;
	$dst_ip_for_correlation=shift;
	$comm_proto_for_correlation=shift;
	$src_port_for_correlation=shift;
	$dst_port_for_correlation=shift;
	$current_time_for_correlation=localtime();
	($sec_for_correlation,$min_for_correlation,$hour_for_correlation,$mday_for_correlation,$mon_for_correlation,$year_for_correlation,$wday_for_correlation,$yday_for_correlation,$isdst_for_correlation)=localtime();
	$year_for_correlation += 1900;
	@abbr_for_correlation = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	#print "$year_for_correlation,$abbr_for_correlation[$mon_for_correlation],$mday_for_correlation\n";		#Debug
	$whole_log_for_correlation="$year_for_correlation-$abbr_for_correlation[$mon_for_correlation],$abbr_for_correlation[$mon_for_correlation]-$mday_for_correlation,$comm_proto_for_correlation,$src_ip_for_correlation,$src_port_for_correlation,$dst_ip_for_correlation,$dst_port_for_correlation\n";
	#$whole_log=$current_time.','.$src_ip.','.$dst_ip.','.$comm_proto.','.$src_port.','.$dst_port.','.$log_content."\n";
	#$whole_log_for_correlation="$current_time, $src_ip:$comm_proto$src_port -> $dst_ip:$comm_proto$dst_port, $log_content\n";
	foreach $log_file_path_for_correlation (@log_files_path_for_correlation){
		open(CORRELATION_LOG, ">>$log_file_path_for_correlation");
		#print LOG "Current_time,Src_IP,Dst_IP,Protocol,Src_Port,Dst_Port,Content\n";
		print CORRELATION_LOG $whole_log_for_correlation;
		close(CORRELATION_LOG);
	}
	return;
}

#main()
#&write_correlation_log("192.168.0.8", "192.168.0.1", "tcp", "1029", "21");

1;
