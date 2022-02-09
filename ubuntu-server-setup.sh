#!/bin/bash -i

function welcome() {
  clear;
  echo -e "=============================================";
  echo -e "==  Welcome to Ubuntu Server Setup Wizard  ==";
  echo -e "---------------------------------------------";
  echo -e "==    For Ubuntu 20.04 on Digital Ocean    ==";
  echo -e "=============================================";
}

function goodbye() {
  echo -e "==";
  echo -e "==  Congratulations";
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
  echo -e "==  > Creating a New User...";
  echo "==";
  echo -e "==  > You will be asked a few questions";
  echo -e "==";
  adduser $username;
  usermod -aG sudo $username;
  echo "==";
}

function setFirewall() {
  echo "==";
  echo -e "==  > Setting Up a Basic Firewall...";
  echo "==";
  ufw allow OpenSSH
  ufw enable
  echo "==";
}

function grantAccess() {
  echo "==";
  echo -e "==  > Granting SSH access to the user...";
  rsync --archive --chown=$username:$username ~/.ssh /home/$username;
  echo "==";
}

function switchAccount() {
  echo "==";
  echo -e "==  > Switching from root to $username...";
  echo "==";
  su - $username;
  echo "==";
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

# create a user account
if [[ -n $username ]]
then
  addUser;
  setFirewall;
  grantAccess;
  switchAccount;
fi

output "Update and Reboot Server? (Yes)" restartServer;

if [[ `checkInput $restartServer "y"` = "y" ]]
then
  updateRestart;
fi

# Layout end here
goodbye;

if [[ `checkInput $restartServer "y"` = "y" ]]
then
  reboot;
fi
