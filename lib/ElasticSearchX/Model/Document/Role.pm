#
# This file is part of ElasticSearchX-Model
#
# This software is Copyright (c) 2011 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package ElasticSearchX::Model::Document::Role;
{
  $ElasticSearchX::Model::Document::Role::VERSION = '0.0.4';
}
use Moose::Role;
use ElasticSearchX::Model::Util ();
use JSON::XS;
use Digest::SHA1;
use List::MoreUtils ();
use Carp;

sub _does_elasticsearchx_model_document_role {1}

has _inflated_attributes =>
    ( is => 'rw', isa => 'HashRef', lazy => 1, default => sub { {} } );

has index => (
    isa => 'ElasticSearchX::Model::Index',
    is  => 'rw'
);

has _id => ( is => 'ro' );

sub put {
    my ( $self, $qs ) = @_;
    my $id     = $self->meta->get_id_attribute;
    my $return = $self->index->model->es->index( $self->_put, %$qs );
    $id->set_value( $self, $return->{_id} ) if ($id);
    $self->meta->get_attribute('_id')->set_value( $self, $return->{_id} );
    return $self;
}

sub _put {
    my ($self) = @_;
    my $id = $self->meta->get_id_attribute->get_value($self);
    my $parent = $self->meta->get_parent_attribute;
    return (
        index => $self->index->name,
        type  => $self->meta->short_name,
        $id ? ( id => $id ) : (),
        data => $self->meta->get_data($self),
        $parent ? ( parent => $parent->get_value($self) ) : (),
    );
}

sub delete {
    my ( $self, $qs ) = @_;
    my $id     = $self->meta->get_id_attribute;
    my $return = $self->index->model->es->delete(
        index => $self->index->name,
        type  => $self->meta->short_name,
        id    => $self->_id,
        %$qs
    );
    return $self;
}

sub build_id {
    my $self = shift;
    my $id   = $self->meta->get_id_attribute;
    carp "Need an arrayref of fields for the id, not " . $id->id
        unless ( ref $id->id eq 'ARRAY' );
    my @fields = map { $self->meta->get_attribute($_) } @{ $id->id };
    return ElasticSearchX::Model::Util::digest( map { $_->deflate($self) }
            @fields );
}

1;

__END__
=pod

=head1 NAME

ElasticSearchX::Model::Document::Role

=head1 VERSION

version 0.0.4

=head1 AUTHOR

Moritz Onken

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Moritz Onken.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

