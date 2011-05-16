import "*.pp"

class moosefs::server {

        package { "mfs":
                ensure => present
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


