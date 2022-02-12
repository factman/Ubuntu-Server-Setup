# Ubuntu-Server-Setup

Ubuntu Server Setup is a script that help you setup and install necessary applications with no hassles, based on Digital Ocean Standards.

There's every tendency that some of the process may not be fully compatible with AWS environment.

But the script is optimized for any Ubuntu Environment.

## Features

* ### Server Setup with SSH

  * Sudo User Account Setup
  * SSH Access via the root key

* ### App Manager

  * Backend (Node, Nginx, PM2)
  * Frontend (React, Static Webpage, Nginx)
  * SSL (Let's Encrypt)

## Server Setup Installation

This should only be used from the `root` user to create a user account and enable `ssh` access.

```bash
cd ~ && curl https://raw.githubusercontent.com/factman/Ubuntu-Server-Setup/main/ubuntu-server-setup.sh > ./uss-install.sh && chmod +x ./uss-install.sh && ./uss-install.sh
```

## App Manager Installation

This is only required to setup your server environment and install necessary packages for deployment of your applications.

This currently support Node Applications via (Nginx and PM2) and React/Static Webpage via (Nginx)

```bash
cd ~ && curl https://raw.githubusercontent.com/factman/Ubuntu-Server-Setup/main/app-manager.sh > ./app-manager.sh && chmod +x ./app-manager.sh && ./app-manager.sh
```

## App Manager Usage

After installation above you can access the App Manager this way to get access to the interactive menu options.

```bash
~/app-manager.sh
```

Then follow the prompt to complete any task of your choice
