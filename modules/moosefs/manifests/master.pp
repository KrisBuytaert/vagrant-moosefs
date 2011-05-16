class moosefs::mfsmaster {


	file {
	"/etc/mfs/mfsmaster.cfg":
		content => template("moosefs/mfsmaster.cfg.erb");
	"/etc/mfs/mfsexports.cfg":
		content => template("moosefs/mfsexports.cfg.erb");
	"/var/mfs/metadata.mfs":
		source => "puppet:///modules/moosefs/metadata.mfs.empty",
 		replace => false;

	}
	service {"mfsmaster":
		require => [Package['mfs'],File['/etc/mfs/mfsmaster.cfg']],
		ensure => running;
		
	}

}
