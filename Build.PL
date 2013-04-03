
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "IO::Socket::INET" => 0,
    "Module::Build" => "0.3601",
    "MooseX::Types::Common::String" => 0,
    "Test::MockObject::Extends" => 0,
    "Test::More" => "0.88",
    "Test::Most" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Extensible and flexible model for ElasticSearch based on Moose",
  "dist_author" => [
    "Moritz Onken"
  ],
  "dist_name" => "ElasticSearchX-Model",
  "dist_version" => "0.1.5",
  "license" => "bsd",
  "module_name" => "ElasticSearchX::Model",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "DateTime" => 0,
    "DateTime::Format::Epoch::Unix" => 0,
    "DateTime::Format::ISO8601" => 0,
    "Digest::SHA1" => 0,
    "ElasticSearch" => "0.61",
    "JSON" => 0,
    "List::MoreUtils" => 0,
    "List::Util" => 0,
    "Module::Find" => 0,
    "Moose" => "2.02",
    "MooseX::Attribute::Chained" => "v1.0.1",
    "MooseX::Attribute::Deflator" => "v2.2.0",
    "MooseX::Types" => 0,
    "MooseX::Types::ElasticSearch" => "v0.0.2",
    "MooseX::Types::Structured" => 0,
    "Scalar::Util" => 0,
    "Sub::Exporter" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
