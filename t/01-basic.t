#!perl -T

use File::Spec;
use Test::Exception;

use Test::More tests => 7;

our $FS = "File::Spec";

BEGIN {
    use_ok( 'Template::Patch' );
}

diag( "Testing Template::Patch $Template::Patch::VERSION, Perl $], $^X" );

dies_ok { Template::Patch->new_from_file("no_such_file") }
        "can't read from metapatch file that doesn't exist";

my $tp;

lives_ok { $tp = Template::Patch->new_from_file($FS->catfile(qw/t basic1.mp/)); }
        "construct patch object with .mp file";

isa_ok $tp, "Template::Patch", "has correct type";

my $doc = <<'.';
I went to the doctor and guess what he told me.

Say AAAHHH!
.

lives_ok { $tp->extract($doc) } "patch extraction lives";

lives_ok { $tp->patch($doc) }   "patch application lives";

(my $expected = $doc) =~ s/AAA/BBB/;

is $tp->output, $expected, "patch applied correctly";

# vim: ts=4 et :
