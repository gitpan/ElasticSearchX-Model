#
# This file is part of ElasticSearchX-Model
#
# This software is Copyright (c) 2013 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package ElasticSearchX::Model::Util;
{
  $ElasticSearchX::Model::Util::VERSION = '0.1.6';
}
use strict;
use warnings;
use Digest::SHA1;

sub digest {
    my $digest = join( "\0", @_ );
    $digest = Digest::SHA1::sha1_base64($digest);
    $digest =~ tr/[+\/]/-_/;
    return $digest;
}

1;

__END__

=pod

=head1 NAME

ElasticSearchX::Model::Util

=head1 VERSION

version 0.1.6

=head1 AUTHOR

Moritz Onken

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Moritz Onken.

This is free software, licensed under:

  The (three-clause) BSD License

=cut
