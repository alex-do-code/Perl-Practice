use strict;
use warnings;
use POSIX qw(floor ceil);
use Scalar::Util qw(looks_like_number);

sub calculate_productivity {
    my ($robots, $humans) = @_;

    my $max_robots = 100;
    my $max_humans = 2000;

    my $robot_fraction = $robots / $max_robots;

    return 1.0 if $robot_fraction >= 1.0;

    my $human_share = 1 - $robot_fraction;
    my $human_limit = $max_humans * $human_share;

    my $human_part = $human_limit > 0 ? sqrt($humans) / sqrt($human_limit) : 0;
    $human_part = 1 if $human_part > 1;

    my $total = $robot_fraction + $human_share * $human_part;
    return $total > 1 ? 1 : $total;
}

sub suggest_needed {
    my ($robots, $humans) = @_;

    my $max_robots = 100;
    my $max_humans = 2000;

    my $robot_fraction = $robots / $max_robots;
    my $human_share    = 1 - $robot_fraction;
    my $human_limit    = $max_humans * $human_share;

    if ($robots == 0 && $humans < $max_humans) {
        my $needed = ceil($max_humans - $humans);
        print "You need $needed more humans to reach 100% productivity.\n";
    }

    if ($humans == 0 && $robots < $max_robots) {
        my $needed = ceil($max_robots - $robots);
        print "You need $needed more robots to reach 100% productivity.\n";
    }

    my $prod = calculate_productivity($robots, $humans);
    if ($prod < 1.0) {
        my $target_humans = int(($human_share > 0) ? ($human_share * $max_humans) + 0.5 : 0);
        print "For 100% productivity with $robots robots, you need about $target_humans humans.\n";
    }
}

my $max_robots = 100;
my $max_humans = 2000;

print "Enter number of robots (0–100): ";
chomp(my $robots = <STDIN>);

unless (looks_like_number($robots) && $robots >= 0 && $robots <= $max_robots) {
    die "Error: robots must be between 0 and 100.\n";
}

my $available_human_share = 1 - ($robots / $max_robots);
my $max_allowed_humans = int($max_humans * $available_human_share + 0.5);

print "Enter number of humans (0–$max_allowed_humans): ";
chomp(my $humans = <STDIN>);

unless (looks_like_number($humans) && $humans >= 0 && $humans <= $max_allowed_humans) {
    die "Error: with $robots robots, you can use at most $max_allowed_humans humans.\n";
}

my $prod = calculate_productivity($robots, $humans);
printf "Factory productivity: %.2f%%\n", $prod * 100;

suggest_needed($robots, $humans);
