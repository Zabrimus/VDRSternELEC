#!/usr/bin/perl

use JSON;
use Data::Dumper;
use strict;

sub printAddon {
     my ($addon, $release, $name, $url) = @_;

     return if (index($name, $addon) == -1);

     return "<tr><td>$release</td><td>$addon</td><td><a href=\"$url\">$name</a></td></tr>";
}

sub tableAddon {
    my ($title, $addons) = @_;
    my $result;

    $result = "<p class=\"header\">$title</p><table><tr><th>Release</th><th>Addon</th><th>File</th></tr>\n";
    $result .= $addons . "\n";
    $result .= "</table>\n";

    return $result;
}

my $title = $ARGV[0];

my $content = do { local $/; <STDIN> };
my $text = decode_json($content);

my $addons = "";
foreach (@$text) {
    my $release = %$_{"release"};
    my @files = @$_{"value"};

    # print "Release: " . $release . "\n";
    foreach my $f (@files) {
        foreach $a (@$f) {
            my $name = %$a{"name"};
            my $url = %$a{"url"};

            # addons
            $addons .= printAddon("cefbrowser", $release, $name, $url);
            $addons .= printAddon("channellogos", $release, $name, $url);
            $addons .= printAddon("yt-dlp", $release, $name, $url);
            $addons .= printAddon("dvb-latest", $release, $name, $url);
        }
    }
}

print tableAddon($title . " Addons", $addons);
