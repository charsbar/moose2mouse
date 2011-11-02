use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME          => 'App::moose2mouse',
  AUTHOR        => 'Kenichi Ishigaki <ishigaki@cpan.org>',
  VERSION_FROM  => 'lib/App/moose2mouse.pm',
  ABSTRACT_FROM => 'lib/App/moose2mouse.pm',
  PREREQ_PM => {
    'Archive::Tar'        => 0,
    'CLI::Dispatch'       => 0,
    'Furl'                => 0,
    'IO::String'          => 0,
    'JSON::XS'            => 0,
    'Path::Extended'      => 0,
    'Test::More'          => '0.47',
    'Test::UseAllModules' => '0.10',
  },
  EXE_FILES => [qw/moose2mouse/],
  ($ExtUtils::MakeMaker::VERSION >= 6.31
    ? ( LICENSE => 'perl' )
    : ()
  ),
);
