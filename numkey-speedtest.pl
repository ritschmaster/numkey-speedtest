#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

=pod

=encoding utf8

=head1 NAME

numkey-speetest - Speed test of number keys vs numeric keypad

=head1 SYNOPSIS

numkey-speetest.pl <result-file>

=head1 DESCRIPTION

This application is intended to help determining whether you are faster typing using the number key row or the numeric key pad.

=head1 OPTIONS

None available.

=head1 RESULT-FILE

The result file will receive the collected statistics as CSV. The columns are self-explanatory.

=head1 AUTHOR

Richard Bäck <richard.baeck@mailbox.org>

=cut

use IO::Handle;
use Math::Round;
use Time::HiRes;
use Text::CSV qw( csv );

use constant ITERATIONS => 10;

sub help {
    my ($bin) = shift @_;

    return "Error: Wrong usage\n"
        . "Usage: " . $bin . " <result-file>\n"
        . "\n"
        . "For more info run: perldoc " . $bin . "\n";
}

my $keywords = {
    "C" => [
        "if",
        "else",
        "switch",
        "case",
        "default",
        "while",
        "{",
        "for",
        "return",
        "break",
        "typdef",
        "struct",
        "const",
        "int",
        "char",
        "double",
        "float",
        "int *",
        "char *",
        "double *",
        "float *",
        "static",
        "extern",
        ]
};

sub main {
    if (scalar @_ != 2) {
        my ($bin) = shift @_;
        die help($bin);
    }

    my ($bin, $output_csv) = shift @_;

    my $data = [ [ "RANDOM_STRING", "USER_ANSWER", "TIME_DIFF", "TYPE" ] ];

    my $iterations = ITERATIONS;

    my $type = "Number row";
    STDOUT->printflush("Begin with the number row.\n");
    STDOUT->printflush("Ready in ...3\n");
    sleep 1;
    STDOUT->printflush("...2\n");
    sleep 1;
    STDOUT->printflush("...1\n");
    sleep 1;

    my $iteration = 1;
    my $total_iteration = 0;
    while ($iteration) {
        my $random_number = round(rand(100));

        my $random_keyword_index = round(rand(scalar @{${$keywords}{C}} - 1));
        my $random_keyword = ${$keywords}{C}[$random_keyword_index];

        my $random_str = ":" . $random_number . $random_keyword;

        print $random_str . "\n";

        my $time_a = Time::HiRes::time();

        my $input = "";
        while ($random_str ne $input) {
            $input = <STDIN>;
            $input =~ s/\n//g;
        }

        my $time_b = Time::HiRes::time();

        my $time_diff = $time_b - $time_a;

        push @{ $data }, [ $random_str, $input, $time_diff, $type ];

        $iteration++;

        if ($type eq "Number row"
            && $iteration > $iterations) {
            $total_iteration++;

            $type = "Numeric keypad";

        } elsif ($type ne "Number row"
                 && $iteration > $iterations) {
            $total_iteration++;

            $type = "Number row";
        }

        if ($total_iteration >= 6) {
            $iteration = 0;
        } elsif ($iteration > $iterations) {
            $iteration = 1;
            if ($type eq "Numeric keypad") {
                STDOUT->printflush("Switch to use the numeric keypad.\n");
                STDOUT->printflush("Ready in ...3\n");
                sleep 1;
                STDOUT->printflush("...2\n");
                sleep 1;
                STDOUT->printflush("...1\n");
                sleep 1;
            } else {
                STDOUT->printflush("Begin with the number row.\n");
                STDOUT->printflush("Ready in ...3\n");
                sleep 1;
                STDOUT->printflush("...2\n");
                sleep 1;
                STDOUT->printflush("...1\n");
                sleep 1;
            }
        }
    }

    csv(in => $data,
        out => $output_csv,
        sep_char=> ";");
}

main $0, @ARGV;
