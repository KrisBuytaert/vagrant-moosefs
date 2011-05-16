class moosefs::chunk  {


	file {
	"/etc/mfs/mfschunkserver.cfg":
		content => template("moosefs/mfschunkserver.cfg.erb");
	"/etc/mfs/mfshdd.cfg":
		content => template("moosefs/mfshdd.cfg.erb");

	}
	service {"mfschunkserver":
		require => [Package['mfs'],File['/etc/mfs/mfschunkserver.cfg','/etc/mfs/mfshdd.cfg']],
		ensure => running;
		
	}

}


