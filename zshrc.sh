zshrc() {
  case "$1" in
    "code" | "edit")
      code "$HOME/.zshrc"
      ;;
    "source" | "reload")
      source "$HOME/.zshrc"
      echo "Zsh configuration reloaded."
      ;;
    *)
      echo "Available commands:"
      echo "zshrc code | edit       : Opens the .zshrc file in VS Code."
      echo "zshrc source | reload   : Reloads the .zshrc file.\n"
      ;;
  esac
}