zshrc() {
  case "$1" in
    "code" | "edit")
      local target=${2:-""}
      case "$target" in
        "")
          cd "$HOME/code/zshrc"
          code "$HOME/.zshrc"
          ;;
        "public" | "private")
          cd "$HOME/code/zshrc"
          code "$HOME/code/zshrc"
          code "$HOME/.zshrc"
          ;;
        *)
          echo "Invalid target for git. Available targets: public, private\n"
          return 1
          ;;
      esac
      ;;
    "source" | "reload")
      source "$HOME/.zshrc"
      echo "Zsh configuration reloaded."
      ;;
    "cd")
      local target=${2:-""}
      case "$target" in
        "public")
          cd $HOME/code/zshrc/zshrc_public
          ;;
        "private")
          cd $HOME/code/zshrc/zshrc_private
          ;;
        "")
          cd $HOME/code/zshrc
          ;;
        *)
          echo "Invalid target for cd. Available targets: public, private\n"
          return 1
          ;;
      esac
      ;;
    "git")
      local target=${2:-""}
      case "$target" in
        "public")
          windows_chrome "$bubbe_profile" "https://github.com/bubbetecnologia/bubbe"
          ;;
        "private")
          windows_chrome "$bubbe_profile" "https://github.com/bubbetecnologia/bubbe-infra"
          ;;
        *)
          echo "Invalid target for git. Available targets: public, private\n"
          return 1
          ;;
      esac
      ;;
    *)
      echo "Available commands:"
      echo "zshrc code | edit           : Opens the .zshrc file in VS Code."
      echo "zshrc source | reload       : Reloads the .zshrc file.\n"
      echo "zshrc git [public|private]  : Opens the git repository for the public or private zshrc files."
      ;;
  esac
}