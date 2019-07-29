use strict;
use warnings;
use lib '.';

use Schema;

my $connection = Schema->connect('dbi:Pg:dbname=accounts;host=localhost', 'postgres', 'postgres', {AutoCommit => 1});
$connection->deploy();
