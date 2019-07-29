package accounts::Controller::Register;
use Mojo::Base 'Mojolicious::Controller';
use DBIx::Class;
use accounts::Schema;
use DBIx::Class::ResultClass::HashRefInflator;

my $connection = accounts::Schema->connect("dbi:Pg:dbname=accounts;host=localhost", "postgres", "postgres", {AutoCommit => 1});
my $users = $connection->resultset("User");

sub userAlreadyExists{

  my $username = $_[0];

  my $result = $users->user();
  $result->result_class('DBIx::Class::ResultClass::HashRefInflator');

  while(my $row = $result->next){

    if($username eq $row->{'username'}){

      return 1;

    }

  }

  return 0;
}

sub createUser{

  my $self = shift;

  my $username = $self->param('username');
  my $password = $self->param('password');
  my $rPassword = $self->param('rpassword');

  if(userAlreadyExists($username) == 1){

    $self->render(

      inline => "<p>Username already exists! Please try again with another username. <a href='/register'>Go back to register page.</a></p>"

    );

  }elsif( !($username =~ /^[A-Za-z][\w]{1,30}$/) ){

    $self->render(

      inline => "<p>Username must begin with a letter and can contain digits, letters, undescores and should have more than 1 character! Please try again! <a href='/register'>Go back to register page.</a></p>"

    );

  }elsif( !($password =~ /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.{6,})\w+/) ){

    $self->render(

      inline => "<p>Password must have at least 1 upper case, 1 lower case, 1 digit and 6 characters! Please try again! <a href='/register'>Go back to register page.</a></p>"

    );

  }elsif( $password ne $rPassword ){

    $self->render(

      inline => "<p>Passwords don't match! Please try again! <a href='/register'>Go back to register page.</a></p>"

    );

  }else{

    undef($rPassword);

    $password =  crypt($password, substr($password, 0, 2));

    my $succes = $users->addUser($username, $password);

    if($succes){

      $self->render(

        inline => "<p>User added successfully! <a href='/login'>Go to login page.</a></p>"

      );

    }else{

      $self->render(

        inline => "<p>For some reason we could not add the new user. Please try again later! <a href='/register'>Go back to register page.</a></p>"

      );

    }

  }

}

1;
