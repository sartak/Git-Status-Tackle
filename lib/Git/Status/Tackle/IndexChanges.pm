package Git::Status::Tackle::IndexChanges;
use strict;
use warnings;

sub list {
    return {
        output => [`git diff --color --stat --cached`],
    };
}

1;

