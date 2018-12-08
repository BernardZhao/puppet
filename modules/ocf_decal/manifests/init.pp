class ocf_decal {
  include apache
  include ocf_decal::website

  ocf::systemuser { 'ocfdecal':
    groups => ['www-data'],
    opts   => {
      comment => 'DeCal management account',
      home    => '/opt/ocfdecal',
      shell   => '/bin/bash',
    },
  }

  file {
    '/opt/ocfdecal':
      ensure  => directory,
      owner   => ocfdecal,
      group   => ocfdecal,
      require => User['ocfdecal'];
    '/etc/decal_mysql.conf':
      source    => 'puppet:///private/mysql.conf',
      owner     => ocfdecal,
      group     => ocfstaff,
      mode      => '0440',
      show_diff => false,
      require   => User['ocfdecal'];
  }

  vcsrepo { '/opt/share/decal-utils':
    ensure   => latest,
    provider => git,
    revision => 'master',
    source   => 'https://github.com/0xcf/decal-utils.git'
  }
}
