#!/bin/bash -i

function welcome() {
  echo -e "=============================================";
  echo -e "==  Welcome to Ubuntu Server Setup Wizard  ==";
  echo -e "---------------------------------------------";
  echo -e "==    For Ubuntu 20.04 on Digital Ocean    ==";
  echo -e "=============================================";
}

function goodbye() {
  echo -e "==";
  echo -e "==  Congratulations!!! 🎊🎉";
  echo -e "==  Server setup completed succesfully.";
  echo -e "==";
  echo -e "==  Use the following to connect via SSH on your local computer";
  echo -e "==  ssh $username@$(curl -s api.infoip.io/ip)";
  echo -e "==";
  echo -e "=============================================";
  echo -e "==        Made with ❤️ from ©Factman        ==";
  echo -e "=============================================";
}

function addUser() {
  echo "==";
  echo -e "==    > Creating a New User...";
  adduser $username;
  usermod -aG sudo $username;
  echo -e "==    > You will be asked a few questions";
}

function setFirewall() {
  echo "==";
  echo -e "==    > Setting Up a Basic Firewall...";
  ufw allow OpenSSH
  ufw enable
}

function grantAccess() {
  echo "==";
  echo -e "==    > Granting SSH access to the user...";
  rsync --archive --chown=$username:$username ~/.ssh /home/$username;
}

function switchAccount() {
  echo "==";
  echo -e "==    > Switching from root to $username...";
  su - $username;
}

function setupNginx() {
  echo "==";
  echo -e "==    > Updating apt libraries...";
  sudo apt update -y
  echo -e "==    > Setting up Nginx...";
  echo -e "==    > Installing Nginx...";
  sudo apt install nginx;
  echo -e "==    > To avoid a possible hash bucket memory problem...";
  echo -e "==    > it is necessary to adjust /etc/nginx/nginx.conf to...";
  echo -e "==      ...";
  echo -e "==      http {";
  echo -e "==          ...";
  echo -e "==          server_names_hash_bucket_size 64;";
  echo -e "==          ...";
  echo -e "==      }";
  echo -e "==      ...";
  echo -e "==    > Press Control X to exit after the configuration";
  echo -e -n "==    > Press enter to continue";
  read;
  sudo nano /etc/nginx/nginx.conf;
  sudo nginx -t;
  sudo systemctl restart nginx;
}

function enablingHTTPS() {
  echo "==";
  echo -e "==    > Installing let's encrypt...";
  sudo apt install certbot python3-certbot-nginx -y;
  echo -e "==    > Updating the firewall...";
  sudo ufw allow 'Nginx Full';
}

function enablingHTTP() {
  echo "==";
  echo -e "==    > Updating the firewall...";
  sudo ufw allow 'Nginx HTTP';
}

function installNVM() {
  echo "==";
  echo -e "==    > Installing NVM...";
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh";
  echo -e "==    > Installed NVM: v`nvm -v`";
}

function installNodeJS() {
  echo "==";
  echo -e "==    > Installing NodeJS v$1...";
  nvm install $1;
  nvm use node;
  echo -e "==    > Installed Node: `node -v`";
  echo -e "==    > Installed NPM: v`npm -v`";
}

function installPM2() {
  echo "==";
  echo -e "==    > Installing PM2...";
  sudo npm install -g pm2;
  echo -e "==    > Installed PM2: v`pm2 -v`";
  pm2 startup;
}

function output() {
  echo "==";
  echo -e -n "==  $1: ";
  read $2;
}

function checkInput() {
  case $1 in
    n | N | no | No | NO) echo "n";;
    y | Y | yes | Yes | YES) echo "y";;
    *) echo $2;;
  esac
}

# Layout start here
welcome;

if [[ $UID -eq 0 ]]
then
  # set $username
  output "Enter Username" username;
fi

# Installation Options
echo "==";
echo -e "==  Press (Y) for Yes & (N) for No for the following promps";
output "Install Nginx (Yes)" installNginx;
output "Enable HTTPS with Let's Encrypt (Yes)" enableHttps;
output "Install NVM/NodeJS/NPM (Yes)" installNode;
if [[ `checkInput $installNode "y"` = "y" ]]
then
  output "Node version (14, 16, 12, ...)" nodeVersion;
fi
output "Install PM2 (Yes)" installPM;

# create a user account
if [[ -n $username ]]
then
  addUser;
  setFirewall;
  grantAccess;
  switchAccount;
fi

# installing Nginx
if [[ `checkInput $installNginx "y"` = "y" ]]
then
  setupNginx;
  if [[ `checkInput $enableHttps "y"` = "y" ]]
  then
    enablingHTTPS;
  else
    enablingHTTP;
  fi
fi

# installing NVM/Node/NPM
if [[ `checkInput $installNode "y"` = "y" ]]
then
  installNVM;
  if [[ -z $nodeVersion ]]
  then
    installNodeJS 14;
  else
    installNodeJS $nodeVersion;
  fi
fi

# installing PM2
if [[ `checkInput $installPM "y"` = "y" ]]
then
  installPM2;
fi

# Layout end here
goodbye;
