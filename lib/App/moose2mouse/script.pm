package App::moose2mouse::script;

use strict;
use warnings;
use Carp;
use base 'CLI::Dispatch::Command';
use Furl;
use JSON::XS;
use Archive::Tar;
use Path::Extended;
use IO::String;

sub options {qw/directory|dir=s/}

sub run {
  my ($self, $dist) = @_;

  die "USAGE: $0 [dist]\n" unless $dist;

  (my $base_class = $dist) =~ s{\-}{::}g;
  (my $base_dir   = $dist) =~ s{\-}{/}g;

  (my $plugin = "App::moose2mouse::plugin::$dist") =~ s/\-//g;
  eval "require $plugin" or $plugin = '';

  my $json = $self->_get("http://api.metacpan.org/v0/release/_search?q=distribution:$dist%20AND%20status:latest");

  my $url = decode_json($json)->{hits}{hits}[0]{_source}{download_url} or die "ERROR: Download URL for $dist not found\n";

  my $root = $self->{directory} || '.';

  my %rules = $self->rules($plugin);

  my $tarball = $self->_get($url);
  my $tar = Archive::Tar->new;
  $tar->read(IO::String->new($tarball));
  for my $orgpath ($tar->list_files) {
    $self->log(debug => $orgpath) if $self->{verbose};
    (my $path = $orgpath) =~ s{^$dist[^/]+/}{};

    my $content = $tar->get_content($orgpath) or next;
    $self->filter(\$content, {
      plugin => $plugin,
      path => $path,
      base_class => $base_class,
      base_dir => $base_dir,
      dist => $dist,
    });

    my $found;
    for my $rule (keys %rules) {
      if ($path =~ /^$rule/) {
        if (ref $rules{$rule} eq 'CODE') {
          $rules{$rule}->(\$path, $base_dir);
          $found = 1;
        }
        elsif ($rules{$rule}) {
          $found = 1;
        }
      }
    }
    next unless $found;

    file($root, $path)->save($content, {mkdir => 1});
  }
}

sub _get {
  my ($self, $url) = @_;

  $self->{ua} ||= Furl->new;

  my $res = $self->{ua}->get($url);
  die "ERROR: " . $res->status_line . "\n" unless $res->is_success;

  $res->content;
}

sub filter {
  my ($self, $content_ref, $opts) = @_;

  if ($opts->{path} eq 'README') {
    $$content_ref = $self->_readme($opts);
    return;
  }

  if (my $plugin = $opts->{plugin}) {
    $plugin->filter($content_ref, $opts) if $plugin->can('filter');
  }

  unless ($opts->{base_class} eq 'Throwable') {
    $$content_ref =~ s/($opts->{base_class})/$1::Mouse/g;
    $$content_ref =~ s/($opts->{dist})/$1-Mouse/g;
  }

  $$content_ref =~ s/Moose/Mouse/g;
  $$content_ref =~ s/(Throwable|StackTrace::Auto)/$1::Mouse/g;
  $$content_ref =~ s/Class::MOP::load_class/Mouse::Util::load_class/g;
}

sub rules {
  my ($self, $plugin) = @_;

  my %rules = (
    'lib/' => sub {
      my ($path_r, $base) = @_;
      unless ($$path_r =~ s{^lib/$base/}{lib/$base/Mouse/}) {
        $$path_r =~ s{^lib/(.+)\.pm$}{lib/$1/Mouse.pm};
      }
    },
    't/' => 1,
    'Makefile.PL' => 1,
    'README' => 1,
  );

  if ($plugin && $plugin->can('rules')) {
    %rules = (%rules, $plugin->rules);
  }

  %rules;
}

sub _readme {
  my ($self, $opts) = @_;
  return <<"README";
$$opts{dist}-Mouse

This distribution is converted by moose2mouse script. Please refer to the original distribution ($$opts{dist}) for more information.
README
}

1;

__END__

=head1 NAME

App::moose2mouse::script

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 options

=head2 run

=head2 rules

=head2 filter

=head1 AUTHOR

Kenichi Ishigaki, E<lt>ishigaki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Kenichi Ishigaki.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
