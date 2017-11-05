#!/usr/bin/env perl
use strict;
use warnings;
use LWP;
use LWP::UserAgent;
use JSON qw( decode_json );

my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:58.0) Gecko/20100101 Firefox/58.0");

sub openfile($) {
    my ($filename)=@_;
    my $infile;
    if ($filename=~/.bz2$/) {
        open( $infile,"-|","bzip2 -dc $filename") or die "Error opening $filename: $!\n";
    } else {open( $infile,"<",$filename) or die "Error opening $filename: $!\n";}
    return $infile;
}

sub getthings($) {
	my ($cnt) = @_;
	#my ($tocSections,$jsonData,$reflist)=('');
	my ($tocSections,$reflist,$jsonData)=('','');
	my @lines = split(/^/m,$cnt);
	for (my $i=0;$i<=$#lines;$i++) {
		if ($lines[$i] =~ /<script type="application\/ld\+json">/) {
			$jsonData = $lines[$i+1];
		}
		if ($lines[$i] =~ /<div class="ref-list">/) {
			$reflist = $lines[$i];
			chomp($reflist);
		}
		if ($lines[$i] =~ /Issue Section:/) {
			$lines[$i+1] =~ />([^<>]+)<\/a>/;
			$tocSections = $1;
			last;
		}
	}
	my $decoded_json = decode_json( $jsonData );
	return [$tocSections,$decoded_json,$reflist];
}

sub fetchURL($) {
	my ($URL)=@_;
	my $req = HTTP::Request->new(GET => $URL);
	my $res = $ua->request($req);
	my $ret=[''];
    if ($res->is_success) {
		$ret=getthings($res->content);
		return $ret;
    } else {
        print $res->status_line, "\n";
    }
	return $ret;
}


my $file = shift;
my $fh=openfile("$file");
open O,'>','giga.authors.ini' || die("[x]Cannot Open Output File.");
open O2,">gigabyte.result" || die $!;
binmode(O, ":utf8");
<$fh>;
my %hash;
my %hash2;

while (<$fh>) {
	chomp;
	my @dat = split /\t/;
	print join(" | ",@dat[0,16]),"\n";
	unless ($dat[16] =~ /\//) {
		print O "[$dat[-1]]\nTitle=\"$dat[0]\"\nType=\"Missing or Misformatted DOI !\"\n\n";
		next;
	}
	my $url = 'https://academic.oup.com/gigascience/article-lookup/doi/' . $dat[16];

	my $ret=fetchURL($url);

	if ($ret->[0] eq '') {
		print O "[$dat[-1]]\nTitle=\"$dat[0]\"\nType=\"Wrong DOI !\"\n\n";
		next;
	}
	print O "[$dat[-1]]\nTitle=\"$dat[0]\"\nType=\"$ret->[0]\"\nAuthors={\n";

	my $authors = ${$ret->[1]}{'author'};
	my $cout=0;
	for (@$authors) {
		unless($_->{'affiliation'}){
			$_->{'affiliation'}="NA";
		}	
		print O join('"',"\t",$_->{'name'},"=",$_->{'affiliation'},"\n");
		if($_->{'affiliation'}=~/BGI/){
			$cout++;	
		}
	}
	if($cout>=1){
		$hash{$ret->[0]}{"BGI"}++;
		$hash2{$ret->[0]}{"BGI"}+=$dat[17];
	}
	if($cout==0){
		$hash{$ret->[0]}{"NBGI"}++;
		$hash2{$ret->[0]}{"NBGI"}+=$dat[17];
	}
	print O "}\nRefList=\"$ret->[2]\"\n\n";
	
	#close O; exit;
}
close O;

foreach (keys %hash) {
	unless(exists($hash{$_}{"BGI"})){
		$hash{$_}{"BGI"}=0;
		$hash2{$_}{"BGI"}=0;
	}	
	unless(exists($hash{$_}{"NBGI"})){
                $hash{$_}{"NBGI"}=0;
                $hash2{$_}{"NBGI"}=0;
        }

	print O2 "$_\t".$hash{$_}{"BGI"}."\t".$hash{$_}{"NBGI"}."\t".$hash2{$_}{"BGI"}."\t".$hash2{$_}{"NBGI"}."\n";
}

 
