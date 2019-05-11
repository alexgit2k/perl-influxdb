package InfluxDB::Lite;

use 5.006;
use strict;
use warnings;
use IO::Socket::INET;

our $VERSION = '0.01';

sub new {
	my ($class, $address) = @_;

	$class = ref $class || $class;
	$address ||= '127.0.0.1:8089';

	my $socket = IO::Socket::INET->new(
		PeerAddr => $address,
		Proto    => 'udp',
		Blocking => 0
	) || die("Can't open socket: $@");

	bless({ socket => $socket }, $class);
}

sub send {
	my ($self, $data) = @_;

	my $bytes = $self->{socket}->send($data);
	warn("Send failed") unless($bytes);
	return($bytes);
}

sub close {
	my ($self) = @_;
	$self->{socket}->close();
}

# Destructor
sub DESTROY {
	my $self = shift;
	if (defined($self->{socket})) {
		$self->{socket}->close();
	}
}

1;

=head1 NAME

InfluxDB::Lite - Send data via UDP to InfluxDB

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

InfluxDB::Lite allows you to send data via UDP by using the line protocol
of InfluxDB

    use InfluxDB::Lite;

    my $influxdb = InfluxDB::Lite->new('127.0.0.1:8089);
    $influxdb->send("weather,location=us-midwest,season=summer temperature=82 1465839830100400200");

=head1 METHODS

=head2 new

    my $influxdb = InfluxDB::Lite->new('127.0.0.1:8089);

Creates and returns a new InfluxDB::Lite object. Parameter is the address-/
port-combination of the InfluxDB-server. If no parameter is given
C<127.0.0.1:8089> will be used.

=head2 send

    $influxdb->send("weather,location=us-midwest,season=summer temperature=82 1465839830100400200");

Send data to the InfluxDB-server by using the line protocol. For more details
see L<https://docs.influxdata.com/influxdb/v1.7/write_protocols>.

=head2 send

    $influxdb->close();

Close socket.

=head1 INFLUXDB

InfluxDB has to be configured with enabled udp, e.g.

    [[udp]]
    enabled = true
    bind-address = "0.0.0.0:8089"
    database = "perl"
    batch-size = 1000
    batch-timeout = "1s"

=head1 AUTHOR

Alex

=head1 REPOSITORY

L<https://github.com/alexgit2k/perl-influxdb>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc InfluxDB::Lite

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2019 by Alex.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
