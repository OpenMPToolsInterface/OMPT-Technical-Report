#!/bin/perl

#Usage: 
# perl reformat-spec.pl ompt-tr.tex > ompt-tr-spec.tex

sub escapeUnderscore {
  my $string = shift;
#  print $string;
  $string =~ s/_/\\_/g;
  return $string;
}


sub trueaddplc{
  my $string = shift;
  $string =~ s#([A-Za-z_][A-Za-z0-9_]*)(\s*,|\s*(?:/\*.*?\*/)?\s*\))#\\plc{${1}}${2}#g;
  return $string;
}

sub trueaddplcblock{
  my $string = shift;
  $string =~ s#([A-Za-z_][A-Za-z0-9_]*)(\s*;)#\\plc{${1}}${2}#g;
  return $string;
}


sub addplc{
  my $string = shift;
  $string =~ s/(\((?>[^()]+|(?1))*\))/"".trueaddplc("${1}").""/esg;
  return $string;
}

sub addplcstruct{
  my $string = shift;
  $string =~ s/(\{(?>[^{}]+|(?1))*\})/"".trueaddplcblock("${1}").""/esg;
  return $string;
}


$string="";
{
  local $/ = undef;
  open FILE, "$ARGV[0]" or die "Couldn't open file $ARGV[0]: $!";
  binmode FILE;
  $string = <FILE>;
  close FILE;
}

$string =~ s/(\\verb(.))((?:(?!\2).)*)\2/"\\code{". escapeUnderscore("${3}") ."}"/esg;
$string =~ s/(?:\\begin\{quote\}\s*)?\\begin\{verbatim\}\s*((?:(?!\\end).)*)\\end\{verbatim\}(?:\s*\\end\{quote\})?/"\\begin{boxedcode}\n". escapeUnderscore(addplc(addplcstruct("${1}"))) ."\\end{boxedcode}"/esg;

print $string