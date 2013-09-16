package MogileFS::Plugin::ActiveCache
sub load {
	MogileFS::register_global_hook('file_stored', sub {
			my $args = shift;
			cache_file_stored($args);
			return 1;
	});
	return 1;
}

sub unload {
	MogileFS::unregister_global_hook('file_stored');
}

sub cache_file_stored {
	my $args  = shift;
	my $dmid  = $args->{dmid};
	my $key   = $args->{key};
	my $fidid = $args->{fid};
	my $devid = $args->{devid};
	my $path  = $args->{path};
	my $checksum = $args->{checksum};

	my $memc = MogileFS::Config->memcache_client;
	if ($memc) {
		my $memcache_ttl = MogileFS::Config->server_setting_cached("memcache_ttl") || 3600;

		# Set the fid lookup key first
		my $mogfid_memkey = "mogfid:$dmid:$key";
		$memc->set($mogfid_memkey, $fidid, $memcache_ttl);

		# Now set your devid list
		my $devid_memkey = "mogdevids:$fidid";
		my $fid_devids = [$devid];
		$memc->set($devid_memkey, $fid_devids, $memcache_ttl);
	}
}
1;
