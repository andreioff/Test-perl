use v5.26;
use warnings;
use IO::Prompt;

my $loggedin = 0;

sub found{ #functie care returneaza o pereche de valori (username, password) (care pot fi 1 sau 0), 1 simbolizand ca username-ul sau password-ul primiti ca parametrii au fost gasite in fisier, iar 0 ca nu au fost gasite

  my $filename = "data.txt";
  open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open the file '$filename'!";

  my ($storedUsername, $storedPassword) = ("", "");
  my $pattern = '\[.*?\]\[.*?\]'; #pattern pentru a fi siguri ca citim din fisier numai perechi intre paranteze drepte [][]

  while(my $row = <$fh>){ #citim fiecare rand

    chomp($row);
    if($row =~ /($pattern)/){

      $storedUsername = substr($row, 1, index($row, "][") - 1); #extragem dintre paranteze usernameul si passwordul
      $storedPassword = substr($row, length($storedUsername) + 3, -1);

      if($storedUsername eq $_[0]){

        if($storedPassword eq $_[1]){

          return(1, 1); #daca si usernamul si passwordul au fost gasite

        }else{

          return(1, 0); #daca numai usernamul a fost gasit

        }

      }

    }

  }

  close($fh);

  return(0, 0); #daca nu s-a gasit nici usernamul nici passwordul

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
  $password = crypt($password, substr($password, 0, 2)); #criptam parola primita ca input

  my ($foundUsername, $foundPassword) = found($username, $password); #verificam daca se afla in fisier

  if($foundUsername == 1 && $foundPassword == 1){

    $loggedin = 1; #daca se afla in fisier userul e logat

  }else{

    $loggedin = 0;

  }

  undef($username);
  undef($password);

  if($loggedin == 1){ #daca userul e logat afisam un mesaj si ii afisam meniul, apoi ii procesam alegerea aleasa din meniu

    say "\nLogged in successfully!\n";
    my $choice = getAction();
    processAction($choice);

  }else{ #altfel afisam un mesaj de eroare

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
  my $input = <STDIN>; #se primeste alegerea utilizatorului si se verifica daca aceasta se afla in meniu
  chomp($input);

  if($input eq '1'){ #daca alegerea se afla in meniu este returnata

    return 1;

  }elsif($input eq '2'){

    return 2;

  }elsif($input eq '3'){

    return 3;

  }else{ #altfel se afiseaza o eroare si se apeleaza din nou functia

    say "Could not find your choice! Please try again.";
    getAction();

  }

}
sub addUser{

  print "\nEnter the username: ";

  my $username = "";
  $username = <STDIN>;
  chomp($username);

  if( !($username =~ /^[A-Za-z][\w]{1,30}$/) ){ #se verifica daca usernameul indeplineste conditiile

    undef($username);  #daca nu se afiseaza o eroare si se reia functia de la capat
    print "\nUsername must begin with a letter and can contain digits, letters, undescores and should have more than 1 character! Please try again.\n";
    addUser();

  }else{ #daca usernameul indeplineste conditiile se verifica acelasi lucru pentru parola

    my $password = "";
    $password = prompt('Enter the password: ', -e => '*');
    chomp($password);

    if( !($password =~ /^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.{6,})\w+/) ){

      undef($password);
      print "\nPassword must have at least 1 upper case, 1 lower case, 1 digit and 6 characters! Please try again\n";
      addUser();

    }else{ #daca parola indeplineste conditiile se cere repetarea ei

      my $rPassword = "";
      $rPassword = prompt('Please repeat the password: ', -e => '*');
      chomp($rPassword);

      my ($foundUsername, $foundPassword) = found($username, " "); #se cauta usernameul in fisier

      if($foundUsername == 1){ #daca e gasit se afiseaza o eroare si se cere introducerea datelor din nou

        say "\nUser already exists! Please choose another username.\n";
        addUser();

      }elsif($password ne $rPassword){ #daca usernameul nu este deja existent, se verifica daca parolele sunt aceleasi

        say "\nPasswords don't match. Please try again!\n";
        addUser();

      }else{ #daca totul este ok se adauga noul user in fisier

        undef($rPassword);
        $password = crypt($password, substr($password, 0, 2));
        open(my $fh, ">>", "data.txt") or die "Could not open the file data.txt";

        print $fh "[$username][$password]\n";

        say "\nUser added successfully!\n";

        my $choice = getAction(); #se reafiseaza meniul si se astepta o noua comanda
        processAction($choice);

      }

    }

  }

}
sub changeAccount{ #functie pentru logarea cu un alt utilizator

  print "\nYou are now changing the account! Please login.\n";
  login(); #se apeleaza din nou functia de login

}
sub logOut{ #pentru logout se afiseaza un mesaj de logout si se apeleaza functia de login

  print "\nLogged out successfully!\n\n";
  print "Welcome! :) Please login!\n\n";
  login();

}
sub processAction{ #functie pentru procesarea unei actiuni aleasa de utilizator

  if($_[0] == 1){

    addUser();

  }elsif($_[0] == 2){

    changeAccount();

  }elsif($_[0] == 3){

    logOut();

  }

}

#afisarea initiala a meniului de login
print "Welcome! :) Please login!\n\n";
login();
