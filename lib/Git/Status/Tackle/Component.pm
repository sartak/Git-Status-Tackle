package Git::Status::Tackle::Component;
use strict;
use warnings;

sub name {
    my $self = shift;
    my $class = ref($self) || $self;
    $class =~ s/Git::Status::Tackle:://;
    return $class;
}

my $branches;
sub branches {
    unless ($branches) {
        $branches = [ map { s/\s+$//; $_ } split /\n/, `git branch -l --color` ];
    }
    return @$branches;
}

1;

