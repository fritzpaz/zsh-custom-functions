zshrc() {
  case "$1" in
    "code" | "edit")
      local target=${2:-""}
      case "$target" in
        "public")
          cd $HOME/code/zshrc/zshrc_public
          code "$HOME/code/zshrc/zshrc_public"
          ;;
        "private")
          cd $HOME/code/zshrc/zshrc_private
          code "$HOME/code/zshrc/zshrc_private"
          ;;
        "p10k")
          cd "$HOME/code/zshrc"
          code "$HOME/code/zshrc"
          code "$HOME/.p10k.zsh"
          ;;
        "" | "zshrc")
          cd "$HOME/code/zshrc"
          code "$HOME/code/zshrc"
          code "$HOME/.zshrc"
          ;;
        *)
          echo "Invalid target for cd. Available targets: public, private, zshrc, p10k\n"
          return 1
          ;;
      esac
      ;;

    "source" | "reload")
      source "$HOME/.zshrc"
      length=48
      time_to_load=0.01
      
      # Calculating total iterations
      total_iterations=$(echo "$time_to_load*1000" | awk '{printf "%d", $1}')
      
      # Colors
      COLOR_BLUE="\033[1;36m"
      COLOR_GREEN="\033[1;32m"
      COLOR_RESET="\033[0m"

      echo -n -e "${COLOR_BLUE}[$(printf "%-${length}s" ' ')] 0%${COLOR_RESET}" # Initial empty bar and 0%

      for i in $(seq 1 $length); do
          sleep $(echo "$time_to_load/$length" | awk '{printf "%.5f", $1}')
          
          # Construct bar string using loop
          bar=""
          for j in $(seq 1 $i); do
              bar="${bar}▒"
          done
          
          # Calculate percentage
          percent=$(( (i * 100) / length ))
          
          # Calculate the number of spaces needed after the bar
          spaces_needed=$(( length - i ))
          for j in $(seq 1 $spaces_needed); do
              bar="${bar} "
          done

          # Print the progress bar with color
          printf "\r${COLOR_BLUE}[${COLOR_RESET}${COLOR_GREEN}%s${COLOR_BLUE}]${COLOR_RESET}${COLOR_GREEN} %3d%%${COLOR_RESET}" "$bar" "$percent"
      done
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
      echo "zshrc cd [public|private]   : Changes directory to the public or private zshrc files."
      echo "zshrc source | reload       : Reloads the .zshrc file."
      echo "zshrc git [public|private]  : Opens the git repository for the public or private zshrc files."
      echo "zshrc p10k                  : Opens the .p10k.zsh file in VS Code."
      echo ""
      ;;
  esac
}