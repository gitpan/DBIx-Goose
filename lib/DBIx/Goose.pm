package DBIx::Goose;

use 5.010;
use DBI;

use base qw/
    DBIx::Goose::Schema
    DBIx::Goose::ResultSet
    DBIx::Goose::Result
/;

$DBIx::Goose::VERSION = '0.03';

=head1 NAME

DBIx::Goose - An Object Oriented version of DBIx::Inline

=head1 DESCRIPTION

DBIx::Goose is very similar to L<DBIx::Inline> except it uses a class system, much like 
DBIx::Class. I would recommend something like this for large projects, like a Catalyst application, and 
DBIx::Inline if you don't need the whole Schema/Model stuff and just want some SQL in your script.
You can create accessors/methods in the Result/ResultSet class, or on the fly like so...

    my $rs = $schema->resultset('Users')->all;
    $rs->method(active_only => sub {
        return shift->search([], { status => 'active' });
    });

    $rs->method(limit_of => sub {
        my ($self, $limit) = @_;
        return $self->search([], {}, { limit => $limit });
    });

    $rs = $rs->active_only->limit_of(5);

    while(my $row = $rs->next) {
        print $row->name;
    }

Inline methods are pretty useless in DBIx::Goose because it's just easier to have them in your ResultSet class.. but 
it helps when you need to dynamically create them.
I suppose you're wondering about the 'Goose'? Well, I couldn't find a fitting name, OK?

=head1 SYNOPSIS

    # MySchema.pm
    package MySchema;
    use base 'DBIx::Goose';
   
    __PACKAGE__->load_namespaces;
 
    1;

    # MySchema/ResultSet/MyTable.pm
    package MySchema::ResultSet::MyTable;

    use base 'DBIx::Goose';

    sub table { 'my_real_table_name'; } # Important!

    sub rows { return shift->count; }
    
    1;

    # MySchema/Result/MyTable.pm
    package MySchema::Result::MyTable;
    
    use base 'DBIx::Goose';
    
    # create a simple accessor
    sub name {
        my $self = shift;
        return $self->{name};
    }

    sub id { return shift->{id}; }

    1;

    # test.pl
    use MySchema;

    my $schema = MySchema->connect(
        dbi => 'SQLite:test.db',
    );

    my $rs = $schema->resultset('MyTable');
    my $rset = $rs->search([], { status => 'active' });
    
    # "rows" is the resultset method we created
    print "Rows: " . $rset->rows . "\n";
    while(my $row = $rset->next) {
        print $row->id;
    }

    my $rset2 = $rs->find([], { id => 4 });
    print $rset2->name . "\n";

    # slurp all results into a resultset
    my $all = $rs->all;

    # get the first and last results.. plus we want the name using our result method
    my $last_name = $rs->all->last->name;
    my $first_name = $rs->all->first->name;

    # update rows
    my $s = $rs->search([], { status => 'disabled' });
    $s->update({status => 'active'});

=cut

=head2 connect

Creates the Schema instance using the hash specified. Currently only dbi is mandatory, 
which tells DBI which engine to use (SQLite, Pg, etc).
If you're using SQLite there is no need to set user or pass.

    my $dbh = DBIx::Goose->connect(
        dbi => 'SQLite:/var/db/test.db',
    );

    my $dbh = DBIx::Goose->connect(
        dbi  => 'Pg:host=myhost;dbname=dbname',
        user => 'username',
        pass => 'password',
    );

=cut

sub connect {
    my ($class, %args) = @_;

    my $dbh = DBI->connect(
        'dbi:' . $args{dbi},
        $args{user}||undef,
        $args{pass}||undef,
        { PrintError => 0 }
    ) or do {
        warn 'Could not connect to database: ' . $DBI::errstr;
        return 0;
    };

    my $dbhx = { dbh => $dbh, schema => $class };
    bless $dbhx, 'DBIx::Goose::Schema';
}

=head1 BUGS

Please e-mail bradh@cpan.org

=head1 AUTHOR

Brad Haywood <bradh@cpan.org>

=head1 COPYRIGHT & LICENSE

Copyright 2011 the above author(s).

This sofware is free software, and is licensed under the same terms as perl itself.

=cut

1;
