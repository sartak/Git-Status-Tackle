package Git::Status::Tackle;
use strict;
use warnings;
use Module::Pluggable (
    sub_name    => '_installed_plugins',
    search_path => ['Git::Status::Tackle'],
    except      => 'Git::Status::Tackle::Component',
);

sub status {
    my $block = 0;

    for my $plugin (__PACKAGE__->_installed_plugins) {
        my $results = $plugin->list;
        next unless $results && @{ $results->{output} };

        print "\n" if $block++ > 0;

        print $plugin->name . ":\n";
        print @{ $results->{output} };
    }
}

1;

