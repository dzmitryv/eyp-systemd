define systemd::service (
                          $execstart,
                          $execstop          = undef,
                          $execreload        = undef,
                          $restart           = 'always',
                          $user              = 'root',
                          $group             = 'root',
                          $servicename       = $name,
                          $forking           = false,
                          $pid_file          = undef,
                          $description       = undef,
                          $after             = undef,
                          $remain_after_exit = undef,
                          $type              = undef,
                        ) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if($type!=undef and $forking==true)
  {
    fail('Incompatible options: type / forking')
  }

  if ! defined(Class['systemd'])
  {
    fail('You must include the systemd base class before using any systemd defined resources')
  }

  validate_re($restart, [ '^always$', '^no$'], "Not a supported restart type: ${restart}")

  file { "/etc/systemd/system/${servicename}.service":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/service.erb"),
    notify  => Exec['systemctl reload'],
  }

}
