package Git::Status::Tackle::IndexChanges;
use strict;
use warnings;
use parent 'Git::Status::Tackle::Component';

sub list {
    return {
        output => [`git diff --color --stat --cached`],
    };
}

1;

