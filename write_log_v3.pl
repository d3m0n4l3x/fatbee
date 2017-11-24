#!/usr/bin/perl -w
$|=1;

sub write_log($$$$$$$){
	$log_file_path=shift;
	$src_ip=shift;
	$dst_ip=shift;
	$comm_proto=shift;
	$src_port=shift;
	$dst_port=shift;
	$log_content=shift;
	$current_time=localtime();
	#$whole_log=$current_time.','.$src_ip.','.$dst_ip.','.$comm_proto.','.$src_port.','.$dst_port.','.$log_content."\n";
	$whole_log="$current_time, $src_ip:$comm_proto$src_port -> $dst_ip:$comm_proto$dst_port, $log_content\n";
	open(LOG, ">>$log_file_path");
	#print LOG "Current_time,Src_IP,Dst_IP,Protocol,Src_Port,Dst_Port,Content\n";
	print LOG $whole_log;
	close(LOG);
	return;
}

#main()
#&write_log("192.168.0.8", "192.168.0.1", "tcp", "1029", "21", "Test");

1;
