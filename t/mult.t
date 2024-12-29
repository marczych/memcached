#!/usr/bin/env perl

use strict;
use Test::More tests => 9;
use FindBin qw($Bin);
use lib "$Bin/lib";
use MemcachedTest;

my $server = new_memcached();
my $sock = $server->sock;

print $sock "set num 0 0 1\r\n4\r\n";
is(scalar <$sock>, "STORED\r\n", "stored num");
mem_get_is($sock, "num", 4, "stored 4");

print $sock "mult num 3\r\n";
is(scalar <$sock>, "12\r\n", "* 3 = 12");
mem_get_is($sock, "num", 12);

print $sock "mult num 8\r\n";
is(scalar <$sock>, "96\r\n", "* 8 = 96");
mem_get_is($sock, "num", 96);

print $sock "mult bogus 5\r\n";
is(scalar <$sock>, "NOT_FOUND\r\n", "can't mult bogus key");

print $sock "set text 0 0 2\r\nhi\r\n";
is(scalar <$sock>, "STORED\r\n", "stored hi");
print $sock "mult text 2\r\n";
is(scalar <$sock>,
   "CLIENT_ERROR cannot increment, decrement, or multiply non-numeric value\r\n",
   "hi * 2 = 0");
