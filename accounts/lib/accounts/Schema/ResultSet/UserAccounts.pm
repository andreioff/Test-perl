package accounts::Schema::ResultSet::UserAccounts;

use Modern::Perl;
use base 'DBIx::Class::ResultSet';


sub getUserAccounts{

  my ($self, $username) = @_;

  my @result = $self->search({username => $username}, {columns => [qw/id accountusername accounttype/]})->all;

  return @result;

}

sub insertAccount{

  my ($self, $username, $accountusername, $accounttype) = @_;

  my $accounts = $self->search({username => $username}, {columns => [qw/accountusername accounttype/]});

  if($accounts){

    while(my $account = $accounts->next){

      if($accountusername eq $account->accountusername && $accounttype eq $account->accounttype){

        return 3;

      }

    }

  }

  my $result = $self->create({

    username => $username,
    accountusername => $accountusername,
    accounttype => $accounttype,

  });

  return 1 if($result->in_storage);

  return 2;

}

sub deleteUserAccount{

  my ($self, $id) = @_;

  $self->find({id => $id})->delete;

}

1;
