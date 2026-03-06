# docker-learning-environment

## Installation of WSL

### 1. Official installation instructions
For the latest installation instructions, please refer to the official Microsoft documentation: 
https://learn.microsoft.com/windows/wsl/install


### 2. Install WSL using PowerShell
On Windows 10 (version 2004 and later) and Windows 11, you can install WSL using the following PowerShell command:
```powershell
# PowerShell
wsl --install
```

### 3. Post-installation setup
After installing WSL, please refer to the following document to set up your environment: 
https://learn.microsoft.com/windows/wsl/setup/environment

<br>

## Installation of Git on WSL:Ubuntu

### 1. Install Git
This command installs Git along with bash-completion, which provides tab completion for Git commands such as branch names.

```bash
# WSL:Ubuntu
sudo apt update
sudo apt install git bash-completion

# After installing git bash-completion, please edit `~/.bashrc` file.
nano ~/.bashrc
```

Please copy and paste following lines to avoid mistyping in last line of `.bashrc` file.

```bash
# Git prompt with colors
if [ -f /etc/bash_completion.d/git-prompt ]; then
    source /etc/bash_completion.d/git-prompt
    GIT_PS1_SHOWDIRTYSTATE=1
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
fi
```

After installing Git, you need to set additional configuration.

<br>

### 2. Git Configuration

#### 2-1. Set your name and email for Git commits
This information will be recorded as the commit author when you run `git commit`.
  
```bash
git config --global user.name "your name"
git config --global user.email "your email"
```

#### 2-2. Change the default branch name to `main`
`main` is now the standard default branch name, replacing `master`.

```bash
git config --global init.defaultBranch main
```

#### 2-3. Change the default push behavior
After this configuration, running `git push` will push the current branch to GitHub without specifying the branch name.
    
```bash
git config --global push.default current
```

#### 2-4. Automatically clean up deleted remote branches
When a branch is deleted on the remote repository, this setting automatically removes the corresponding `remote-tracking branch` during `git fetch`.  

 ```bash
 git config --global fetch.prune true
 ```

This only deletes `remote-tracking branches`; `local branches` are not deleted.

#### 2-5. Check configuration
You can check the configuration you have entered.

```
git config --list
```

<br>

## Establishing a connection to GitHub from your computer

### 1. SSH key generation on WSL:Ubuntu
This command generates SSH key with the `ed25519` algorithm.
```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

After running `ssh-keygen` command, <b>make sure that `id_ed25519.pub` file exists</b>.
```bash
ls -l ~/.ssh

# Output examples
# keisuke@GA401IV:~
# $ ls -l ~/.ssh
# total 16
# -rw------- 1 keisuke keisuke  464 Jan  8 15:22 id_ed25519
# -rw-r--r-- 1 keisuke keisuke  108 Jan  8 15:22 id_ed25519.pub  <---  This public key needs to be registered GitHub. 
# -rw------- 1 keisuke keisuke 1342 Jan  8 15:30 known_hosts
# -rw------- 1 keisuke keisuke  506 Jan  8 15:29 known_hosts.old
```

