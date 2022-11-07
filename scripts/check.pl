#!/usr/bin/env perl
use 5.012;
use FindBin qw($RealBin);
use File::Find;
use File::Spec;
use File::Basename;
use Term::ANSIColor;
my $start_dir = File::Spec->catdir($RealBin, '../');
my @errors;
say STDERR "start: ", $start_dir;

find(\&wanted, $start_dir);

sub path_to_normalized_absolute {
	my $path = shift;
	$path = File::Spec->rel2abs($path);
	return File::Spec->canonpath($path);
}

sub wanted {
	/.md$/ && say checkmd($File::Find::name);

}


my $c = 1;
for my $e (@errors) {
	say color("red"), 'Error ' ,$c, ": ", color("reset"), $e;
	$c++;
}
sub checkmd {
	my $file = shift;
	my $c = 0;
	print STDERR color("green"), " * Checking: ", color("reset"), path_to_normalized_absolute($file);
	open (my $I, '<', "$file") || return 0;
	while (my $line = readline($I)) {
		$c++;
		checklink($line, $file, $c);
	}
}

sub checklink {
	my ($line, $source, $c) = @_;
	while ($line=~/\{\%\s+link\s+(.*?)\s+\%\}/g) {
		if (! -e File::Spec->catfile($start_dir, $1)) {
			push(@errors, "in " .
			 color("bold") . 
			 basename($source) .
			 color("reset") .
			 "\n($source)\n - MISSING: File '$1' at line $c");
		}
	}
}