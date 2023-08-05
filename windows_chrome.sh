function windows_chrome() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: windows_chrome [ profile | link ]"
    return 1
  fi

  local profile=$1
  local link=$2
  ( "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" --profile-directory="$profile" "$link" )
}

# Chrome profiles
source ~/.profiles_zshrc