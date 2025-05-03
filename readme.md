## Swap File if USE DO $48 -> 4/8 
Buat file Swapfile :
```
sudo fallocate -l 32G /swapfile
```

Set Perm : 
```
sudo chmod 600 /swapfile
```

Format :
```
sudo mkswap /swapfile
```

Enable : 
```
sudo swapon /swapfile
```

Enable on boot : 
```
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

Cek :
```
free
```

Reboot :
```
sudo reboot
```

---

## 1) Install Dependencies
**1. Update System Packages**
```bash
sudo apt-get update && sudo apt-get upgrade -y
```
**2. Install General Utilities and Tools**
```bash
sudo apt install screen curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev  -y
```

**3. Install Python**
```bash
sudo apt-get install python3 python3-pip python3-venv python3-dev -y
```

**4. Install Node**
```
sudo apt-get update
```
```
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
```
```
sudo apt-get install -y nodejs
```
```
node -v
```
```bash
sudo npm install -g yarn
```
```bash
yarn -v
```

**5. Install Yarn**
```bash
curl -o- -L https://yarnpkg.com/install.sh | bash
```
```bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
```
```bash
source ~/.bashrc
```



## 📥 Installation

1. **Install `sudo`**
```bash
apt update && apt install -y sudo
```
2. **SCREEN KALO BELOM SCREEN, KALO UDAH LANGSUNG AJA LANJUT SCREEN SEBELUMNYA** 
```bash
screen -S gensyn
```
3. ***RUN PAKE GPU INI COMMANDNYA***
```bash
cd $HOME && git clone https://github.com/Alvinagustus/gensyn.git && chmod +x gensyn/gensyn.sh && source ./gensyn/gensyn.sh
```
3. ***TIDAK DIREKOMENDASIKAN RUN INI HANYA UNTUK TRIAL AND ERROR SAJA***
```bash
cd $HOME && git clone https://github.com/Alvinagustus/gensyn.git && chmod +x gensyn/gensyn-test.sh && source ./gensyn/gensyn-test.sh
```
3. ***RUN PAKE CPU INI COMMANDNYA***
```bash
cd $HOME && git clone https://github.com/Alvinagustus/gensyn.git && chmod +x gensyn/gensyn-cpu.sh && source ./gensyn/gensyn-cpu.sh
```
