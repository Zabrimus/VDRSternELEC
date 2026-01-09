#!/usr/bin/perl

use JSON;
use Data::Dumper;
use strict;

sub printRelease {
     my ($release, $name, $url) = @_;

     my $found = ((index($name, ".tar") != -1) && (index($name, ".tar.sha256") == -1)) && (index($name, "VDR") != -1);

     return if (!$found);

     return "<tr><td>$release</td><td><a href=\"$url\">$name</a></td><td><a href=\"$url.sha256\">$name.sha256</a></td></tr>";
}

sub tableRelease {
    my ($title, $addons) = @_;
    my $result;

    $result = "<p class=\"header\">$title</p><table><tr><th>Release</th><th>File</th><th>sha-256</th></tr>\n";
    $result .= $addons . "\n";
    $result .= "</table>\n";

    return $result;
}

my $title = $ARGV[0];

my $content = do { local $/; <STDIN> };
my $text = decode_json($content);

my $releases = "";
foreach (@$text) {
    my $release = %$_{"release"};
    my @files = @$_{"value"};

    # print "Release: " . $release . "\n";
    foreach my $f (@files) {
        foreach $a (@$f) {
            my $name = %$a{"name"};
            my $url = %$a{"url"};

            # releases
            $releases .= printRelease($release, $name, $url);
        }
    }
}

print tableRelease($title . " Releases", $releases);
