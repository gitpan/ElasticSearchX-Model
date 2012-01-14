#
# This file is part of ElasticSearchX-Model
#
# This software is Copyright (c) 2012 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package ElasticSearchX::Model::Document::Trait::Attribute;
{
  $ElasticSearchX::Model::Document::Trait::Attribute::VERSION = '0.1.0';
}

# ABSTRACT: Trait that extends the meta class of a document class
use Moose::Role;
use ElasticSearchX::Model::Document::Mapping;

with 'MooseX::Attribute::LazyInflator::Meta::Role::Attribute';

use ElasticSearchX::Model::Document::Types;
use MooseX::Types::Moose qw(ArrayRef);

has id => ( is => 'ro', isa => 'Bool|ArrayRef', default => 0 );
has index   => ( is => 'ro' );
has boost   => ( is => 'ro', isa => 'Num' );
has store   => ( is => 'ro', isa => 'Str', default => 'yes' );
has type    => ( is => 'ro', isa => 'Str', default => 'string' );
has parent  => ( is => 'ro', isa => 'Bool', default => 0 );
has dynamic => ( is => 'ro', isa => 'Bool', default => 0 );
has analyzer =>
    ( is => 'ro', isa => ArrayRef, coerce => 1, default => sub { [] } );
has not_analyzed   => ( is => 'ro', isa => 'Bool', default => 1 );
has term_vector    => ( is => 'ro', isa => 'Str' );
has include_in_all => ( is => 'ro', isa => 'Bool', default => 1 );
has source_only    => ( is => 'ro', isa => 'Bool', default => 0 );
has include_in_root   => ( is => 'ro', isa => 'Bool' );
has include_in_parent => ( is => 'ro', isa => 'Bool' );

sub build_property {
    my $self = shift;
    return {
        ElasticSearchX::Model::Document::Mapping::maptc(
            $self, $self->type_constraint
        )
    };
}

before _process_options => sub {
    my ( $self, $name, $options ) = @_;
    %$options = ( builder => 'build_id', lazy => 1, %$options )
        if ( $options->{id} && ref $options->{id} eq 'ARRAY' );
    #$options->{required} = 1 if($options->{id});
    $options->{traits} ||= [];
    push(
        @{ $options->{traits} },
        'MooseX::Attribute::LazyInflator::Meta::Role::Attribute'
    ) if ( $options->{property} || !exists $options->{property} );
};

after _process_options => sub {
    my ( $class, $name, $options ) = @_;
    if (   $options->{required}
        && !$options->{builder}
        && !defined $options->{default} )
    {
        $options->{lazy}     = 1;
        $options->{required} = 1;
        $options->{default}  = sub {
            confess "Attribute $name is required";
        };
    }
};

1;



=pod

=head1 NAME

ElasticSearchX::Model::Document::Trait::Attribute - Trait that extends the meta class of a document class

=head1 VERSION

version 0.1.0

=head1 ATTRIBUTES

=head2 property

This defaults to C<1> and marks the attribute as ElasticSearch
property and thus will be added to the mapping. If you set this
to C<0> the attribute will act as a traditional Moose attribute.

=head2 id

Usually there is one property which also acts as id for the whole
document. If there is no attribute with the C<id> option defined
ElasticSearch will assign a random id. This option can either
be set to a true value or an arrayref. The former will make the
value of the attribute the id. The latter will generate a SHA1
digest of the concatenated values of the attributes listed in 
the arrayref.

Only one attribute with the C<id> option set can be present in 
a document.

=head2 type

Most of the time L<ElasticSearchX::Model::Document::Mapping> will take 
care of this option and set the correct value based on the
type constriant. In case it doesn't know what to do, this 
value will be used as the type for the attribute. Defaults
to C<string>.

=head2 parent

The value of this property will be used as C<parent> id.
Since the parent id is stored in the C<_parent> field, it
is adviced to set L</source_only> to C<1> to prevent the
field to be stored redundantly.

=head2 source_only

A C<source_only> attribute is not added to the type mapping,
but it's value is included in the C<_source> of a document.
This is helpful if you don't want to index the value of this
attribute in ElasticSearch, but still want to be able to access
its value.

=head1 PASS THROUGH ATTRIBUTES

The following attributes are passed through - as is - to the
type mapping.

=head2 store

Defaults to C<yes>.

=head2 boost

=head2 index

=head2 dynamic

By default, properties are not dynamic. That means that fields that
are unknown to the ElasticSearch mapping will not be indexed and
no dynamic mapping will be auto generated. Since the mapping is
generated by this module, there is no need to have the dynamic
mapping enabled. If you want to enable it anyway, set this attribute
to C<1> value.

This will change the behaviour of C<HashRef> attributes.
Instead of deflating to a JSON string they will be stored as object
in ElasticSearch.

=head2 analyzer

If this attribute or L</index> is set to C<analyzed>, the field is stored
both analyzed and not analyzed. The not analyzed field can be accessed in
queries by the field name. The analyzed field will have a C<.analyzed>
postfix if there is only one analyzer. If there are more than one analyzer,
the C<.analyzed> postfix refers to the first analyzer. For all other
analyzers, its name is prefixed. This is done by using the C<multi_field>
feature of ElasticSearch.

=head2 include_in_all

=head2 include_in_parent

=head2 include_in_root

=head2 term_vector

=head2 not_analyzed

By default, a field is not analyzed. That means the raw value is stored
in the field. To add analyzed fields, either set L</index> to C<analyzed>
or add an L</analyzer>. Set this to C<0> if you don't want to store
the not analyzed version of this field along with the analyzed.

=head1 METHODS

=head2 build_id

=head2 build_property

This method is called by L<ElasticSearchX::Model::Document::Trait::Class/mapping>
and returns the mapping for this property as a HashRef.

=head1 AUTHOR

Moritz Onken

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Moritz Onken.

This is free software, licensed under:

  The (three-clause) BSD License

=cut


__END__

