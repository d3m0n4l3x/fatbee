# FatBee
A low-interaction honeypot written by demonalex, i.e. Alex Huang.

* Introduction
There are multiple functions shown below with FatBee v7.
1) A low-interaction honeypot without any vulnerability for sure.
2) Using XML files as vehicles to configure honeypots.
3) By default, there are three XML samples (i.e. FTP, HTTP, and SMTP) of honeypot configurations.
4) Each honeypot process can own a dedicated log file.
5) Allowing honeypot processes to send out logs through Syslog protocol.
6) The honeypot will send an email to a specific email address through Gmail.

* Installation
1) Copy everything to /usr/local/sbin/fatbee.
2) Change the value of $admin_mailbox at send_email_through_gmail_v2.pl to your email address.
3) Execute the program by running the command below:
/usr/local/sbin/fatbee/honeypot_v6_beta.pl /usr/local/sbin/fatbee/0.0.0.0_ftp_tcp21.xml /usr/local/sbin/fatbee/ftp.log&

