#!/usr/bin/env perl
use strict;
use LWP::Simple;
print "Content-type: text/html; text/plain\n\n";
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard); 
use DBI;	
my $cookies="cookies.dat";
my $userForDB='root';
my $passwordForDB='PerlStudent';
my $database='BashDB';
my $tableNameDB='UserTableDB';
my $dbh = DBI -> connect("dbi:mysql:", $userForDB, $passwordForDB); die "Could not connect to dbi:mysql:!\n" unless $dbh;
$dbh -> do("CREATE DATABASE If NOT EXISTS $database");die "Could not create $database!\n" unless $dbh;
$dbh = DBI -> connect("dbi:mysql:$database:", $userForDB, $passwordForDB);  die "Could not connect to $database!\n" unless $dbh;
my $dbh = DBI -> connect("dbi:mysql:$database:", $userForDB, $passwordForDB);  die "Could not connect to $database!\n" unless $dbh;
eval
{
	my $sth=$dbh->prepare("CREATE TABLE If NOT EXISTS `$tableNameDB` ( `id` INT( 255 ) NOT NULL AUTO_INCREMENT , `name` VARCHAR( 25 )  CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL , `password` VARCHAR( 50 )  CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL ,`id_of_page` mediumint( 255 ) NOT NULL, `count_of_page` mediumint( 255 ) NOT NULL, PRIMARY KEY( `id` ),UNIQUE (`name`)) ENGINE = MYISAM ;");    
	 $sth->execute();
};
if ($@)
{			
	print "Can't create table $tableNameDB\n".$@."\n";			
}
my $userloggin;
my $userpassword;

print <<END;
<html>
 <head>
  <meta charset="utf-8">
  <title>Bash quote</title>
  <style>
  #center {
	
	min-height: 10px;
height:auto !important;
width:auto !important;
/*height: 300px;  width: 300px;*/
margin: auto;
/*border: solid 1px red;*/
}
</style>
 </head>
 <body style="background-image: url(http://i.imgur.com/Bo9f1qF.png)">
 <form name="test" method="get" action="enter.pl">
END
my $localHiddenLoggin;
my $localHiddenPassword;
my $flagSession;

if(param('logginToDB') eq 'Connect'&& param('logginUser')eq ''&& param('passwordUser')eq '')
{
	print "<script>alert('Input loggin and password!')</script>";
	print '<meta http-equiv="Refresh" content="0;url=index.pl">';
}


if (param('chackBot') eq 'hidden'&& param('logginToDB') eq 'Connect')
{	
	$localHiddenLoggin=param('logginUser');
	$localHiddenPassword=param('passwordUser');	
	$flagSession=param('chackBot');
}
if (param('chackBot') eq 'cookie' && param('logginToDB') eq 'Connect')
{
	$userloggin=param('logginUser');
	$userpassword=param('passwordUser');
	open (FILE, ">", "$cookies" )or die $!;
	print FILE $userloggin." ".$userpassword."\n";
	close(FILE);
}
elsif ($flagSession eq 'hidden')
{
	if (param('logginToDB') eq 'Connect')
	{
		$userloggin=param('logginUser');
		$userpassword=param('passwordUser');
	}
	if (param('next') eq 'NEXT')
	{
		$userloggin=param('hiddenLoggin');
		$userpassword=param('hiddenPassword');
	}
}
if (param('next')eq 'NEXT')
{
	unless(-e "$cookies")
	{
		$userloggin=param('hiddenLoggin');
		$userpassword=param('hiddenPassword');
	}
}


if(-e "$cookies")
{
	open (FILE, "<", "$cookies" );
	chomp;
	my $dtr=<FILE>;

	my ($temp1,$temp2)=split(/\s/,$dtr);
	$userloggin=$temp1;
	$userpassword=$temp2;		
	close(FILE);
}





my $temp1=$userloggin;
my $temp2=$userpassword;
my $sth=$dbh->prepare("select count(*) from $tableNameDB where `name`=\"$temp1\"");
$sth->execute();
my $countrow = $sth->fetchrow_array;
if ($countrow==1)
{		
	$sth=$dbh->prepare("select count(*) from $tableNameDB where `name`=\"$temp1\" and `password`=\"$temp2\"");
	$sth->execute();
	$countrow = $sth->fetchrow_array;
	if ($countrow==1)
	{
		my $url = 'http://bash.org/?';
		$sth=$dbh->prepare("select `id_of_page`, `count_of_page` from $tableNameDB where `name`=\"$temp1\" and `password`=\"$temp2\"");
		$sth->execute();
		my @countrow = $sth->fetchrow_array;
		my $localId= ++$countrow[0];
		my $localCount=$countrow[1];
		my $resp = get($url.$localId) || die "oops!";
		
		$resp =~ s/.*\<p class="qt">//gs;
		$resp =~ s/\<\/p\>.*//gs;

		if ($resp=~/Quote #[\d]{1,} does not exist./)
		{
			while ($resp=~/Quote #[\d]{1,} does not exist./)
			{	
				$localId++;
				$resp = get($url.$localId) || die "oops!";
				$resp =~ s/.*\<p class="qt">//gs;
				$resp =~ s/\<\/p\>.*//gs;
				
			}
		}
		
		
		unless ($resp=~/Quote #[\d]{1,} does not exist./)
		{
			$localCount++;
			
			$sth=$dbh->prepare("UPDATE `UserTableDB` SET `UserTableDB`.`id_of_page` = $localId , `UserTableDB`.`count_of_page`=$localCount WHERE `UserTableDB`.`name` =\"$temp1\" and `UserTableDB`.`password`=\"$temp2\" LIMIT 1 " );
				$sth->execute();
			print <<END;
			<fieldset>
			<legend align="left"><h4 style="color:green;">Current quote # $localId  </h4></legend>
			
			<div id="center"><i>$resp</i></div>
			<H4 color="blue" align="right">You view $localCount </H4>
			</fieldset>
END
		}
		
	
	}
	else
	{
		print "<script>alert('Oops,incorrect password!')</script>";
		print '<meta http-equiv="Refresh" content="0;url=index.pl">';
	}
}
elsif (param('logginUser')ne '')
{	
	print "<script>alert('Oops, user $temp1 dont exist!')</script>";
	print '<meta http-equiv="Refresh" content="0;url=index.pl">';
}
		

print <<END;
	<INPUT TYPE="HIDDEN" NAME="hiddenLoggin" VALUE =$userloggin>
	<INPUT TYPE="HIDDEN" NAME="hiddenPassword" VALUE =$userpassword>	
	<div align="center"><p><input type="submit" style="background-color:#00BFFF; margin: 0 auto;" name="next" value="NEXT"></p></div>
	</form>
		<form name="test" method="get" action="index.pl">
		<div align="center"><input type="submit" style="background-color:#FF4500; margin: 0 auto;" name="next" value="EXIT"></div>
		</form>	
		</body>
		</html>
END
