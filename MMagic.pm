package File::Find::Rule::MMagic;
use strict;
use vars qw/$VERSION @EXPORT/;
use File::Find::Rule;
use File::MMagic;
use Text::Glob qw(glob_to_regex);
use base qw( File::Find::Rule Exporter );
$VERSION = '0.01';
@EXPORT = @File::Find::Rule::EXPORT; # yes, re-export

sub File::Find::Rule::magic {
    my $self = shift()->_force_object;
    my @patterns = map { ref $_ ? $_ : glob_to_regex $_ } @_;
    my $mm = new File::MMagic;
    $self->exec( sub {
                     my $type = $mm->checktype_filename($_);
                     for (@patterns) { return 1 if $type =~ m/$_/ }
                     return;
                 } );
}

1;
