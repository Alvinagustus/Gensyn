## Swap File if USE DO $48 -> 4/8 
Buat file Swapfile :
```
sudo fallocate -l 32G /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1G count=32 status=progress
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
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
source ~/.bashrc
nvm install 'lts/*'
nvm use 'lts/*'
```

**5. Install Yarn**
```bash
curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update -y
sudo apt-get install yarn -y
```

**🚩🚩🚩🚩PENTING KHUSUS CPU ERROR ONLY, KALO UDAH PERNAH RUN TOLONG SCREENNYA DIHAPUS DULU DAN RUN COMMAND DIBAWAH INI DI ROOT JANGAN DISCREEN**
Update Python kalo belum pake 3.13 
```bash
curl https://pyenv.run | bash
```

***INI BEDA TIAP VPS MASUKIN DARI OUTPUTNYA AJA YANG MIRIP DIBAWAH INI***
```bash
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
```

```bash
source ~/.bashrc
```

```bash
sudo apt-get install libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev tk-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev uuid-dev
```

```bash
pyenv install 3.13.1
```

```bash
pyenv global 3.13.1
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
