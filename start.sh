#! /bin/sh -

# handle the gitolite.rc
if [  -f "/home/git/repositories/gitolite.rc" ]; then
  echo 'import rc file'
  su git -c "cp /home/git/repositories/gitolite.rc /home/git/.gitolite.rc"
else
  echo 'export rc file'
  su git -c "cp /home/git/.gitolite.rc /home/git/repositories/gitolite.rc"
fi

if [ -f /home/git/repositories/gitolite-configured ]; then
  su git -c "/home/git/bin/gitolite setup"
else
  # handle the ssh key
  if [ -n "$SSH_KEY" ]; then
    echo "Replace the admin ssh key.\n"
    echo $SSH_KEY > /home/git/admin.pub
    su git -c "/home/git/bin/gitolite setup -pk=/home/git/admin.pub"
  else
    su git -c "/home/git/bin/gitolite setup"
    echo "The built-in private key for admin:\n"
    cat /admin
  fi

  su git -c "touch /home/git/repositories/gitolite-configured"
fi

/usr/sbin/sshd -D
