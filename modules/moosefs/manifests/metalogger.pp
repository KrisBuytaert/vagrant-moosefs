class moosefs::metalogger {


	file {
	"/etc/mfs/mfsmetalogger.cfg":
		content => template("moosefs/mfsmetalogger.cfg.erb");

	}
	service {"mfsmetalogger":
		require => [Package['mfs'],File['/etc/mfs/mfsmetalogger.cfg']],
		ensure => running;
		
	}

}
