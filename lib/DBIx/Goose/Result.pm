package DBIx::Goose::Result;

=head1 NAME

DBIx::Goose::Result - Class for DBIx::Goose results

=head1 DESCRIPTION

A single row is known as a Result. This module handles methods for them.

=cut 

use SQL::Abstract;
our $sql = SQL::Abstract->new;

use vars qw/$sql/;

our $VERSION = '0.01';

1;
