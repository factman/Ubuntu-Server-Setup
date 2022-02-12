#!/bin/bash -i

red='\033[0;31m';
clear='\033[0m';

function welcome() {
  clear;
  echo -e "=============================================";
  echo -e "==  Welcome to Application Manager Wizard  ==";
  echo -e "---------------------------------------------";
  echo -e "==    For Ubuntu 20.04 on Digital Ocean    ==";
  echo -e "=============================================";
  echo -e "==";
}

function goodbye() {
  echo -e "==";
  echo -e "==  Congratulations";
  echo -e "==  Operation succesfully.";
  echo -e "==";
  echo -e "==";
  echo -e "=============================================";
  echo -e "==        Made with ${red}❤️${clear} from ©Factman        ==";
  echo -e "=============================================";
}

function setFirewall() {
  echo "==";
  echo -e "==  > Setting Up a Basic Firewall...";
  echo "==";
  ufw allow OpenSSH
  ufw enable
  echo "==";
}

function aptUpdate() {
  echo "==";
  echo -e "==  > Updating apt libraries...";
  echo "==";
  sudo apt -y update
  echo "==";
}

function setupNginx() {
  aptUpdate;
  echo "==";
  echo -e "==  > Installing Nginx...";
  echo "==";
  sudo apt install nginx;
  echo "==";
  echo "==";
  echo -e "==  > To avoid a possible hash bucket memory problem";
  echo -e "==  > it is necessary to adjust /etc/nginx/nginx.conf";
  echo "==";
  echo -e "==    ...";
  echo -e "==    http {";
  echo -e "==        ...";
  echo -e "==        server_names_hash_bucket_size 64;";
  echo -e "==        ...";
  echo -e "==    }";
  echo -e "==    ...";
  echo -e "==";
  echo -e "==  > Press Control O to save & X to exit the configuration";
  echo -e "==";
  echo -e -n "==  > Press enter to continue";
  read;
  echo "==";
  sudo nano /etc/nginx/nginx.conf;
  sudo nginx -t;
  sudo systemctl restart nginx;
  echo "==";
}

function enablingHTTPS() {
  setFirewall;
  echo "==";
  echo -e "==  > Installing let's encrypt...";
  echo "==";
  sudo apt -y install certbot python3-certbot-nginx;
  echo "==";
  echo "==";
  echo -e "==  > Updating the firewall...";
  sudo ufw allow 'Nginx Full';
  echo "==";
}

function enablingHTTP() {
  setFirewall;
  echo "==";
  echo -e "==  > Updating the firewall...";
  sudo ufw allow 'Nginx HTTP';
  echo "==";
}

function installNVM() {
  echo "==";
  echo -e "==  > Installing NVM...";
  echo "==";
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
  export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  source ~/.bashrc;
  source ~/.profile;
  echo "==";
  echo "==";
  echo -e "==  > Installed NVM: v`nvm -v`";
  echo "==";
}

function installNodeJS() {
  echo "==";
  echo -e "==  > Installing NodeJS v$1...";
  echo "==";
  nvm install $1;
  nvm use node;
  echo "==";
  echo "==";
  echo -e "==  > Installed Node: `node -v`";
  echo -e "==  > Installed NPM: v`npm -v`";
  echo "==";
}

function installPM2() {
  source ~/.bashrc;
  source ~/.profile;
  echo "==";
  echo -e "==  > Installing PM2...";
  echo "==";
  npm install -g pm2;
  echo "==";
  echo "==";
  pm2Save=`pm2 startup`;
  pm2ver=`pm2 -v`;
  echo "==  sudo "${pm2Save##*"sudo "};
  echo "==";
  echo -e "==  > IMPORTANT: You must run the code above to complete installation.";
  echo "==";
  echo "==";
  echo -e "==  > Installed PM2: v`pm2 -v`";
  echo "==";
  source ~/.bashrc;
  source ~/.profile;
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

function init() {
  # Installation Options
  echo "==";
  echo -e "==  Press (Y) for Yes & (N) for No";
  output "Install Nginx (Yes)" installNginx;
  output "Enable HTTPS with Let's Encrypt (Yes)" enableHttps;
  output "Install NVM/NodeJS/NPM (Yes)" installNode;
  if [[ `checkInput $installNode "y"` = "y" ]]
  then
    output "Node version (14, 16, 12, ...)" nodeVersion;
  fi
  output "Install PM2 (Yes)" installPM;

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
}

function updateRestart() {
  echo "==";
  echo -e "==  > Updating Server...";
  echo "==";
  apt -y update;
  echo "==";
  echo "==";
  echo -e "==  > Upgrading Server...";
  echo "==";
  apt -y upgrade;
  echo "==";
  echo "==";
}

# Layout start here
welcome;

if [[ $1 = "init" ]]
then
  echo "==  Installation in progress";
  init;
elif [[ $1 = "update" ]]
then
  output "Update and Reboot Server? (Yes)" restartServer;
  if [[ `checkInput $restartServer "y"` = "y" ]]
  then
    updateRestart;
  fi
fi

# Layout end here
goodbye;

if [[ `checkInput $restartServer "y"` = "y" ]]
then
  sudo reboot;
fi
