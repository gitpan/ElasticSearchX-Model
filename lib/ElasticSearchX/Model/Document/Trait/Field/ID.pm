#
# This file is part of ElasticSearchX-Model
#
# This software is Copyright (c) 2012 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package ElasticSearchX::Model::Document::Trait::Field::ID;
{
  $ElasticSearchX::Model::Document::Trait::Field::ID::VERSION = '0.1.4';
}
use Moose::Role;
use ElasticSearchX::Model::Document::Types qw(:all);

has id => (
    is     => 'rw',
    isa    => 'ArrayRef|Bool',
);

after install_accessors => sub {
    my $self = shift;
    return unless($self->associated_class->does_role('ElasticSearchX::Model::Document::Role'));
    $self->associated_class->_add_reverse_field_alias(
        _id => $self->name );
};

package ElasticSearchX::Model::Document::Trait::Class::ID;
{
  $ElasticSearchX::Model::Document::Trait::Class::ID::VERSION = '0.1.4';
}
use Moose::Role;

1;

__END__
=pod

=head1 NAME

ElasticSearchX::Model::Document::Trait::Field::ID

=head1 VERSION

version 0.1.4

=head1 AUTHOR

Moritz Onken

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Moritz Onken.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

