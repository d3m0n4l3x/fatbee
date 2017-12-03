#!/usr/bin/perl -w
#Check_Gmail_Configuration
#v1 updated on Nov 30, 2017.
$|=1;


sub check_ssmtp(){
	$result_of_checking_ssmtp=`which ssmtp`;
	chop($result_of_checking_ssmtp);
	print "Checking ssmtp...";						#Debug
	if($result_of_checking_ssmtp eq ""){
		print "Installing ssmtp.\n";
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
	}else{
		print "Done!\n";
	}
	return;
}


1;
