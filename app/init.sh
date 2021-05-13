#!/bin/bash
# Change DB_HOST to db private ip
echo export DB_HOST=mongodb://32.34.2.42:27017/posts >> /home/ubuntu/.bashrc
source ~/.bashrc
echo $DB_HOST

# Run app
cd /etc/systemd/system
sudo touch webapp.service
echo -e "
[Service]
Type=simple
Restart=on-failure
Environment=NODE_PORT=3000
Environment=DB_HOST=mongodb://32.34.2.42:27017/posts
ExecStart=/usr/bin/nodejs /home/ubuntu/app/app.js
User=ubuntu
# Note Debian/Ubuntu uses 'nogroup', RHEL/Fedora uses 'nobody'
Group=nogroup
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production
WorkingDirectory=/home/ubuntu/app

[Install]
WantedBy=multi-user.target
" | sudo tee webapp.service

sudo systemctl start webapp
