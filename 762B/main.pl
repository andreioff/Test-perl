use v5.20.1;
use warnings;

=pod
my $filename = "date.in";
open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open the file";
=cut

my $line = <STDIN>;
chomp($line);

my($a, $b, $c) = split(' ', $line);

$line = <STDIN>;
chomp($line);

my $m = $line;

my @usb; #preturile mousurilor cu usb
my @ps; #preturile mousurilor cu ps/2
my $model;
my $price = 0;

for(my $i = 0; $i < $m; $i++){

	$line = <STDIN>;
	($price, $model) = split(' ', $line);
	if($model eq "USB"){

		push @usb, $price; #citim modelul si pretul si le adaugam in vectorul coresp

	}elsif($model eq "PS/2"){

		push @ps, $price;

	}

}

my @usbSorted = sort {$::a <=> $::b} @usb; #sortam cei doi vectori
my @psSorted = sort {$::a <=> $::b} @ps;

@usb = @usbSorted;
@ps = @psSorted;

my $ui = 0; #indice cu care vom parcurge vectorul usb
my $pi = 0; #indice cu care vom parcurge vectorul ps
my $cost = 0; #costul final
my $mice = 0; #nr total de mouseuri

while($ui < @usb && $a > 0){ #intai cumparam cele mai ieftine mouseuri pentru pc-urile care accepta doar usb

	$cost += $usb[$ui];
	#say $usb[$ui], "\n";
	$ui++;
	$mice++;
	$a--;

}

while($pi < @ps && $b > 0){ #acelasi lucru il facem pentru cele care accepta doar ps/2

	$cost += $ps[$pi];
	#say $ps[$pi], "\n";
	$pi++;
	$b--;
	$mice++;

}

while($ui < @usb && $pi < @ps && $c > 0){ #apoi alegem cele mai ieftine mouseuri dintre cele cu usb si ps/2 pentru pc-urile care accepta ambele modele de mouseuri

	if($usb[$ui] < $ps[$pi]){

		$cost += $usb[$ui];
		#say $usb[$ui], "\n";
		$c--;
		$ui++;
		$mice++;

	}else{

		$cost += $ps[$pi];
		#say $ps[$pi], "\n";
		$pi++;
		$c--;
		$mice++;

	}

}

while($ui < @usb && $c > 0){

	$cost += $usb[$ui];
	#say $usb[$ui], "\n";
	$ui++;
	$c--;
	$mice++;

}

while($pi < @ps && $c > 0){

	$cost += $ps[$pi];
	#say $ps[$pi], "\n";
	$pi++;
	$c--;
	$mice++;

}

say $mice, " ", $cost, "\n";
