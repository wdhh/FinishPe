#!/usr/bin/perl -w
use strict;
use LWP::Simple;
print "Content-type: text/html; text/plain\n\n";
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard); 
use DBI;	


print <<END;
<html>
 <head>
  <meta charset="utf-8">
  <title>Bash quote</title>
   <style>
  #center {
	top: 50%; 
	left: 50%; 
	width: 340px; 
	height: 200px; 
	position: absolute; 
	margin-top: -100px; 
	margin-left: -170px; 
}
</style>
 </head>
 <body style="background-image: url(http://i.imgur.com/byYQ3kB.png)">
 <div id = "center">
	<form name="test" method="get" action="AddUser.pl">
   <label><p><b>Loggin:</b><br>
   <input type="text" size="52" name="logginUser" value="">
  </p></label>
  <label><p><b>Password:</b><br>
   <input type="password" size="52" name="passwordUser" value="">
  </p> </label>
   <div align="center"><input type="submit" name="addUser" style="background-color:green" value="AddUser"></div>
  </form>
  
  <form name="test" method="get" action="index.pl">
  <div align="center"><input type="submit" name="addUser" style="background-color:gray; margin: 0 auto;" value="Try to loggin"></div>
  </form>
  </div>
</body>
</html>
END
if (param('addUser') eq 'AddUser')
{	
	if (param('logginUser') ne '' && param('passwordUser') ne '')
	{	
		my $userForDB='root';
		my $passwordForDB='PerlStudent';
		my $database='BashDB';
		my $tableNameDB='UserTableDB';
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
		eval
		{
			my $sth=$dbh->prepare("CREATE TABLE If NOT EXISTS `$tableNameDB` ( `id` INT( 255 ) NOT NULL AUTO_INCREMENT , `name` VARCHAR( 25 )  CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL , `password` VARCHAR( 50 )  CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL ,`id_of_page` mediumint( 255 ) NOT NULL, `count_of_page` mediumint( 255 ) NOT NULL,  PRIMARY KEY( `id` ),UNIQUE (`name`)) ENGINE = MYISAM ;");    
			 $sth->execute();
		};
		if ($@)
		{			
			print "Can't create to table $tableNameDB\n".$@."\n";			
		}
		my $temp=param('logginUser');
		my $sth=$dbh->prepare("select count(*) from $tableNameDB where `name`=\"$temp\"");
		$sth->execute();
		my $countrow = $sth->fetchrow_array;
		if ($countrow==1)
		{
			print "<script>alert('User $temp already exist!')</script>";
		}
		else
		{
			$sth=$dbh->prepare("insert into `$tableNameDB` (name,password,id_of_page,count_of_page) values (?,?,?,?);");
			$sth->execute(param('logginUser'),param('passwordUser'),0,0);		
			$sth->finish;
			print "<script>alert('User $temp successful add!')</script>";
		}
		
	}
	else
	{
		print "<script>alert('Input loggin and password!')</script>";
	}
}
