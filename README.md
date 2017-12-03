# FatBee
A low-interaction honeypot written by demonalex, i.e. Alex Huang.

* Introduction - There are multiple functions shown below with FatBee v8.
1) A low-interaction honeypot without any vulnerability for sure, since it is made in Perl.
2) Using XML files as vehicles to configure honeypots, and the vehicle file would be defined as the first parameter for running the primary application, i.e. honeypot_v8_beta.pl.
3) By default, there are three XML samples (i.e. FTP, HTTP, and SMTP) of honeypot configurations.
4) Each honeypot process can own a dedicated log file, which would be specified as the second parameter for running the primary application, i.e. honeypot_v8_beta.pl.
5) Allowing the honeypot processes to send out logs through Syslog protocol, and everything can be defined in the send_syslog_v1.pl.
6) The honeypot will send an email to a specific email address through Gmail, and the email address is defined in the send_email_through_gmail_v3.pl.

* Installation
1) Copy everything to /usr/local/sbin/fatbee.
2) Change the value of $admin_mailbox at send_email_through_gmail_v3.pl to your email address.
3) Execute the program by running the following commands:
/usr/local/sbin/fatbee/honeypot_v8_beta.pl /usr/local/sbin/fatbee/0.0.0.0_ftp_tcp21.xml /usr/local/sbin/fatbee/ftp.log&
/usr/local/sbin/fatbee/correlation_analysis_v1.pl&
4) If you would like to run the aforementioned commands right away after rebooting, just need to copy the rc.local to the /etc folder.
5) Monitoring the status of the honeypot can be carried out by executing the command below.
/usr/local/sbin/fatbee/monitor.sh
6) Furthermore, if you would like to observe the status of Correlation Analysis, you can execute the following command:
/usr/local/sbin/fatbee/monitor_correlation_analysis.sh

* Enjoy my FatBee! ~ demonalex
