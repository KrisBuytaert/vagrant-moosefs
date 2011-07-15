class moosefs::metalogger {



	
 	# Debian wants files in /etc/ not in /etc/mfs/
        # The debian rc scripts need to chown to nobody:nogroup rather than mfs:mfs
        # And the /etc/defaults/mfs* files need to be modified ...


        
        if  ($operatingsystem in ['Debian', 'Ubuntu']) 
        {
                $sub="/"


                file {
                "/etc/init.d/mfs-metalogger":
                        source => "puppet:///modules/moosefs/mfs-metalogger";
                }


                augeas{"default-mfs-metalogger" :
                        changes => ["set /files/etc/default/mfs-metalogger/MFSMETALOGGER_ENABLE true
"],
                }




        }
        else 
        {
                $sub="mfs/"
        }




	file {
	"/etc/${sub}mfsmetalogger.cfg":
		content => template("moosefs/mfsmetalogger.cfg.erb");

	}
	service {"mfsmetalogger":
		require => [Class['moosefs::server'],File['/etc/${sub}mfsmetalogger.cfg']],
		name => $operatingsystem ? {
                        /Debian|Ubuntu/ => 'mfs-metalogger',
                        /Centos|Fedora/ => 'mfsmetalogger',
                        },
                hasstatus => false,
                pattern => "mfsmetalogger",

		ensure => running;
		
	}

}
