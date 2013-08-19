used modul:    Net::SMTP::TLS;

+ nead some fix in /usr/share/perl5/IO/Socket/SSL.pm in line 1490
  nead replace "  m{^(!?)(?:(SSL(?:v2|v3|v23|v2/3))|(TLSv1[12]?))$}i " into " m{^(!?)(?:(SSL(?:v2|v3|v23|v2/3))|(TLSv1[12]?))}i  "
