#!/usr/bin/perl -w
#Send Syslog
use IO::Socket;
$|=1;


@syslogd_servers=(
#'184.0.1.42,udp,514',
#'184.0.1.43,udp,514',
#'184.0.1.189,udp,514',
#'184.0.172.222,udp,514',
#'184.0.1.39,udp,514',
'127.0.0.1,udp,333',
);


sub send_syslog($){
	$syslog_message=shift;
	for $syslogd_server (@syslogd_servers){
		if($syslogd_server=~m/(.*),(.*),(.*)/){
			$syslogd_server_ip=$1;
			$syslogd_server_prot=$2;
			$syslogd_server_port=$3;
		}
		$syslogd_socket=IO::Socket::INET->new(Proto=>$syslogd_server_prot, PeerHost=>$syslogd_server_ip, PeerPort=>$syslogd_server_port) || die "Syslog_Sender: Cannot create Socket!\n";
		$syslogd_socket->send($syslog_message) || die "Syslog_Sender: Cannot send data!\n";
		$syslogd_socket->close();
	}
	return 1;
}


1;
