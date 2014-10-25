use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.037

use Test::More  tests => 19 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'ElasticSearchX/Model.pm',
    'ElasticSearchX/Model/Bulk.pm',
    'ElasticSearchX/Model/Document.pm',
    'ElasticSearchX/Model/Document/Mapping.pm',
    'ElasticSearchX/Model/Document/Role.pm',
    'ElasticSearchX/Model/Document/Set.pm',
    'ElasticSearchX/Model/Document/Trait/Attribute.pm',
    'ElasticSearchX/Model/Document/Trait/Class.pm',
    'ElasticSearchX/Model/Document/Trait/Field/ID.pm',
    'ElasticSearchX/Model/Document/Trait/Field/TTL.pm',
    'ElasticSearchX/Model/Document/Trait/Field/Timestamp.pm',
    'ElasticSearchX/Model/Document/Trait/Field/Version.pm',
    'ElasticSearchX/Model/Document/Types.pm',
    'ElasticSearchX/Model/Index.pm',
    'ElasticSearchX/Model/Role.pm',
    'ElasticSearchX/Model/Scroll.pm',
    'ElasticSearchX/Model/Trait/Class.pm',
    'ElasticSearchX/Model/Tutorial.pm',
    'ElasticSearchX/Model/Util.pm'
);



# no fake home requested

my $inc_switch = -d 'blib' ? '-Mblib' : '-Ilib';

use File::Spec;
use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


