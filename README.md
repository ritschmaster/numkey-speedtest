# numkey -speed test

Speed test of number keys vs numeric keypad

## Description

This application is intended to help determining whether you are faster typing using the number key row or the numeric key pad.

## Usage on Fedora

First install all necessary dependencies:

    sudo dnf install -y perl-Time-HiRes perl-Math-Round perl-Text-CSV
   
Afterwards you may start it using:

    ./numkey-speedtest.pl <result-file>
   
## Usage on Windows

Install Strawberry Perl and afterwards install the dependencies:

    cpan Math::Round Time::HiRes Text::CSV
    
Finally you can start it using:

    perl numkey-speedtest.pl <result-file>
    
## Documentation

You can access it via `perldoc numkey-speedtest.pl`.

## Author

Richard Bäck <richard.baeck@mailbox.org>

## License

MIT License
