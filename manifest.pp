# In a linux machine, Module packages are usually located in 
"""cd /etc/puppet/code/environments/production/modules/packages and manifests are located in 'manifests/init.pp which should be edited as below '"""

# The module below has a resource entry specifying that python-requests is installed on all machines
""" Additional resources are added, 1. golang package installation on all linux Debian distributions and nodejs on 
all redhat linux distributions

To verify that the rules made are working, connect to a linux instance or another machine in the network with their IP address
or whatever and verify that the right packages are installed

Then run sudo puppet agent -v --test to apply the rules the test the policy with 'apt policy golang'"

class packages {
   package { 'python-requests':
       ensure => installed,
   }
   if $facts[os][family] == "Debian" {
     package { 'golang':
       ensure => installed,
     }
  }
   if $facts[os][family] == "RedHat" {
     package { 'nodejs':
       ensure => installed,
     }
  }
}

# Puppet templates are docs that combin code, datea and literal text to produce a final rendered output. It makes complicated pieces of
# texts smaller(the 2  are: embedded puppet(EPP) and Embedded Ruby(ERB)-uses Ruby in tags(as in line 37-40))

" Templates info are located in templates/info.erb, add edit permissions using sudo chmod 646 templates/info.erb and open it to edit.
Then connect to another machine instance via IP on the network and update by running sudo puppet agent -v --test"
class machine_info {
  if $facts[kernel] == "windows" {
       $info_path = "C:\Windows\Temp\Machine_Info.txt"
   } else {
       $info_path = "/tmp/machine_info.txt"
   }
 file { 'machine_info':
       path => $info_path,
       content => template('machine_info/info.erb'),
   }
}

# This is a system reboot class module which is executed once a machine has been up for 30 days (windows, Darwin and Linux).
# create a a new module rebbot folder sudo mkdir -p /etc/puppet/code/environments/production/modules/reboot/manifests
# Then create a new file sudo nano init.pp and edit with the content below
# Then add this reboot module to /etc/puppet/code/environments/production/manifests/site.pp
# Then run the normal test in the other instance.

class reboot {
  if $facts[kernel] == "windows" {
    $cmd = "shutdown /r"
  } elsif $facts[kernel] == "Darwin" {
    $cmd = "shutdown -r now"
  } else {
    $cmd = "reboot"
  }
  if $facts[uptime_days] > 30 {
    exec { 'reboot':
      command => $cmd,
     }
   }
}
