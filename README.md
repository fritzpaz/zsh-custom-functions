# zshrc-custom-functions

This repository includes a variety of utility scripts and functions for a zsh shell environment.

## Contents

### aliases.sh
This script includes several helpful aliases, such as `awggit`, `awscredentials`, `awslogin`, `bitwarden`, `passwords`, and `gpt`.

### awsconfig.sh
This script provides a function named `awsconfig` for managing AWS profiles. It can list available profiles, show the details of a specified profile, or set a profile as the default.

### start_ssh_agent.sh
This script starts the `ssh-agent` and loads your `id_rsa` private key into it. If an `ssh-agent` is already running, the script sets `SSH_AGENT_PID` and `SSH_AUTH_SOCK` accordingly.

### windows_chrome.sh
This script defines a `windows_chrome` function that opens a specified Chrome profile and navigates to a given URL.

### zshrc.sh
This script provides a function named `zshrc` that provides shortcuts for opening and reloading the `.zshrc` configuration file.

## Usage
To use these functions and aliases, source the corresponding file in your `.zshrc` or another shell startup script:

```bash
source path/to/zshrc-functions/aliases.sh
source path/to/zshrc-functions/awsconfig.sh
source path/to/zshrc-functions/start_ssh_agent.sh
source path/to/zshrc-functions/windows_chrome.sh
source path/to/zshrc-functions/zshrc.sh
```

Remember to replace `path/to/zshrc-functions/` with the actual path to your `zshrc-functions` folder.
