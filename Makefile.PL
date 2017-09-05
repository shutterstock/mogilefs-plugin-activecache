#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME          => 'MogileFS::Plugin::ActiveCache',
	AUTHOR        => 'Allan Feid <afeid@shutterstock.com>',
	VERSION_FROM  => 'lib/MogileFS/Plugin/ActiveCache.pm',
	LICENSE				=> 'MIT',
	ABSTRACT      => 'Plugin for MogileFS that attemps to maintain an active cache',
	PREREQ_PM     => {
		'MogileFS::Server'  => '2.64',
	},
	dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean         => { FILES => 'MogileFS-Plugin-ActiveCache-*' },
);
