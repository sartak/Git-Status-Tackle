package Git::Status::Tackle::LocalBranchCommits;
use strict;
use warnings;

my $branches;
sub branches {
    unless ($branches) {
        $branches = [ map { s/\s+$//; $_ } split /\n/, `git branch -l --color` ];
    }
    return @$branches;
}

sub list {
    my @output;
    for my $colored_name (branches) {
        my $plain_name = $colored_name;
        $plain_name =~ s/^[\s*]+//;
        # strip ansi colors, ew
        # http://stackoverflow.com/questions/7394889/best-way-to-remove-ansi-color-escapes-in-unix
        $plain_name =~ s/\e\[[\d;]*[a-zA-Z]//g;

        next if $plain_name eq '(no branch)';

        my $status = `git rev-list $plain_name\@{u}..$plain_name 2>&1`;
        if ($status =~ /No upstream branch found/ || $status =~ /unknown revision/) {
            push @output, " $colored_name: No upstream\n";
            next;
        }

        my $diff;
        if (my $lines = $status =~ tr/\n/\n/) {
            $diff .= "\e[32m+$lines\e[m";
        }

        my $reverse = `git rev-list $plain_name..$plain_name\@{u} 2>&1`;
        if (my $reverse_lines = $reverse =~ tr/\n/\n/) {
            $diff .= "\e[31m-$reverse_lines\e[m";
        }

        push @output, " $colored_name: $diff\n"
            if $diff;
    }

    return {
        output => \@output,
    };
}

1;

