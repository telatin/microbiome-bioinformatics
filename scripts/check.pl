#!/usr/bin/env perl
use 5.012;
use FindBin qw($RealBin);
use File::Find;
use File::Spec;
my $start_dir = File::Spec->catdir($RealBin, '../');
my @errors;
say STDERR "start: ", $start_dir;

find(\&wanted, $start_dir);
 

sub wanted {
	/.md$/ && say checkmd($File::Find::name);

}


my $c = 1;
for my $e (@errors) {
	say 'Error' ,$c, ": ", $e;
	$c++;
}
sub checkmd {
	my $file = shift;
	say STDERR " * Checking $file";
	open (my $I, '<', "$file") || return 0;
	while (my $line = readline($I)) {
		checklink($line, $file);
	}
}

sub checklink {
	my ($line, $source) = @_;
	while ($line=~/\{\% link\s+(.*?)\s+\%\}/g) {
		if (! -e File::Spec->catfile($start_dir, $1)) {
			push(@errors, "MISSING: File '$1' from '$source'");
		}
	}
}