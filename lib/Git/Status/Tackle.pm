package Git::Status::Tackle;
use strict;
use warnings;
use Module::Pluggable (
    sub_name    => '_installed_plugins',
    search_path => ['Git::Status::Tackle'],
    except      => 'Git::Status::Tackle::Component',
    instantiate => 'new',
);

sub components {
    return sort __PACKAGE__->_installed_plugins;
}

sub status {
    my $self = shift;

    my $block = 0;

    for my $plugin ($self->components) {
        my $results = $plugin->list;
        next unless $results && @{ $results->{output} };

        print "\n" if $block++ > 0;

        print $plugin->name . ":\n";
        print @{ $results->{output} };
    }
}

1;

