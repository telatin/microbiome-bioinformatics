#!/usr/bin/env perl

my %changes = (
 '_posts/2022-01-10-Nextflow-start.md'       => '_posts/2022-01-01-Nextflow-start.md',
 '_posts/2022-02-11-Nextflow-denovo.md'      => '_posts/2022-01-11-Nextflow-denovo.md',
 '_posts/2022-02-12-Nextflow-containers.md'  => '_posts/2022-01-12-Nextflow-containers.md',
 '_posts/2022-02-13-Nextflow-first-steps.md' => '_posts/2022-01-13-Nextflow-first-steps.md',
 '_posts/2022-02-14-Nextflow-DSL2.md'        => '_posts/2022-01-14-Nextflow-DSL2.md',
);

for my $file (keys %changes) {
    print "FILE $file\n";
    my $new = $changes{$file};
    if (-e $file and ! -e $new) {
        rename $file, $new; 
    }

    # find all *md files in subdirectories
    my @files = glob("_*/*.md");
    for my $f (@files) {
        # if file content contains $file, replace it with $new
        if (`grep -c $file $f` > 0) {
            print "  MATCH $f\n";
            sed($f, $file, $new);
        }
    }
}

sub sed {
    my ($file, $string, $replace) = @_;
    # Escape slashes in $string and $replace
    $string =~ s/\//\\\//g;
    $replace =~ s/\//\\\//g;
    my $cmd = "sed -i.bak 's/$string/$replace/g' $file";
    print "      CMD: ", $cmd, "\n";
    system($cmd);
    if ($?) {
        die "Failed to run command: $cmd";
    }
}