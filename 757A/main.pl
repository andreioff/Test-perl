use v5.20.1;
use warnings;

=pod
my $filename = "date.in";
open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open the file";
=cut

my $line = <STDIN>;
chomp($line);

my @input = split('', $line);

my %letters = (	#hash de aparitii a literelor din Bulbasaur

	'B' => 0,
	'u' => 0,
	'l' => 0,
	'b' => 0,
	'a' => 0,
	's' => 0,
	'r' => 0,

);

for(my $i = 0; $i < @input; $i++){

	if( index("Bulbasr", $input[$i]) != -1 ){ #daca gasim o litera din cuvantul cerut ii crestem nr de aparitii

		$letters{$input[$i]}++;

	}

}

my $mini = 100002; #tot ce a ramas de facut este sa calculam minimul aparitiilor literelor care ne intereseaza pentru a determina care este numarul maxim de cuvinte pe care le putem forma

while(my ($key, $value) = each(%letters)){


	if( ($key eq 'a' || $key eq 'u') && int($value/2) < $mini ){ #observam ca literele a si u se repete de 2 ori, deci nr lor de aparitii este impartit la 2

		$mini = int($value/2);

	}elsif($key ne 'a' && $key ne 'u' && $value < $mini){

		$mini = $value;

	}


}

say $mini;
