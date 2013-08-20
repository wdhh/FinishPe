#!/usr/bin/env perl
use strict;
#use LWP::Simple;
print "Content-type: text/html; text/plain\n\n";
#use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard); 
use DBI;	
my $cookies="cookies.dat";
unlink $cookies;
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
	height: 240px;
	position: absolute; 
	margin-top: -120px; 
	margin-left: -170px;
}
</style>
 </head>
 <body style="background-image: url(http://i.imgur.com/9N16Y18.png)">
 <div id ="center">
   <form name="test" method="get" action="enter.pl">
   <p><b>Loggin:</b><br>
   <input type="text" size="52" name="logginUser">
  </p>
  <p><b>Password:</b><br>
   <input type="password" size="52" name="passwordUser">
  </p>
  <div style="margin-top: -20px;" 	align="center"><fieldset style="width: 170px;height: 20px;">
<legend align="left"><h4 style="color:black;"> Session  </h3></legend>
  <div style="	width: 180px;height: 40px; margin-top: -20px; margin-bottom: 0px;" align="center">
  <p><label>Hidden filds <input type="radio" name="chackBot" value="hidden" checked></label>
  <label>Cookie <input type="radio" name="chackBot" value="cookie"></label></p></fieldset></div>
  <p align="center"><input type="submit" style="background-color:green" name="logginToDB" value="Connect"></p>
  </form>
  <form name="test" method="get" action="AddUser.pl">
   <p align="center"><input type="submit" name="addUser" style="background-color:yellow" value="Add user"></p></div>
  </form></div>
</body>
</html>
END
