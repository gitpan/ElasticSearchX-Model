
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'IO::Socket::INET' => '0',
    'Module::Build' => '0.3601',
    'Test::MockObject::Extends' => '0',
    'Test::More' => '0.88',
    'Test::Most' => '0'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Extensible and flexible model for ElasticSearch based on Moose',
  'dist_author' => [
    'Moritz Onken'
  ],
  'dist_name' => 'ElasticSearchX-Model',
  'dist_version' => '0.0.2',
  'license' => 'bsd',
  'module_name' => 'ElasticSearchX::Model',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Carp' => '0',
    'DateTime' => '0',
    'DateTime::Format::Epoch::Unix' => '0',
    'DateTime::Format::ISO8601' => '0',
    'Digest::SHA1' => '0',
    'ElasticSearch' => '0',
    'ElasticSearch::ScrolledSearch' => '0',
    'JSON' => '0',
    'JSON::XS' => '0',
    'List::MoreUtils' => '0',
    'List::Util' => '0',
    'Module::Find' => '0',
    'Moose' => '2.02',
    'Moose::Exporter' => '0',
    'Moose::Role' => '0',
    'Moose::Util::TypeConstraints' => '0',
    'MooseX::Attribute::Deflator' => '2.1.7',
    'MooseX::Attribute::LazyInflator::Meta::Role::Attribute' => '0',
    'MooseX::ChainedAccessors' => '0',
    'MooseX::Types' => '0',
    'MooseX::Types::ElasticSearch' => '0',
    'MooseX::Types::Moose' => '0',
    'MooseX::Types::Structured' => '0',
    'Scalar::Util' => '0',
    'Sub::Exporter' => '0',
    'Try::Tiny' => '0',
    'strict' => '0',
    'warnings' => '0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
