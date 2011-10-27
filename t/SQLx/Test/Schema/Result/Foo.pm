package SQLx::Test::Schema::Result::Foo;

use base 'DBIx::Goose';

sub id { return shift->{id}; }
sub name { return shift->{name}; }

1;
