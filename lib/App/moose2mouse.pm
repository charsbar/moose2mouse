package App::moose2mouse;

use strict;
use warnings;

our $VERSION = '0.01';

1;

__END__

=head1 NAME

App::moose2mouse - convert a Moose distribution into a Mouse distribution

=head1 SYNOPSIS

  $ moose2mouse Email-Sender

=head1 DESCRIPTION

Run moose2mouse command line tool, and it will get the latest distribution from the CPAN (with the help of MetaCPAN API), extracts it and modify sources, and save the modified files under the current (or specified) directory. This hopefully works if the distribution is simple enough, but don't expect too much.

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
