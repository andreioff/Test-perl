use strict;
use warnings;

use lib '.';

use accounts::Schema;

my $connection = accounts::Schema->connect('dbi:Pg:dbname=accounts;host=localhost', 'postgres', 'postgres', {AutoCommit => 1});
$connection->deploy();
