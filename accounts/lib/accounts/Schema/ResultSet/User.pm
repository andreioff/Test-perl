package accounts::Schema::ResultSet::User;

use Modern::Perl;
use base 'DBIx::Class::ResultSet';


sub userAndPass{

  my $r = shift->search(undef, {columns => [qw/username password/],});

  return $r;

}

sub user{

  my $r = shift->search(undef, {columns => [qw/username/],});

  return $r;

}

sub addUser{

  my $username = $_[1];
  my $password = $_[2];

  my $self = shift;

  my $result = $self->create({

    username => $username,
    password => $password,

  });

  return 1 if($result->in_storage);

  return 0;

}

1;
