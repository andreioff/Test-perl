=pod
use v5.26;
use warnings;
use DBIx::Simple;

my $db = DBIx::Simple->connect("DBI:Pg:dbname=login;host=localhost", "postgres", "postgres")
  or die DBIx::Simple->error;

my $result = $db->query("SELECT * FROM account");
while(my $row = $result->array){

  print "id = ".$row->[0]."\nusername = ".$row->[1]."\npassword = ".$row->[2]."\n\n";

}


my $result = $db->query("INSERT INTO account(username, password) VALUES ('test', 'test')");

=cut

use v5.26;
use warnings;
use IO::Prompt;
use DBIx::Simple;

my $loggedin = 0;

my $db = DBIx::Simple->connect("DBI:Pg:dbname=login;host=localhost", "postgres", "postgres")
  or die DBIx::Simple->error;

sub found{

  my $result = $db->query("SELECT username, password FROM account");

  while(my $row = $result->array){

      if($row->[0] eq $_[0]){

        if($row->[1] eq $_[1]){

          return(1, 1);

        }else{

          return(1, 0);

        }

      }

  }

  return(0, 0);

}
sub login{

  print "Username: ";
  my $username = "";
  $username = <STDIN>;
  chomp($username);

  #print "Password: ";

  my $password = "";
  $password = prompt('Password: ', -e => '*');
  chomp($password);
  $password = crypt($password, substr($password, 0, 2));

  my ($foundUsername, $foundPassword) = found($username, $password);

  if($foundUsername == 1 && $foundPassword == 1){

    $loggedin = 1;

  }else{

    $loggedin = 0;

  }

  undef($username);
  undef($password);

  if($loggedin == 1){

    say "\nLogged in successfully!\n";
    my $choice = getAction();
    processAction($choice);

  }else{

    say "\nUsername or password is incorrect!\n";

  }

}
sub showMenu{

  say "Choose what do you want to do: ";
  say "Add a new user [1]";
  say "Log in with another account [2]";
  say "Log out [3]";

}
sub getAction{

  showMenu();
  my $input = <STDIN>;
  chomp($input);

  if($input eq '1'){

    return 1;

  }elsif($input eq '2'){

    return 2;

  }elsif($input eq '3'){

    return 3;

  }else{

    say "Could not find your choice! Please try again.";
    getAction();

  }

}
sub addUser{

  print "\nEnter the username: ";

  my $username = "";
  $username = <STDIN>;
  chomp($username);

  if( !($username =~ /^[A-Za-z][\w]{1,30}$/) ){

    undef($username);
    print "\nUsername must begin with a letter and can contain digits, letters, undescores and should have more than 1 character! Please try again.\n";
    addUser();

  }else{

    my $password = "";
    $password = prompt('Enter the password: ', -e => '*');
    chomp($password);

    if( !($password =~ /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.{6,})\w+/) ){

      undef($password);
      print "\nPassword must have at least 1 upper case, 1 lower case, 1 digit and 6 characters! Please try again\n";
      addUser();

    }else{

      my $rPassword = "";
      $rPassword = prompt('Please repeat the password: ', -e => '*');
      chomp($rPassword);

      my ($foundUsername, $foundPassword) = found($username, " ");

      if($foundUsername == 1){

        say "\nUser already exists! Please choose another username.\n";
        addUser();

      }elsif($password ne $rPassword){

        say "\nPasswords don't match. Please try again!\n";
        addUser();

      }else{

        undef($rPassword);
        $password = crypt($password, substr($password, 0, 2));

        $db->query("INSERT INTO account(username, password) VALUES (??)", $username, $password);

        say "\nUser added successfully!\n";

        my $choice = getAction();
        processAction($choice);

      }

    }

  }

}
sub changeAccount{

  print "\nYou are now changing the account! Please login.\n\n";
  login();

}
sub logOut{

  print "\nLogged out successfully!\n\n";
  print "Welcome! :) Please login!\n\n";
  login();

}
sub processAction{

  if($_[0] == 1){

    addUser();

  }elsif($_[0] == 2){

    changeAccount();

  }elsif($_[0] == 3){

    logOut();

  }

}

print "Welcome! :) Please login!\n\n";
login();
