package Git::Status::Tackle::WorkingTreeChanges;
use strict;
use warnings;

sub list {
    return {
        output => [`git diff --color --stat`],
    };
}

1;

