#!/usr/bin/env perl
use strict;
use warnings;

my $filename = "test4.txt";
open(my $fh, "<", $filename) or die "Cannot open $filename: $!";
my @battlefield;
while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;
    my @row = split /\s+/, $line;
    push @battlefield, \@row;
}
close($fh);

#my @battlefield = (
#    [1,1,1,0,0,0,0,0,0,0],
#    [0,0,1,0,0,0,1,0,0,0],
#    [0,0,0,0,0,1,1,0,0,1],
#    [0,1,0,0,0,0,0,0,0,1],
#    [0,0,0,0,1,0,0,0,0,0],
#    [0,0,0,0,0,0,0,1,1,1],
#    [0,0,0,0,0,0,0,1,0,0],
#    [1,0,0,0,0,0,0,1,0,0],
#    [0,0,0,1,1,1,0,0,0,0],
#    [0,0,0,0,0,0,0,0,0,0],
#);

my $total_ships = count_ships(\@battlefield);
print "Ships: $total_ships\n";

sub count_ships {
    my ($field_ref) = @_;
    my $size = scalar(@$field_ref);
    my @visited = map { [(0) x $size] } (0 .. $size - 1);
    my $ship_counter = 0;
    for my $row (0 .. $size - 1) {
        for my $col (0 .. $size - 1) {
            if ($field_ref->[$row][$col] == 1 && !$visited[$row][$col]) {
                $ship_counter++;
                mark_ship_cells($field_ref, \@visited, $row, $col, $size);
            }
        }
    }
    return $ship_counter;
}

sub mark_ship_cells {
    my ($field_ref, $visited_ref, $row, $col, $size) = @_;
    $visited_ref->[$row][$col] = 1;
    my @directions = (
        [-1,  0],
        [ 1,  0],
        [ 0, -1],
        [ 0,  1],
    );
    for my $direction (@directions) {
        my $new_row = $row + $direction->[0];
        my $new_col = $col + $direction->[1];
        next if ($new_row < 0 || $new_row >= $size || $new_col < 0 || $new_col >= $size);
        if ($field_ref->[$new_row][$new_col] == 1 && !$visited_ref->[$new_row][$new_col]) {
            mark_ship_cells($field_ref, $visited_ref, $new_row, $new_col, $size);
        }
    }
}
