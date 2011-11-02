package App::moose2mouse::plugin::EmailSender;

use strict;
use warnings;

sub rules {(
  't/lib/Test/Email/Sender/' => sub {
    my ($path_r, $base_dir) = @_;
    $$path_r =~ s{^t/lib/Test/Email/Sender/}{t/lib/Test/Email/Sender/Mouse/};
  },
  'util/' => 1,
)}

1;

__END__

=head1 NAME

App::moose2mouse::plugin::EmailSender

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 rules

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
