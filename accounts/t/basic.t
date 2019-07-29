use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('accounts');
$t->post_ok('/login' => form => {username => 'test', password => 'Test1234'})->status_is(302);
$t->post_ok('/register' => form => {username => 'test123', password => 'Test1234', rpassword => 'Test1234'})->status_is(200);

done_testing();
