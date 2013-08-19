#!/usr/bin/perl -w
#corelmy@meta.ua   perlstudentest@gmail.com test123123  port 5870
use warnings;
use strict;
#use Net::SMTP;
use Net::SMTP::TLS;
#use HTTP::Request
#use LWP::Simple;
print "Content-type: text/html; text/plain\n\n";
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard); 
use DBI;
print qq{
<html>
 <head>
  <meta charset="utf-8">
  <title>Send E-Mail</title>
 <style>
  #center {
	top: 50%; 
	left: 50%; 
	width: 450px; 
	height: 320px; 
	position: absolute; 
	margin-top: -160px; 
	margin-left: -225px; 
	border: none;
}
</style>
  </head>


 <body style="background-image: url(http://i.imgur.com/GXVDtev.png?1)">};
my $mytest;
$mytest=int(rand(10)+1)%2?'':'not ';
my $testCheck;
$testCheck=int(rand(10)+1)%2?'checked':'';
 print qq { <div id="center"><form name="test" method="get" action="funt.sergey.pl">
  <div align="center">
  <div style="width: 350px"><p align="left"><b>E-mail:</b><br>
   <input type="text" size="52" name="a_mail">
  </p></div>
  
  <div style="width: 350px"><p align="left"><b>Subject:</b><br>
   <input type="text" size="52" name="subj">
  </p></div>
  <div style="width: 350px;"><p align="left"><b>Messages:</b><Br>
   <textarea name="message" cols="40" rows="3"></textarea></p></div>
   <input type="checkbox" name="caheckBOT" value="checked" $testCheck >
   <input type="text" STYLE="border: none" name="chackNOT" size="15" value="I'm ${mytest}spam bot" readonly><br>
  <p><input type="submit" name="send" value="Send Message">
   <input type="reset" value="Clear">
 </div></form></div></body>
		</html>
		};
if ((param('chackNOT')!~/not/ && param('caheckBOT') eq '') || (param('chackNOT')=~/not/ && param('caheckBOT') eq 'checked'))
{			
	if (param('a_mail')=~/.+@.+\..+/i)
	{
		if ((param('a_mail') ne '') && (param('message')ne ''))
		{	
			#eval
			#{
			my $mailer = new Net::SMTP::TLS(
											'smtp.gmail.com',
											Hello	=>	'gmail.comt',
											Port	=>	587, #redundant
											User	=>	'perlstudentest',
											Password=>	'test123123',
											Debug	=>	1); die "Could not connect to server!\n" unless $mailer;
			$mailer->mail('perlstudentest@gmail.com');
			$mailer->to(param('a_mail'));
			$mailer->data;
			$mailer->datasend("To: ".param('a_mail')."\n");
			$mailer->datasend("From: Perl Student \n");
			$mailer->datasend("Content-Type: text/html \n");
			$mailer->datasend("Subject: Message from form\n");
			$mailer->datasend(param('message'));
			$mailer->dataend;
			$mailer->quit;
			#HTTP::Request->new(GET => ' ');
			print "<script>alert('Yours message send successful')</script>";
			#}
		}
	}
	elsif((param('a_mail') eq '') && (param('send') eq "Send Message"))
	{		
		print "<script>alert('You dont enter e-mail or message! Please correct it')</script>";	
		#HTTP::Request->new(GET => ' ');
	}		
	elsif(param('a_mail') ne '')
	{		
		print "<script>alert('You try to send message into wrong e-mail!  Please correct it')</script>";	
		#HTTP::Request->new(GET => ' ');
	}
	
	
}
else 
{
	print "<script>alert('You are BOT!')</script>";
	#HTTP::Request->new(GET => ' ');
}
