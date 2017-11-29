#!/usr/bin/perl -w
#Send_Email_through_Gmail
#v2 updated on Nov 27, 2017.
$|=1;


$admin_mailbox='admin@gmail.com';


sub check_ssmtp(){
	$result_of_checking_ssmtp=`which ssmtp`;
	chop($result_of_checking_ssmtp);
	#print "Checking ssmtp...\n";						#Debug
	if($result_of_checking_ssmtp eq ""){
		system("apt-get update");
		system("apt-get install ssmtp");
		print "Username of Gmail \(xxx\@gmail.com\) : ";
		$gmail_username=<STDIN>;
		chop($gmail_username);
		print "Password of Gmail : ";
		$gmail_password=<STDIN>;
		chop($gmail_password);
		open(SSMTP, ">/etc/ssmtp/ssmtp.conf");
		print SSMTP "root=$gmail_username\n";
		print SSMTP "mailhub=smtp.gmail.com:465\n";
		print SSMTP "FromLineOverride=YES\n";
		print SSMTP "AuthUser=$gmail_username\n";
		print SSMTP "AuthPass=$gmail_password\n";
		print SSMTP "UseTLS=YES\n\n";
		close(SSMTP);
	}
	return;
}


sub send_by_gmail($){
	$email_content=shift;
	&check_ssmtp();
	#print "Sending email...\n";						#Debug
	#system("echo \"Subject: Alert\n\n$email_content\" | ssmtp -vvv $admin_mailbox");		#Debug
	system("echo \"Subject: Alert\n\n$email_content\" | ssmtp $admin_mailbox");
	return;
}


1;
