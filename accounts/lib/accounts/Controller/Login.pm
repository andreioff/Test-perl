package accounts::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';
use DBIx::Class;
use accounts::Schema;
use DBIx::Class::ResultClass::HashRefInflator;

my $connection = accounts::Schema->connect("dbi:Pg:dbname=accounts;host=localhost", "postgres", "postgres", {AutoCommit => 1});
my $users = $connection->resultset("User");

sub user_exists {

  my $result = $users->userAndPass();
  $result->result_class('DBIx::Class::ResultClass::HashRefInflator');

  my($username, $password) = @_;

  $password = crypt($password, substr($password, 0, 2));

  while(my $row = $result->next){

    if($username eq $row->{'username'}){

      if($password eq $row->{'password'}){

        return 1;

      }

    }

  }

  return 0;

}

sub on_user_login {

  my $self = shift;

  my $username = $self->param('username');
  my $password = $self->param('password');

  if(user_exists($username, $password)){

    $self->session(logged_in => 1);
    $self->session(username => $username);
    $self->redirect_to('restricted_area');

  }else{

    $self->render(

      inline => "<p>Wrong username/password! <a href='/login'>Go back to login page.</a></p>",
      status => 403

    );

  }

}

sub is_logged_in{

  my $self = shift;

  return 1 if $self->session('logged_in');

  $self->render(

    inline => "<h2>Forbidden</h2><p>You are not logged in! <a href='/login'>Go to login page.</a></p>"

  );

}

1;
