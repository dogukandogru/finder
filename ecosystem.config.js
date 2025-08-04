module.exports = {
  apps: [
    {
      name: 'finder',
      script: 'npm',
      args: 'start',
      cwd: '/var/www/finder',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: 3000,
        HOST: '0.0.0.0'
      },
      error_file: '/var/log/pm2/finder.err.log',
      out_file: '/var/log/pm2/finder.out.log',
      log_file: '/var/log/pm2/finder.log',
      time: true
    }
  ]
};