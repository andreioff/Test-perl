package accounts::Login;
use Mojo::Base 'Mojolicious::Controller';

sub user_exists {

  my $self = shift;

  my $result = $self->datab->resultset("User")->userAndPass();

  my($username, $password) = @_;

  $password = crypt($password, substr($password, 0, 2));

  while( my $row = $result->fetchrow_hashref() ){

    if($row->{'username'} eq $username){

      if($row->{'password'} eq $password){

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

      inline => inline => "<p>Wrong username/password! <a href='/login'>Go back to login page.</a></p>",
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
