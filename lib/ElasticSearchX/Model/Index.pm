#
# This file is part of ElasticSearchX-Model
#
# This software is Copyright (c) 2011 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package ElasticSearchX::Model::Index;
{
  $ElasticSearchX::Model::Index::VERSION = '0.0.1';
}
use Moose;
use Module::Find ();
use ElasticSearchX::Model::Document::Types qw(:all);

has name => ( is => 'ro' );

has path => ( is => 'ro' );

has namespace => ( is => 'ro', lazy_build => 1 );

has [qw(shards replicas)] => ( is => 'ro', default => 1 );

has model => ( is => 'ro', required => 1, handles => [qw(es bulk)] );

has traits => ( isa => 'ArrayRef', is => 'ro', default => sub { [] } );

has refresh_interval => ( is => 'ro', default => '1s' );

has dynamic => ( is => 'ro', isa => 'Bool', default => 0 );

has alias_for => ( is => 'ro', isa => 'Str' );

has types => (
    isa        => Types,
    coerce     => 1,
    traits     => ['Hash'],
    is         => 'ro',
    lazy_build => 1,
    handles    => {
        get_types     => 'values',
        get_type_list => 'keys',
        add_type      => 'set',
        remove_type   => 'delete',
        get_type      => 'get',
    }
);

sub _build_types {
    my $self      = shift;
    my $namespace = $self->namespace;
    my %stash     = Class::MOP::get_all_metaclasses;
    my @found     = (
        Module::Find::findallmod($namespace),
        grep {/^\Q$namespace\E::/} keys %stash
    );
    map { Class::MOP::load_class($_) } @found;
    @found = grep {
        $_->isa('Moose::Object')
            && $_->does('ElasticSearchX::Model::Document::Role')
    } @found;
    return { map { $_->meta->short_name => $_->meta } @found };
}

sub BUILD {
    my $self = shift;
    foreach my $trait ( @{ $self->traits } ) {
        Moose::Util::ensure_all_roles( $self, $trait );
    }
    return $self;
}

sub _build_namespace {
    ref shift->model;
}

sub type {
    my ( $self, $type ) = @_;
    my $class = $self->get_type($type)->set_class;
    Class::MOP::load_class($class);
    return $class->new(
        index => $self,
        type  => $self->get_type($type),
    );
}

sub deployment_statement {
    my $self   = shift;
    my $deploy = {};
    foreach my $type ( $self->get_types ) {
        $deploy->{mappings}->{ $type->short_name } = $type->mapping;
    }
    my $model = $self->model->meta;
    for (qw(filter analyzer tokenizer)) {
        my $method = "get_${_}_list";
        foreach my $name ( $model->$method ) {
            my $get = "get_$_";
            $deploy->{settings}->{analysis}->{$_}->{$name}
                = $model->$get($name);
        }
    }
    $deploy->{settings}->{index} = {
        number_of_shards   => $self->shards,
        number_of_replicas => $self->replicas,
        refresh_interval   => $self->refresh_interval
    };

    $deploy->{settings}->{index}->{mapper}->{dynamic} = \0
        unless ( $self->dynamic );

    return $deploy;
}

sub refresh {
    my $self = shift;
    $self->es->refresh_index( index => $self->name );
}

sub delete {
    my $self = shift;
    $self->es->delete_index( index => $self->name );
}

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );



=pod

=head1 NAME

ElasticSearchX::Model::Index

=head1 VERSION

version 0.0.1

=head1 ATTRIBUTES

=head2 name

The name of the index.

=head2 alias_for

If given, this name is used as the index name in ElasticSearch. The
L</name> is added as alias to L</alias_for>.

=head2 dynamic

By default, indices are not dynamic. That means that fields that
are unknown to the ElasticSearch mapping will not be indexed and
no dynamic mapping will be auto generated. Since the mapping is
generated by this module, there is no need to have the dynamic
mapping enabled. If you want to enable it anyway, set this attribute
to C<1> value.

=head2 namespace

Types are loaded from this namespace if they are not explicitly 
defined using L</types>. The namespace defaults to the package
name of the model.

=head2 refresh_interval

This string defines the interval in which the index is refreshed
and new documents are made available to the search. It defaults
to C<1s> and can be set to C<-1> to disable refreshing completely.

Indices can be refreshed manually by calling L</refresh>.

=head2 types

A HashRef where the key is an indentifier for the value,
the L<ElasticSearchX::Model::Document> meta object. This attribute
is automatically built if it isn't provided. It uses L</namespace>
to look for L<ElasticSearchX::Model::Document> classes. The name is
derived from the class name by lowercasing the last name segment
(i.e. C<MyModel::Tweet> becomes C<tweet>).

=head2 traits

An ArrayRef of traits which are applied to the index object.
This is useful if you want to alter the behaviour of methods
like L</deploy>.

=head2 model

This attribute is set automatically by the model class when
you add an index. It can be used to access the model through
the index object.

=head2 shards

=head2 replicas

Sets the number of shards and replicas. Both default to C<1>.

=head2 refresh_interval

Sets the refresh interval. Defaults to C<1s>.

=head2 es

The L<ElasticSearch> object.

=head2 bulk

Returns an instance of L<ElasticSearchX::Model::Bulk>.

=head1 METHODS

=head2 refresh

Refresh index manually.

=head2 delete

Delete an index from ElasticSearch.

=head1 AUTHOR

Moritz Onken

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Moritz Onken.

This is free software, licensed under:

  The (three-clause) BSD License

=cut


__END__

