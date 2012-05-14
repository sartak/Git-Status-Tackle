package Git::Status::Tackle;
use strict;
use warnings;
use Module::Pluggable sub_name => '_installed_plugins', search_path => ['Git::Status::Tackle'];

sub status {
    my $printed_block = 0;
    for my $component (@order) {
        my $results = $code_for{$component}->();
        next unless $results && @{ $results->{output} };

        $results->{component} ||= $component;

        print "\n" if $printed_block;
        $printed_block++;

        print "$results->{component}:\n";
        print @{ $results->{output} };
    }
}

1;

