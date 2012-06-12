package Git::Status::Tackle::IndexChanges;
use strict;
use warnings;
use parent 'Git::Status::Tackle::Component';

sub synopsis { "Lists files with staged changes" }

sub list {
    return [`git diff --color --stat --cached`];
}

1;

