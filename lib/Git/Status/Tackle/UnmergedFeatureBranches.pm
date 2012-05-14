package Git::Status::Tackle::UnmergedFeatureBranches;
use strict;
use warnings;
use parent 'Git::Status::Tackle::Component';

sub list {
    my $self = shift;

    chomp(my $integration = `git config awesome-status.integration`);
    if (!$integration) {
        warn "The feature branches status expects the integration branch to be configured. Please set the integration branch for this project like:\n    git config --add awesome-status.integration release-2.1.0\n";
        return;
    }

    if (`git rev-parse $integration 2>&1` =~ /unknown revision/) {
        warn "Your configured integration branch ($integration) does not exist. Please create it or change the integration branch for this project like:\n    git config --replace-all awesome-status.integration release-2.1.1\n";
        return;
    }

    my @output;
    for my $colored_name ($self->branches) {
        my $plain_name = $colored_name;
        $plain_name =~ s/^[\s*]+//;
        # strip ansi colors, ew
        # http://stackoverflow.com/questions/7394889/best-way-to-remove-ansi-color-escapes-in-unix
        $plain_name =~ s/\e\[[\d;]*[a-zA-Z]//g;

        next if $plain_name eq '(no branch)';

        my $status = `git rev-list $integration..$plain_name 2>&1`;

        my $diff;
        if (my $lines = $status =~ tr/\n/\n/) {
            $diff .= "\e[32m+$lines\e[m";
        }

        push @output, " $colored_name: $diff\n"
            if $diff;
    }

    return \@output;
}

sub header {
    my $self = shift;
    return $self->name . " (merging into " . $self->integration . "):\n";
}

1;

