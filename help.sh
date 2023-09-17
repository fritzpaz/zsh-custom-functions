function help() {
  local cmd=$1
  if [ "$cmd" = "conda" ]; then
    echo "Conda specific commands:"
    echo "  conda env list                    - List all conda environments."
    echo "  conda activate [envname]          - Activate a specific conda environment."
    echo "  conda deactivate                  - Deactivate the current conda environment."
    echo "  conda create --name [envname]     - Create a new conda environment."
    echo "  conda info                        - Display information about conda."
    echo "  ...                               - Add other custom commands here."
    echo ""
    return
  else
    echo "Available commands:"
    echo "  code [path]                       - Open VS Code." 
    echo "  druid [command] [arguments]       - Druid functions."
    echo "  bubbe [command] [arguments]       - Bubbe functions."
    echo "  awsconfig [list | show | profile] - Set AWS config."
    echo "  zshrc [code | source]             - Edit or source .zshrc."
    echo "  start_ssh_agent                   - Start ssh-agent."
    echo "  windows_chrome [profile] [link]   - Open Chrome in Windows."
    echo "  bitwarden                         - Start Bitwarden."
    echo "  gpt                               - Opens GPT-4."
    echo "  nautilus, gedit, stacer           - Open Linux apps in Windows."
    echo "  help conda                        - Conda specific commands." 
    echo ""
  fi
}