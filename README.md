# Ubuntu-Server-Setup

Ubuntu Server Setup is a script that help you setup and install necessary applications with no hassles.

## Features

* ### Server Setup with SSH

  * Sudo User Account Setup
  * SSH Access via the root key

* ### App Manager

  * Backend (Node, Nginx, PM2)
  * Frontend (React, Static Webpage, Nginx)
  * SSL (Let's Encrypt)

## Server Setup Installation

```bash
curl https://raw.githubusercontent.com/factman/Ubuntu-Server-Setup/main/ubuntu-server-setup.sh > ./uss-install.sh && chmod +x ./uss-install.sh && ./uss-install.sh
```

## App Manager Installation

```bash
curl https://raw.githubusercontent.com/factman/Ubuntu-Server-Setup/main/app-manager.sh > ./app-manager.sh && chmod +x ./app-manager.sh && ./app-manager.sh
```
