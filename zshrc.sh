zshrc() {
  case "$1" in
    "code" | "edit")
      cd "$HOME/code/zshrc"
      code "$HOME/code/zshrc"
      code "$HOME/.zshrc"
      ;;
  "source" | "reload")
    length=50
    time_to_load=0.2
    sleep_time=$(python -c "print($time_to_load/$length/1000)")
    echo -n "[$(printf "%-${length}s")] 0%" # Initial empty bar and 0%
    for i in $(seq 1 $length); do
      sleep $sleep_time
      # Create a variable that contains the correct number of '#' characters
      bar=$(printf "%-${i}s" | tr ' ' '=')
      # Move the cursor back 14 spaces (10 for '#' + 3 for percentage + 1 for space), then print the bar, then print the progress percent
      percent=$(python -c "print(int(($i/$length)*100))")
      printf "\r[%-${length}s] %3d%%" "$bar" "$percent"
    done
    echo "\n"
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