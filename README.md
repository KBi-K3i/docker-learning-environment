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

</br>

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

### 2. Git configuration

1. Set your name and email for Git commits
    - This information will be recorded as the commit author when you run `git commit`.
  
        ```bash
        git config --global user.name "your name"
        git config --global user.email "your email"
        ```

2. Change the default branch name to `main`
    - `main` is now the standard default branch name, replacing `master`.

        ```bash
        git config --global init.defaultBranch main
        ```

2. Change the default push behavior
    - After this configuration, running `git push` will push the current branch to GitHub without specifying the branch name.
    
        ```bash
        git config --global push.default current
        ```

3. Automatically clean up deleted remote branches
    - When a branch is deleted on the remote repository, this setting automatically removes the corresponding `remote-tracking branch` during `git fetch`.
    - This only deletes `remote-tracking branches`; `local branches` are not deleted.

         ```bash
         git config --global fetch.prune true
         ```

## Establishing a connection to GitHub from your computer
