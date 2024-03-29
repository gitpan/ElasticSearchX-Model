use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

# List our own version used to generate this
my $v = "\nGenerated by Dist::Zilla::Plugin::ReportVersions::Tiny v1.10\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = "any version";
    $v .= "perl: $] (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Carp','any version') };
eval { $v .= pmver('Class::Load','any version') };
eval { $v .= pmver('DateTime','any version') };
eval { $v .= pmver('DateTime::Format::Epoch::Unix','any version') };
eval { $v .= pmver('DateTime::Format::ISO8601','any version') };
eval { $v .= pmver('Digest::SHA1','any version') };
eval { $v .= pmver('ElasticSearch','0.65') };
eval { $v .= pmver('File::Find','any version') };
eval { $v .= pmver('File::Spec','any version') };
eval { $v .= pmver('File::Temp','any version') };
eval { $v .= pmver('IO::Handle','any version') };
eval { $v .= pmver('IO::Socket::INET','any version') };
eval { $v .= pmver('IPC::Open3','any version') };
eval { $v .= pmver('JSON','any version') };
eval { $v .= pmver('List::MoreUtils','any version') };
eval { $v .= pmver('List::Util','any version') };
eval { $v .= pmver('Module::Build','0.3601') };
eval { $v .= pmver('Module::Find','any version') };
eval { $v .= pmver('Moose','2.02') };
eval { $v .= pmver('MooseX::Attribute::Chained','v1.0.1') };
eval { $v .= pmver('MooseX::Attribute::Deflator','v2.2.0') };
eval { $v .= pmver('MooseX::Types','any version') };
eval { $v .= pmver('MooseX::Types::Common::String','any version') };
eval { $v .= pmver('MooseX::Types::ElasticSearch','v0.0.2') };
eval { $v .= pmver('MooseX::Types::Structured','any version') };
eval { $v .= pmver('Scalar::Util','any version') };
eval { $v .= pmver('Sub::Exporter','any version') };
eval { $v .= pmver('Test::MockObject::Extends','any version') };
eval { $v .= pmver('Test::More','0.88') };
eval { $v .= pmver('Test::Most','any version') };


# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve your problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
