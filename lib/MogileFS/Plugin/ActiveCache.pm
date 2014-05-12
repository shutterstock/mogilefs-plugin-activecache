package MogileFS::Plugin::ActiveCache;

use strict;
use warnings;

our $VERSION = '0.01';

sub load {
	MogileFS::register_global_hook('file_stored', sub {
			my $args = shift;
			cache_file_stored($args);
			return 1;
	});
	MogileFS::register_global_hook('file_renamed', sub {
			my $args = shift;
			cache_file_stored($args);
			return 1;
	});
	return 1;
}

sub unload {
	MogileFS::unregister_global_hook('file_stored');
	MogileFS::unregister_global_hook('file_renamed');
}

sub cache_file_stored {
	my $args  = shift;
	my $dmid  = $args->{dmid};
	my $key   = $args->{key};
	my $fidid = $args->{fid};
	my $devid = $args->{devid};
	my $path  = $args->{path};
	my $checksum = $args->{checksum};

	set_mogfid($dmid, $key, $fidid);
	set_mogdevids($fidid, $devid);
}

sub set_mogfid {
	my $dmid   = shift;
	my $key    = shift;
	my $fidid  = shift;
	my $memkey = "mogfid:$dmid:$key";
	set_memcache_key($memkey, $fidid);
}

sub set_mogdevids {
	my $fidid      = shift;
	my @fid_devids = @_;
	my $memkey     = "mogdevids:$fidid";
	set_memcache_key($memkey, \@fid_devids);
}

sub set_memcache_key {
	my $memkey   = shift;
	my $memvalue = shift;
	my $ttl      = MogileFS::Config->server_setting_cached("memcache_ttl") || 3600;
	my $memc     = MogileFS::Config->memcache_client;
	if ($memc) {
		$memc->set($memkey, $memvalue, $ttl);
	}
}
1;
