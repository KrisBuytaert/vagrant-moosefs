import "*.pp"

class moosefs::server {

    if  ($operatingsystem in ['Debian', 'Ubuntu']) 
    {
	package {
		"mfs-common":	
                	ensure => present;
		"mfs-master":	
                	ensure => present;
		"mfs-metalogger":	
                	ensure => present;
		"mfs-chunkserver":	
                	ensure => present;
	}
    }

   if  ($operatingsystem in ['Centos', 'Fedora'])  
   {
        package { "mfs":
                ensure => present
        	}
   }

}

class moosefs::client {

        package { "mfs-client":
                ensure => present

        }
}


class moosefs {

        include moosefs::server
        include moosefs::client


}


