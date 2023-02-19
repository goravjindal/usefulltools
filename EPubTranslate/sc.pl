#!/usr/bin/perl
use warnings;
use strict;
use 5.010;
use utf8;
use open ':std', ':encoding(UTF-8)';
use HTML::TreeBuilder;
use HTML::Element;
# This is the file we are going to read.

my $file = 'test.html';

open my $fhi, '<:utf8', $file or die qq{Unable to open "$file" for parsing: $!};

my $parser = HTML::TreeBuilder->new_from_file($fhi);

$parser->parse_file ();
close($fhi);

$parser->objectify_text();
recurse ($parser, 0);
$parser->deobjectify_text();

open my $fho, '>', "test2.html" or die qq{Unable to open "$file" for parsing: $!};
print $fho $parser->as_HTML;
close($fho);


sub recurse
{
    my ($childNode, $depth) = @_;
    if (ref($childNode) && ($childNode->tag() eq '~text')) {
        my $text = $childNode->attr('text');

        my $filename_in = "text";
        open my $fh_in, ">", $filename_in or die("Could not open file. $!");
        print $fh_in $text;
        close $fh_in;

        my @args = ("bash", "TRANSLATE.sh");
        system @args;

        my $trans_text;
        my $filename = "trans_text.txt";
        open(my $fh, '<:utf8', $filename) or die "cannot open file $filename";
        {
          local $/;
          $trans_text = <$fh>;
        }
        close($fh);

        my $old_value = $childNode->attr('text', $trans_text);

    }
    else {

        my @children = $childNode->content_list ();
        for my $child_node (@children) {
            recurse ($child_node, $depth + 1);
        }
    }
}
