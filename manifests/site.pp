class repo {

	# Enable RPMForge 


yumrepo { 

  "rpmforge":
                                descr => "RPMforge.net - dag",
                                baseurl => absent,
                                mirrorlist => "http://apt.sw.be/redhat/el5/en/mirrors-rpmforge",
                                enabled => "1",
                                gpgkey => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag",
                                gpgcheck => "0",
                                priority => 1; 
	}

}


class mine {


	


	service { "iptables":
                ensure => "stopped",
                enable => "false";
                }


	include repo


}



node moose1{ 
	include mine
	include moosefs::server
	$mfsmaster = "192.168.99.101"
	include moosefs::mfsmaster
	file {"/mnt/storage": ensure=> directory, mode => 777; }
	$mountpoints = "/mnt/storage"
	include moosefs::chunk
}
node moose2{ 
	include mine
	include moosefs::server
	$mfsmaster = "192.168.99.101"
	include moosefs::metalogger
	file {"/mnt/storage": ensure=> directory, mode => 777; }
	$mountpoints = "/mnt/storage"
	include moosefs::chunk
}
node moose3{ 
	include mine
  	include moosefs::client 
	file {"/mnt/moose/": ensure => directory }
	$mfsmaster = "192.168.99.101"
	mount { "/mnt/moose":
        		atboot => true,
        		device => "mfsmount",
        		ensure => mounted,
        		fstype => "fuse",
        		options => "mfsmaster=$mfsmaster,mfsport=9421,_netdev"; }

}
