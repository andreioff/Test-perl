use v5.20.1;
use warnings;

my $line = <STDIN>;
chomp($line);

my($n, $k) = split(' ', $line);

my $result = -1;
$k--; #scadem 1 din k pentru a nu itera de la 1 ci de la 2

if($k == 0){ #verificam daca k a fost 1 inseamna ca primul divisor este 1

	$result = 1;

}

my @divs = ( $n ); #adaugam in divs perechea lui 1 care este n

my $sqn = sqrt($n); #calculam radacina patrata din n

for(my $i = 2; $i <= $sqn && $result == -1; $i++){ #iteram pana al sqrt din n

	if($n % $i == 0){ #daca gasim un divizor

		if($i * $i != $n){ #si patratul sau nu e n

			push @divs, $n/$i; #ii adaugam perechea in divs

		}

		$k--; #scadem 1 din k
		if($k == 0){ #daca k = 0 inseamna ca rezultatul este divizorul curent
			$result = $i;

		}

	}

}

if($k == 0 || $k > @divs || $n == 1){ #daca n = 1 el are un singur divizor(1) deci afisam ce se afla in result

	say $result, "\n";

}else{

	say $divs[@divs - $k], "\n"; #daca k nu e mai mare ca lungimea lui divs atunci raspunsul este divizor de pe pozitia n-k intrucat perechile au fost puse in divs de la coada la cap

}
