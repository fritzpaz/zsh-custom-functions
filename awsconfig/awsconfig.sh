# line_width=50

# function check_aws_sso_session() {
#   # Check AWS SSO session validity
#   if aws sts get-caller-identity --output json >/dev/null 2>&1; then
#     # Determine the size of our content
#     content="\033[38;5;208m$AWS_PROFILE ❯\033[0m Active AWS SSO session."
#     text_width=$((${#AWS_PROFILE} + 28))

#     # Calculate padding
#     padding=$((line_width - text_width))
#     if ((padding % 2 == 0)); then
#       padding=$((padding / 2))
#     else
#       padding=$(((padding) / 2))
#       line_width=$((line_width - 1))
#     fi

#     # Generate the box
#     echo -e "\033[1;36m┌$(printf '─%.0s' $(seq 1 $((line_width - 2))))┐\033[0m"
#     echo -e "\033[1;36m│\033[0m$(printf ' %.0s' $(seq 1 $padding))$content$(printf ' %.0s' $(seq 1 $padding))\033[1;36m│\033[0m"
#   else
#     content="\033[38;5;208m$AWS_PROFILE ❯\033[0m Invalid AWS SSO session."
#     text_width=$((${#AWS_PROFILE} + 28))

#     # Calculate padding
#     padding=$((line_width - text_width))
#     if ((padding % 2 == 0)); then
#       padding=$((padding / 2))
#       line_width=$((line_width + 1))
#     else
#       padding=$(((padding) / 2))
#     fi

#     # Generate the box
#     echo -e "\033[1;36m┌$(printf '─%.0s' $(seq 1 $((line_width - 2))))┐\033[0m"
#     echo -e "\033[1;36m│\033[0m$(printf ' %.0s' $(seq 1 $padding))$content$(printf ' %.0s' $(seq 1 $padding))\033[1;36m│\033[0m"
#   fi
  
#   echo -e "\033[1;36m└$(printf '─%.0s' $(seq 1 $((line_width - 2))))┘\033[0m"
# }


# function initialize_aws_profile() {
#   local aws_credentials_file="$HOME/.aws/credentials"

#   # Check if the default profile exists in the credentials file
#   local is_default_exists=$(grep "^\[default\]" "$aws_credentials_file")

#   if [ -n "$is_default_exists" ]; then
#     # If default profile exists, then set AWS_PROFILE to "default".
#     export AWS_PROFILE=default
#   else
#     # If default does not exist, then set AWS_PROFILE to the value in [last-sso]
#     local last_sso_profile=$(grep -A1 "^\[last-sso\]" "$aws_credentials_file" | grep "profile_name" | cut -d '=' -f 2 | tr -d '[:space:]')
#     if [ -n "$last_sso_profile" ]; then
#       export AWS_PROFILE="$last_sso_profile"

#       # Check if the AWS SSO session is active
#       if ! check_aws_sso_session; then
#         # If the session is not active, ask the user if they want to login
#         echo -e "\033[1;36m│\033[0m ℹ️  Tip: Run \033[1;96mawsconfig login\033[0m to authenticate.  \033[1;36m│\033[0m"
#         echo -e "\033[1;36m└────────────────────────────────────────────────┘\033[0m"
#       fi
#     else
#       return 1
#     fi
#   fi
# }


function check_aws_sso_session() {
  # Check AWS SSO session validity
  if aws sts get-caller-identity --output json >/dev/null 2>&1; then
    content="\e[38;5;234m\uE0B6\e[48;5;234m\e[38;5;208m  $AWS_PROFILE ❯  \e[38;5;255mAWS SSO session \e[38;5;82mactive \e[49m\e[38;5;234m\uE0B4\e[0m"
    echo -e "$content"
    return 0
  else
    content="\e[38;5;234m\uE0B6\e[48;5;234m\e[38;5;208m  $AWS_PROFILE ❯  \e[38;5;255mAWS SSO session \e[38;5;196minvalid \e[49m\e[38;5;234m\uE0B4\e[0m"
    echo -e "$content"
    return 1
  fi
}




function initialize_aws_profile() {
  local aws_credentials_file="$HOME/.aws/credentials"

  # Check if the default profile exists in the credentials file
  local is_default_exists=$(grep "^\[default\]" "$aws_credentials_file")

  if [ -n "$is_default_exists" ]; then
    # If default profile exists, then set AWS_PROFILE to "default".
    export AWS_PROFILE=default
  else
    # If default does not exist, then set AWS_PROFILE to the value in [last-sso]
    local last_sso_profile=$(grep -A1 "^\[last-sso\]" "$aws_credentials_file" | grep "profile_name" | cut -d '=' -f 2 | tr -d '[:space:]')
    if [ -n "$last_sso_profile" ]; then
      export AWS_PROFILE="$last_sso_profile"

      # Check if the AWS SSO session is active
      if ! check_aws_sso_session; then
        # If the session is not active, inform the user to run the login command
        echo -e " ℹ️  \033[96mawsconfig login"
      fi
      echo ""
    else
      return 1
    fi
  fi
}


function awsconfig() {
  local aws_credentials_file="$HOME/.aws/credentials"
  local aws_config_file="$HOME/.aws/config"
  local terragrunt_login_profile="bubbe-dev"

  if [ "$#" -lt 1 ]; then
    echo "Usage: awsconfig <command> [options]"
    echo ""
    echo "Available commands:"
    echo "  <profile>              Set the default AWS profile to the specified IAM or SSO profile name."
    echo "  list                   List available AWS IAM and SSO profiles."
    echo "  show <profile>         Display details for a specified IAM or SSO profile."
    echo "  login <profile>        Attempt to log in using the specified profile. If no profile is specified, uses AWS_PROFILE."
    echo "  logout                 Log out of the current AWS SSO session."
    echo "  config | credentials   Open the ~/.aws/ directory."
    echo ""
    echo "For more information on a specific command, use:"
    echo "  awsconfig <command> --help\n"
    return 1
  fi

  local command=$1

  if [ "$command" = "list" ]; then
    echo "----- Available AWS IAM profiles -----"
    grep '^\[' $aws_credentials_file | grep -v '^\[last-sso\]' | tr -d '[]'
    echo "\n----- Available AWS SSO profiles -----"
    grep '^\[profile ' $aws_config_file | tr -d '[]' | sed 's/profile //'
    echo ''
    return 0
  fi

  if [ "$command" = "logout" ]; then
      aws sso logout
      echo "Logged out."
      return 0
  fi

  if [ "$command" = "login" ]; then
      setopt LOCAL_OPTIONS NO_NOMATCH
      local temp_file=$(mktemp)

      if [ -z "$AWS_PROFILE" ] && [ "$#" -lt 2 ]; then
          echo "Usage: awsconfig login [ profile ]"
          return 1
      elif [ ! -z "$AWS_PROFILE" ]; then
          profile_name=$AWS_PROFILE
      else
          profile_name=$2
      fi

      echo "Attempting to login using profile: [ $profile_name ]"

      # Switch profiles to allow smooth transition with terragrunt
      # and consistent cache key generation
      profile_name=$terragrunt_login_profile

      # Clear cache
      if [[ -d ~/.aws/cli/cache ]]; then
          /bin/rm -rf ~/.aws/cli/cache/
      fi

      if [[ -d ~/.aws/sso/cache ]]; then
          /bin/rm -rf ~/.aws/sso/cache/
      fi

      # Temporarily disable job control messages
      set +m

      # Run the command in the background and suppress all output, including job control messages.
      { aws sso login --profile $terragrunt_login_profile &> $temp_file; } &

      # Capture the PID of the background process.
      local bg_pid=$!

      local timeout=20
      local count=0

      while ! grep -q -E "(open the following URL|gio: https://)" $temp_file && [ $count -lt $timeout ]; do
          sleep 1
          ((count++))
      done

      sso_output=$(cat $temp_file)
      
      sso_base_url=$(echo "$sso_output" | grep -Eo 'https://[^/ ]+')
      sso_user_code=$(echo "$sso_output" | grep -A2 "Then enter the code:" | tail -1 | sed 's/^[ \t]*//;s/[ \t]*$//')

      if [ ! -z "$sso_user_code" ]; then
          sso_full_url="${sso_base_url}/?user_code=${sso_user_code}"
          echo "$sso_full_url"
          windows_chrome $bubbe_profile "$sso_full_url"
      else
          echo "Failed to extract the user code."
      fi

      # Wait for the specific background process to complete using its PID.
      wait $bg_pid

      if [ $? -eq 0 ]; then
          echo "Login successful!\n"
      else
          echo "Login failed. Use command:"
          echo "aws sso login --profile $profile_name\n"
      fi

      # Cleanup the temporary file.
      rm $temp_file

      # Re-enable job control
      set -m

      return 0
  fi

  if [ "$command" = "config" ]; then
      code ~/.aws/config
      return 0
  fi

  if [ "$command" = "credentials" ]; then
      code ~/.aws/credentials
      return 0
  fi


  if [ "$command" = "show" ]; then
      if [ "$#" -lt 2 ]; then
          echo "Usage: awsconfig show [ profile ]"
          profiles_iam=($(grep '^\[' $aws_credentials_file | grep -v '^\[last-sso\]$' | tr -d '[]'))
          profiles_sso=($(grep '^\[profile ' $aws_config_file | tr -d '[]' | sed 's/profile //'))

          printf "IAM Profiles: "
          printf "%s, " "${profiles_iam[@]}"
          echo -e "\b\b "
          printf "SSO Profiles: "
          printf "%s, " "${profiles_sso[@]}"
          echo -e "\b\b "
          echo ''
          return 1
      fi

      local profile_name=$2

      # If the user wants to show the default profile
      if [ "$profile_name" = "default" ]; then
          # Check if AWS_PROFILE is set and is different from default
          if [ ! -z "$AWS_PROFILE" ] && [ "$AWS_PROFILE" != "default" ]; then
              profile_name="$AWS_PROFILE"
          fi
      fi

      # Display details for IAM profiles
      if grep -q "\[$profile_name\]" $aws_credentials_file; then
          local aws_access_key_id=$(grep -A1 "\[$profile_name\]" $aws_credentials_file | grep "aws_access_key_id" | cut -d '=' -f 2 | tr -d ' ')
          local aws_secret_access_key=$(grep -A2 "\[$profile_name\]" $aws_credentials_file | grep "aws_secret_access_key" | cut -d '=' -f 2 | tr -d ' ')
          local region=$(grep -A3 "\[$profile_name\]" $aws_credentials_file | grep "region" | cut -d '=' -f 2- | tr -d ' ')

          echo "----- Profile [ $profile_name ] -----"
          echo "AWS Access Key ID: [${aws_access_key_id}]"
          echo "AWS Secret Access Key: [****************${aws_secret_access_key: -4}]"
          echo "Default region name: [$region]\n"

      # Display details for SSO profiles
      elif grep -q "\[profile $profile_name\]" $aws_config_file; then
          local sso_account_id=$(grep -A3 "\[profile $profile_name\]" $aws_config_file | grep "sso_account_id" | cut -d '=' -f 2 | tr -d ' ')
          local sso_role_name=$(grep -A4 "\[profile $profile_name\]" $aws_config_file | grep "sso_role_name" | cut -d '=' -f 2 | tr -d ' ')
          local sso_region=$(grep -A5 "\[profile $profile_name\]" $aws_config_file | grep "region" | cut -d '=' -f 2 | tr -d ' ')

          echo "----- SSO Profile [ $profile_name ] -----"
          echo "SSO Account ID: [$sso_account_id]"
          echo "SSO Role Name: [$sso_role_name]"
          echo "SSO Region: [$sso_region]\n"

      else
          echo "Profile $profile_name not found."
          return 1
      fi

      return 0
  fi

  if grep -q "\[$command\]" $aws_credentials_file; then
      # Profile is an IAM profile
      export AWS_PROFILE='default'

      local aws_access_key_id=$(grep -A1 "\[$command\]" $aws_credentials_file | grep "aws_access_key_id" | cut -d '=' -f 2 | tr -d ' ')
      local aws_secret_access_key=$(grep -A2 "\[$command\]" $aws_credentials_file | grep "aws_secret_access_key" | cut -d '=' -f 2 | tr -d ' ')
      local region=$(grep -A3 "\[$command\]" $aws_credentials_file | grep "region" | cut -d '=' -f 2- | tr -d ' ')

      # Remove the [default] section if it exists
      sed -i '/\[default\]/,/^$/d' $aws_credentials_file

      # Add or update the [default] section
      echo -e "[default]\naws_access_key_id = $aws_access_key_id\naws_secret_access_key = $aws_secret_access_key\nregion = $region" >> $aws_credentials_file

      echo "----- Default profile set to [ $command ] -----"
      echo "AWS Access Key ID: [****************${aws_access_key_id: -4}]"
      echo "AWS Secret Access Key: [****************${aws_secret_access_key: -4}]"
      echo "Default region name: [$region]\n"

  elif grep -q "\[profile $command\]" $aws_config_file; then
    # Profile is an SSO profile
    export AWS_PROFILE=$command

    # Remove the [default] section from .aws/credentials if it's present
    sed -i '/\[default\]/,/^$/d' $aws_credentials_file

    # Update the [last-sso] section with the current profile
    if grep -q "\[last-sso\]" $aws_credentials_file; then
      sed -i "/^\[last-sso\]/,/^\[/ { s|profile_name.*|profile_name = $command| }" $aws_credentials_file
    else
      echo -e "\n[last-sso]\nprofile_name = $command" >> $aws_credentials_file
    fi

    # Extracting SSO details from ~/.aws/config
    local sso_session=$(grep -A1 "\[profile $command\]" $aws_config_file | grep "sso_session" | cut -d '=' -f 2- | tr -d ' ')
    local sso_account_id=$(grep -A2 "\[profile $command\]" $aws_config_file | grep "sso_account_id" | cut -d '=' -f 2- | tr -d ' ')
    local sso_role_name=$(grep -A3 "\[profile $command\]" $aws_config_file | grep "sso_role_name" | cut -d '=' -f 2- | tr -d ' ')
    local sso_region=$(grep -A4 "\[profile $command\]" $aws_config_file | grep "region" | cut -d '=' -f 2- | tr -d ' ')

    echo "----- SSO Profile [ $command ] -----"
    echo "SSO Session: [$sso_session]"
    echo "SSO Account ID: [$sso_account_id]"
    echo "SSO Role Name: [$sso_role_name]"
    echo "SSO Region: [$sso_region]\n"
  else
    echo "Profile $command not found."
    return 1
  fi
}

initialize_aws_profile

alias awsprofile="awsconfig"
alias awsconfigs="awsconfig"
alias awsconfigure="awsconfig"
alias awsconfiguration="awsconfig"
alias awsconfigurations="awsconfig"
alias awscredentials="awsconfig"

alias aws-profile="awsconfig"
alias aws-config="awsconfig"
alias aws-configs="awsconfig"
alias aws-configure="awsconfig"
alias aws-configuration="awsconfig"
alias aws-configurations="awsconfig"
alias aws-credentials="awsconfig"
