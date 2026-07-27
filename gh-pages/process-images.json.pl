#!/usr/bin/perl

use JSON;
use Data::Dumper;
use strict;

sub printImage {
     my ($release, $name, $url) = @_;

     my $found = ((index($name, ".img.gz") != -1) && (index($name, ".img.gz.sha256") == -1)) && (index($name, "VDR") != -1);
     $found = $found || ((index($name, ".ova") != -1) && (index($name, ".ova.sha256") == -1)) && (index($name, "VDR") != -1);

     return if (!$found);

     return "<tr><td>$release</td><td><a href=\"$url\">$name</a></td><td><a href=\"$url.sha256\">$name.sha256</a></td></tr>";
}

sub tableImage {
    my ($title, $addons) = @_;
    my $result;

    $result = "<p class=\"header\">$title</p><table><tr><th>Image</th><th>File</th><th>sha-256</th></tr>\n";
    $result .= $addons . "\n";
    $result .= "</table>\n";

    return $result;
}

my $title = $ARGV[0];

my $content = do { local $/; <STDIN> };
my $text = decode_json($content);

my $images = "";
foreach (@$text) {
    my $release = %$_{"release"};
    my @files = @$_{"value"};

    # print "Release: " . $release . "\n";
    foreach my $f (@files) {
        foreach $a (@$f) {
            my $name = %$a{"name"};
            my $url = %$a{"url"};

            # releases
            $images .= printImage($release, $name, $url);
        }
    }
}

print tableImage($title . " Images", $images);
