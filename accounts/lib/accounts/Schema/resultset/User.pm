package accounts::Schema::ResultSet::User;

use Modern::Perl;
use base 'DBIx::Class::ResultSet';


sub userAndPass{

  return shift->search(undef, {columns => [qw/username password/],});

}
