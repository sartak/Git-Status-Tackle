package Git::Status::Tackle;
# ABSTRACT: a pluggable "git status"-replacement toolbox
use strict;
use warnings;
use Module::Pluggable (
    sub_name    => '_installed_plugins',
    search_path => ['Git::Status::Tackle'],
    except      => 'Git::Status::Tackle::Component',
);

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub all_components {
    my $self = shift;

    return sort $self->_installed_plugins;
}

sub components {
    my $self = shift;

    chomp(my $components = `git config status-tackle.components`);
    return split ' ', $components if $components;
    return $self->all_components;
}

sub _instantiate_component {
    my $self = shift;
    my $name = shift;

    (my $file = "$name.pm") =~ s{::}{/}g;
    require $file;

    return $name->new;
}

sub status {
    my $self = shift;

    my @output;

    my $block = 0;

    for my $plugin_class ($self->components) {
        my $plugin = $self->_instantiate_component($plugin_class);

        my $results = eval { $plugin->list };

        if (my $e = $@) {
            warn $plugin->name . ': ' . $e;
            next;
        }

        next unless $results && @$results;

        push @output, "\n" if $block++ > 0;

        push @output, $plugin->header;
        push @output, @$results;
    }

    return @output;
}

1;

