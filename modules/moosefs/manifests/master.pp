class moosefs::mfsmaster {

 	# Debian wants files in /etc/ not in /etc/mfs/
	# The debian rc scripts need to chown to nobody:nogroup rather than mfs:mfs 
	# And the /etc/defaults/mfs* files need to be modified ...


        if  ($operatingsystem in ['Debian', 'Ubuntu'])
        {
                $sub="/"


		file {
		"/etc/init.d/mfs-master":
			source => "puppet:///modules/moosefs/mfs-master";
		}


		
      		augeas{"default-mfs-master" :
      			changes => [
   				"set /files/etc/default/mfs-master/MFSMASTER_ENABLE true"],
      		}
	




        }
        else
        {
                $sub="mfs/"
        }



	file {
	"/etc/${sub}mfsmaster.cfg":
		content => template("moosefs/mfsmaster.cfg.erb");
	"/etc/${sub}mfsexports.cfg":
		content => template("moosefs/mfsexports.cfg.erb");
	"/var/mfs/metadata.mfs":
 		replace => false,
		# Fraq apparently this files DOES get rewritten :(  look at file properties etc
		source => "puppet:///modules/moosefs/metadata.mfs.empty",
		name => $operatingsystem ? {
 			/Debian|Ubuntu/ => "/var/lib/mfs/metadata.mfs",
                        /CentOS|Fedora/ => "/var/mfs/metadata.mfs",
                        },



	}
	service {"mfsmaster":
		require => [Class['moosefs::server'],File["/etc/${sub}mfsmaster.cfg"]],
 		name => $operatingsystem ? {
			/Debian|Ubuntu/ => 'mfs-master',
			/CentOS|Fedora/ => 'mfsmaster',
			},
           	hasstatus => false,
                pattern => "mfsmaster",
		ensure => running;
		
	}

}
