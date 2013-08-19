#!/usr/bin/perl -w
#task_00
use strict;
use LWP::Simple;
print "Content-type: text/html; text/plain\n\n";
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard); 
use DBI;
print qq{
<html>
 <head>
  <meta charset="utf-8">
  <title>Comment form</title>
  <style>
  #center {
	margin:0 auto;
	left: 50%; 
	width: 350px;
	height: 250px; 
}
</style>
 </head>
 <body>};
my $mytest;
$mytest=int(rand(10)+1)%2?'':'not ';
my $testCheck;
$testCheck=int(rand(10)+1)%2?'checked':'';
 print qq {<div id="center"> <form name="test" method="get" action="funt.sergey.pl">
  <p><b>Yours Name:</b><br>
   <input type="text" size="52" name="name">
  </p>
  <p><b>Yours comment:</b><Br>
   <textarea name="comment" cols="40" rows="3"></textarea></p>
   <input type="checkbox" name="caheckBOT" value="checked" $testCheck >
   <input type="text" name="chackNOT" value="I'm ${mytest}Bot" style="border: none" readonly><br>
  <p><input type="submit" name="send" value="Add Comment">
   <input type="reset" value="Clear">
   <input type="submit" name="send" value="Clear DataBase"></p>	
 </form></div>
 <div position: absolute><hr>};
my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
my $year = 1900 + $yearOffset;
my $theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year"; $theTime; 


	
my $userForDB='root';
my $passwordForDB='PerlStudent';
my $database='DBcomment';
my $tableNameDB='comments';
my $dbh = DBI -> connect("dbi:mysql:", $userForDB, $passwordForDB,{
												RaiseError => 1,
												PrintError => 0,
										#       AutoCommit => 0
											}
						);	 die "Could not connect to dbi:mysql:!\n" unless $dbh;
$dbh -> do("CREATE DATABASE If NOT EXISTS $database");die "Could not create $database!\n" unless $dbh;
$dbh = DBI -> connect("dbi:mysql:$database:", $userForDB, $passwordForDB, {
												RaiseError => 1,
												PrintError => 0,
										#       AutoCommit => 0
											}
						);	  die "Could not connect to $database!\n" unless $dbh;

my $sth=$dbh->prepare("CREATE TABLE If NOT EXISTS `$tableNameDB` ( `id` INT( 255 ) NOT NULL AUTO_INCREMENT , `name` VARCHAR( 25 ) NOT NULL , `date` VARCHAR( 26 ) NOT NULL ,`comment` VARCHAR( 1024 ) NOT NULL, PRIMARY KEY ( `ID` )) ENGINE = MYISAM ;");    
$sth->execute();
	
	
	
	
	
	
my $nameFromGet=param('name');
my $commentFromGet=param('comment');
if (param('send')eq "Clear DataBase")
{	
	my $sth=$dbh->prepare("DROP TABLE `$tableNameDB`;");
        $sth->execute();
}


elsif (defined ($nameFromGet)&&defined($commentFromGet) && $commentFromGet ne'')
{	

	if ((param('chackNOT')!~/not/ && param('caheckBOT') eq '') || (param('chackNOT')=~/not/ && param('caheckBOT') eq 'checked'))
	{
		
		$nameFromGet="anonimus" if ($nameFromGet eq '');
		my $sth=$dbh->prepare("insert into `$tableNameDB` (name,date,comment) values (?,?,?);");
        $sth->execute($nameFromGet,$theTime,$commentFromGet);
		HTTP::Request->new(GET => ' ');
	}

}
elsif($commentFromGet eq''&& param('send') eq 'Add Comment')
{
	print "<script>alert('You dont enter comment! Please correct it')</script>";	
}
eval
{
	my $sth = $dbh->prepare("select * from `$tableNameDB`");
	$sth->execute;	
	my $ar=$sth->{NAME};
	while (my $ans = $sth->fetchrow_hashref) 
	{	
	
	
		print <<END;
<fieldset>
<legend align="right"><h4 style="color:green;">Comment #$ans->{id}</h4></legend>
<font color="gray">user:<b> $ans->{name}</b>&emsp;$ans->{date}<br></font> 
<div  style="padding: 20px; border: solid 1px black;"><i>$ans->{comment}</i></div>
</fieldset>
END

		}

	$sth->finish;	
};

print qq{</div> </body>
		</html>
		};
