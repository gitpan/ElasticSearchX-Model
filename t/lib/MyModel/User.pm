#
# This file is part of ElasticSearchX-Model
#
# This software is Copyright (c) 2012 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package MyModel::User;
use Moose;
use ElasticSearchX::Model::Document;

has nickname => ( is => 'ro', isa => 'Str', id => 1 );
has name => ( is => 'ro', isa => 'Str' );

__PACKAGE__->meta->make_immutable;