GIT_ROOT=`git rev-parse --show-toplevel`
if [ $# -lt 1 ]
then
  echo "usage: $0 <server>"
  echo "server is a clean ubuntu server which will act as a build server."
  echo "you must be able to ssh to <server> without entering a password. Meaning, you must have the pem file in your ~/.ssh directory."
  exit 0
fi

server=$1

scp ~/.ssh/production-code-org.pem $server:/home/ubuntu/.ssh/
scp -r $GIT_ROOT/dashboard/scripts/archive $server:/tmp/
scp -r $GIT_ROOT/dashboard/config/nginx-archive.conf $server:/etc/nginx/nginx.conf
scp $GIT_ROOT/build_scripts/archive.cron $server:/tmp/

ssh $server << EOF
  sudo mkdir -p /etc/cdo
  sudo mkdir -p /mnt/backups/
  sudo chown -R ubuntu /mnt/
  sudo cp /tmp/archive/* /etc/cdo/
  sudo cp /tmp/archive.cron /etc/cron.d/cdo
  sudo crontab -u ubuntu /etc/cron.d/cdo
  sudo nginx -s reload
EOF
