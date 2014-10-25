#
# This file is part of ElasticSearchX-Model
#
# This software is Copyright (c) 2013 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package MyModel;
use Moose;
use Test::More;
use IO::Socket::INET;
use ElasticSearchX::Model;
use version;

index twitter => ( namespace => 'MyModel' );

sub testing {
    my $class = shift;
    unless ( IO::Socket::INET->new('127.0.0.1:9900') ) {
        plan skip_all =>
            'Requires an ElasticSearch server running on port 9900';
    }

    my $model = $class->new( es => ':9900' );
    if ( $model->es_version < 0.019002 ) {
        plan skip_all => 'Requires ElasticSearch 0.19.2';
    }

    # $model->es->trace_calls(1);
    ok( $model->deploy( delete => 1 ), 'Deploy ok' );
    return $model;
}

__PACKAGE__->meta->make_immutable;
