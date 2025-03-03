#!/usr/bin/perl
use strict;
use warnings;

my $input = <STDIN>;
chomp $input;
$input =~ s/^\[//;
$input =~ s/\]$//;
my @arr = split /,/, $input;

sub longest_monotonic_subarray{
    my @a = @_;
    return (0, 0) if !@a;
    return (0, 1) if @a == 1;
    my $max_len = 1;
    my $max_start = 0;
    my $inc_len = 1;
    my $inc_start = 0;
    my $dec_len = 1;
    my $dec_start = 0;
    for (my $i = 1; $i < @a; $i++) {
        if ($a[$i] >= $a[$i - 1]) {
            $inc_len++;
        } else {
            $inc_len = 1;
            $inc_start = $i;
        }
        if ($a[$i] <= $a[$i - 1]) {
            $dec_len++;
        } else {
            $dec_len = 1;
            $dec_start = $i;
        }
        if ($inc_len > $max_len) {
            $max_len = $inc_len;
            $max_start = $inc_start;
        }
        if ($dec_len > $max_len) {
            $max_len = $dec_len;
            $max_start = $dec_start;
        }
    }
    return ($max_start, $max_len);
}

my ($start, $length) = longest_monotonic_subarray(@arr);
print "($start,$length)\n";
