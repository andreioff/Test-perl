package accounts::Controller::UserOverview;
use Mojo::Base 'Mojolicious::Controller';
use DBIx::Class;
use accounts::Schema;

my $connection = accounts::Schema->connect("dbi:Pg:dbname=accounts;host=localhost", "postgres", "postgres", {AutoCommit => 1});
my $userAccounts = $connection->resultset("UserAccounts");

sub showAccounts{

  my $self = shift;

  my $username = $self->session('username');

  my @accounts = $userAccounts->getUserAccounts($username);

  $self->stash(accounts => \@accounts);

  return $self->render(template => 'user/overview');

}

sub addAccount{

  my $self = shift;
  my $username = $self->session('username');
  my $accUsername = $self->param('accountUsername');
  my $accType = $self->param('accountType');

  my $succes = $userAccounts->insertAccount($username, $accUsername, $accType);

  $self->stash(succes => $succes);

  my @accounts = $userAccounts->getUserAccounts($username);

  $self->stash(accounts => \@accounts);

  return $self->render(template => 'user/overview');

}

sub deleteAccount{

  my $self = shift;

  my $id = $self->stash('id');

  $userAccounts->deleteUserAccount($id);

  $self->redirect_to('user');
}
