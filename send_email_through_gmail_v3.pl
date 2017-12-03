#!/usr/bin/perl -w
#Send_Email_through_Gmail
#v2 updated on Nov 27, 2017.
$|=1;


$admin_mailbox='admin@gmail.com';


sub send_by_gmail($$){
	$email_subject=shift;
	$email_content=shift;
	#print "Sending email...\n";						#Debug
	#system("echo \"Subject: Alert\n\n$email_content\" | ssmtp -vvv $admin_mailbox");		#Debug
	#system("echo \"Subject: Alert\n\n$email_content\" | ssmtp $admin_mailbox");			#Debug
	system("echo \"Subject: $email_subject\n\n$email_content\" | ssmtp $admin_mailbox");
	return;
}


1;
