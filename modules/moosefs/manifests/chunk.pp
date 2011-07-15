class moosefs::chunk  {

	# Debian wants files in /etc/ not in /etc/mfs/

	# The debian rc scripts need to chown to nobody:nogroup rather than mfs:mfs
        # And the /etc/defaults/mfs* files need to be modified ...


	
 	if  ($operatingsystem in ['Debian', 'Ubuntu']) 
	{
		$sub="/"


		file {
 		"/etc/init.d/mfs-chunkserver":
                        source => "puppet:///modules/moosefs/mfs-chunkserver";
                }


		augeas{"default-mfs-chunkserver" :
                        changes => ["set /files/etc/default/mfs-chunkserver/MFSCHUNKSERVER_ENABLE true"],
                }




	}
	else 
	{
		$sub="mfs/"
	}



	file {
	"/etc/${sub}mfschunkserver.cfg":
		content => template("moosefs/mfschunkserver.cfg.erb");
	"/etc/${sub}mfshdd.cfg":
		content => template("moosefs/mfshdd.cfg.erb");

	}
	service {"mfschunkserver":
		require => [Class['moosefs::server'],File["/etc/${sub}mfschunkserver.cfg","/etc/${sub}mfshdd.cfg"]],
   		name => $operatingsystem ? {
                        /Debian|Ubuntu/ => 'mfs-chunkserver',
                        /Centos|Fedora/ => 'mfschunkserver',
                        },
		hasstatus => false,
		pattern => "mfschunkserver",
		ensure => running;
		
	}

}


