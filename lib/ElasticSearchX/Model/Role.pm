#
# This file is part of ElasticSearchX-Model
#
# This software is Copyright (c) 2012 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package ElasticSearchX::Model::Role;
{
  $ElasticSearchX::Model::Role::VERSION = '0.0.5';
}
use Moose::Role;
use ElasticSearch;
use ElasticSearchX::Model::Index;
use Try::Tiny;
use ElasticSearchX::Model::Document::Types qw(ES);

has es => ( is => 'rw', lazy_build => 1, coerce => 1, isa => ES );

sub _build_es {
    ElasticSearch->new(
        servers   => '127.0.0.1:9200',
        transport => 'http',
        timeout   => 30,
    );
}

sub deploy {
    my ( $self, %params ) = @_;
    my $t = $self->es->transport;
    foreach my $name ( $self->meta->get_index_list ) {
        my $index = $self->index($name);
        next if ( $index->alias_for && $name eq $index->alias_for );
        $name = $index->alias_for if ( $index->alias_for );
        try { $t->request( { method => 'DELETE', cmd => "/$name", } ); }
        if ( $params{delete} );
        my $dep     = $index->deployment_statement;
        my $mapping = delete $dep->{mappings};
        try {
            $t->request(
                {   method => 'PUT',
                    cmd    => "/$name",
                    data   => $dep,
                }
            );
        };
        sleep(1);
        while ( my ( $k, $v ) = each %$mapping ) {
            $t->request(
                {   method => 'PUT',
                    cmd    => "/$name/$k/_mapping",
                    data   => { $k => $v },
                }
            );
        }
        if ( my $alias = $index->alias_for ) {
            my $aliases
                = $self->es->get_aliases( index => $index->name )->{aliases}
                ->{ $index->name };
            my $actions = [
                (   map {
                        { remove => { index => $_, alias => $index->name }
                        }
                        } @$aliases
                ),
                { add => { index => $alias, alias => $index->name } }
            ];
            $self->es->aliases(
                actions => $actions
            );
        }
    }
    return 1;
}

sub bulk {
    my $self = shift;
    return ElasticSearchX::Model::Bulk->new( es => $self->es, @_ );
}

1;

__END__
=pod

=head1 NAME

ElasticSearchX::Model::Role

=head1 VERSION

version 0.0.5

=head1 AUTHOR

Moritz Onken

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Moritz Onken.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

