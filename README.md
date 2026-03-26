# docker-learning-environment
## 1. Installation of WSL
### 1.1 Official installation instructions
For the latest installation instructions, please refer to the official Microsoft documentation: 
https://learn.microsoft.com/windows/wsl/install


### 1.2. Install WSL using PowerShell
On Windows 10 (version 2004 and later) and Windows 11, you can install WSL using the following PowerShell command:
```powershell
# PowerShell
wsl --install
```

### 1.3. Post-installation setup
After installing WSL, please refer to the following document to set up your environment: 
https://learn.microsoft.com/windows/wsl/setup/environment


## 2. Git setup
### 2.1. Git installation
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

### 2.2. Git configuration
#### 2.2.1 Set your information
Set your name and email for Git commits. This information will be recorded as the commit author when you run `git commit`.

```bash
# WSL:Ubuntu
git config --global user.name "your name"
git config --global user.email "your email"
```
    
#### 2.2.2. Change the default branch
`main` is now the standard default branch name, replacing `master`. So, change the default branch name to `main`. 
    
```bash
# WSL:Ubuntu
git config --global init.defaultBranch main
```

#### 2.2.3. Change the default push behavior
Change the default `git push` behavior upload the current branch. After this configuration, running `git push` will push the current branch to GitHub without specifying the branch name.
    
```bash
# WSL:Ubuntu
git config --global push.default current
```

#### 2.2.4. Automatically clean up deleted remote branches
When a branch is deleted on the remote repository, this setting automatically removes the corresponding `remote-tracking branch` during `git fetch`. This only deletes `remote-tracking branches`; `local branches` are not deleted.

```bash
# WSL:Ubuntu
git config --global fetch.prune true
```

## 3. Establishing a connection to GitHub from your computer
### 3.1. Generate an SSH key
You need to generate an **ED25519-format private key** to connect to GitHub. Please execute the following command to generate a private key.

```bash
# WSL:Ubuntu
ssh-keygen -t ed25519 -C "your email"
```

By running the command above, the following keys will be created in the `~/.ssh` directory.

```bash
# WSL:Ubuntu
ls -l ~/.ssh

# Example:
# ~/.ssh/id_ed25519
# ~/.ssh/id_ed25519.pub
```

 - `id_ed25519.pub` is a **public key**, so register it with GitHub.
 - `id_ed25519` is a **private key**, so **do not share it with anyone**.
    
### 3.2. Start the SSH agent
Start the SSH agent to manage your SSH keys.

```bash
# WSL:Ubuntu
eval "$(ssh-agent -s)"
```
    
### 3.3. Add the private key to the SSH agent
Add the generated private key to the SSH agent.

```bash
# WSL:Ubuntu
ssh-add ~/.ssh/id_ed25519
```

### 3.4. Add the public key to GitHub
#### 3.4.1. Display the public key
Display the public key with the following command.

```bash
# WSL:Ubuntu
cat ~/.ssh/id_ed25519.pub
```

#### 3.4.2. Copy the output and add it to GitHub
Copy the output of `cat ~/.ssh/id_ed25519.pub` and add it to GitHub using the following steps:

1. Go to **GitHub → Settings → SSH and GPG keys**
2. Click **New SSH key**
3. Enter a title
4. Choose **Authentication Key** as the key type 
5. Paste the public key into the text box
6. Click **Add SSH key**

### 3.5. Test the SSH connection
Test the SSH connection with the following command.

```bash
# WSL:Ubuntu
ssh -T git@github.com
```

If you see a message like the following, the SSH connection is successful:

```text
Hi <your-username>! You've successfully authenticated.
```

## 4. Clone this repository
Create a directory for this repository.

```bash
# WSL:Ubuntu
mkdir ~/src
```

Change to the directory.

```bash
# WSL:Ubuntu
cd ~/src
```

Execute the `git clone` command.
```bash
# WSL:Ubuntu
git clone git@github.com:KBi-K3i/docker-learning-environment.git
```

## 5. Start the Docker environment
This project uses Docker to provide a Python learning environment.

### 5.1. Build the Docker image
Build the image from the `Dockerfile`:

```bash
# WSL:Ubuntu (run in the directory that contains Dockerfile)
docker build --tag python:3.13-practice-image --file ./Dockerfile .
```

### 5.2. Run the container
Run a container in the background and mount your working directory to `/app`:
```bash
# WSL:Ubuntu
docker run --detach \
  --name python3.13-practice-container \
  --volume ~/src/docker-learning-environment:/app \
  --workdir /app \
  python:3.13-practice-image
```

### 5.3. Verify the container is running
```bash
# WSL:Ubuntu
docker ps
```

### 5.4. Stop / remove the container
Stop the container:
```bash
# WSL:Ubuntu
docker stop python3.13-practice-container
```

Remove the container (if you no longer need it):
```bash
# WSL:Ubuntu
docker rm python3.13-practice-container
```

Remove the image (optional):
```bash
# WSL:Ubuntu
docker rmi python:3.13-practice-image
```

## 6. Open the Docker container in VS Code

You can attach Visual Studio Code to the running Docker container.

### 6.1. Install required VS Code extensions

Install the following VS Code extensions:

- **Dev Containers** (required)
- **Python** (inside the container)
- **Docker** (optional)

### 6.2. Attach VS Code to the container

1. Open Visual Studio Code
2. Open the **Containers** view from the sidebar
3. Right-click the target container
4. Select `Attach Visual Studio Code`

### 6.3. Open the working directory

After attaching to the container, open the `/app` directory manually.
> Note: The default working directory is `/root` after attaching.
