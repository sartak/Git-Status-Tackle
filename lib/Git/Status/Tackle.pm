package Git::Status::Tackle;
use strict;
use warnings;
use Module::Pluggable (
    sub_name    => '_installed_plugins',
    search_path => ['Git::Status::Tackle'],
    except      => 'Git::Status::Tackle::Component',
    instantiate => 'new',
);

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub components {
    my $self = shift;

    return sort $self->_installed_plugins;
}

sub status {
    my $self = shift;

    my @output;

    my $block = 0;

    for my $plugin ($self->components) {
        my $results = $plugin->list;
        next unless $results && @$results;

        push @output, "\n" if $block++ > 0;

        push @output, $plugin->header;
        push @output, @$results;
    }

    return @output;
}

1;

