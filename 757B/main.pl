use v5.20.1;
use warnings;

=pod
my $filename = "date.in";
open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open the file";
=cut

my $line = <STDIN>;
chomp($line);

my $n = $line;

$line = <STDIN>;
chomp($line);

#observam ca gcd a doua sau mai multe numere poate fi atat un numar prim sau un numar care se poate descompune in factori primi
#prin urmare, vom descompune fiecare numar in factori primi si pentru fiecare factor prim vom creste nr de aparitii al acestuia in gcd (gcd[factor prim]++)
#astfel, chiar daca gcd sirului de numere de lungime maxima este sau nu prim, in vectorul gcd se va gasi la una sau mai multe pozitii lungimea sirului respectiv
y @input = split(' ', $line);
my $x = 0; #in x retinem valoarea fiecarui numar din input
my $maxi = 0; #numarul maxim de pokemoni care au acelasi gcd
my @gcd = (); #deoarece memoria de permite, vom crea un vector in care gcd[i] reprezinta cati pokemoni au gcd i

my $d = 2; #d este cel prin care impartim in descompunerea in factori primi

for(my $i = 0; $i < $n; $i++){ #fiecare nr din input este descompus in factori primi si se verifica la fiecare factor prim gasit daca gcd[factor prim] este mai mare decat maximul de pana atunci

	$x = $input[$i];

	if($x == 1 && $gcd[1] == 0){

		$gcd[1]++;
		if($maxi == 0){

			$maxi = 1;

		}

	}elsif($x != 1){

		$d = 2;

		if($x % $d == 0){

			$gcd[$d]++;
			if($maxi < $gcd[$d]){

				$maxi = $gcd[$d];

			}

			while($x % $d == 0){

				$x /= $d;

			}

		}

		for($d = 3; $d*$d <= $x; $d += 2){

			if($x % $d == 0){

				$gcd[$d]++;

				if($maxi < $gcd[$d]){

					$maxi = $gcd[$d];

				}

				while($x % $d == 0){

					$x /= $d;

				}

			}

		}

		if($x > 1){

			$gcd[$x]++;
			if($maxi < $gcd[$x]){

				$maxi = $gcd[$x];

			}

		}

	}

}

say $maxi;
