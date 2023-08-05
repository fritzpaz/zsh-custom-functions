function awsconfig() {
  local aws_credentials_file="$HOME/.aws/credentials"

  if [ "$#" -lt 1 ]; then
    echo "Usage: awsconfig [ profile | list | show ]"
    return 1
  fi

  local command=$1

  if [ "$command" = "list" ]; then
    echo "----- Available AWS profiles -----"
    grep '^\[' $aws_credentials_file | tr -d '[]'
    echo ''
    return 0
  fi

  if [ "$command" = "show" ]; then

    if [ "$#" -lt 2 ]; then
      echo "Usage: awsconfig show [ profile ]"
      profiles=($(grep '^\[' $aws_credentials_file | tr -d '[]'))
      printf "Profiles: "
      printf "%s, " "${profiles[@]}"
      echo -e "\b\b "  # Removes trailing comma and space
      echo ''
      return 1
    fi
    local profile_name=$2
    if ! grep -q "\[$profile_name\]" $aws_credentials_file; then
      echo "Profile $profile_name not found in $aws_credentials_file"
      return 1
    fi

    local aws_access_key_id=$(grep -A1 "\[$profile_name\]" $aws_credentials_file | grep "aws_access_key_id" | cut -d '=' -f 2 | tr -d ' ')
    local aws_secret_access_key=$(grep -A2 "\[$profile_name\]" $aws_credentials_file | grep "aws_secret_access_key" | cut -d '=' -f 2 | tr -d ' ')
    local region=$(grep -A3 "\[$profile_name\]" $aws_credentials_file | grep "region" | cut -d '=' -f 2- | tr -d ' ')

    echo "----- Profile [ $profile_name ] -----"
    echo "AWS Access Key ID: [${aws_access_key_id}]"
    echo "AWS Secret Access Key: [****************${aws_secret_access_key: -4}]"
    echo "Default region name: [$region]\n"
    return 0
  fi


  if ! grep -q "\[$command\]" $aws_credentials_file; then
    echo "Profile $command not found in $aws_credentials_file"
    return 1
  fi

  local aws_access_key_id=$(grep -A1 "\[$command\]" $aws_credentials_file | grep "aws_access_key_id" | cut -d '=' -f 2 | tr -d ' ')
  local aws_secret_access_key=$(grep -A2 "\[$command\]" $aws_credentials_file | grep "aws_secret_access_key" | cut -d '=' -f 2 | tr -d ' ')
  local region=$(grep -A3 "\[$command\]" $aws_credentials_file | grep "region" | cut -d '=' -f 2- | tr -d ' ')

  sed -i "/^\[default\]/,/^\[/ { s|aws_access_key_id.*|aws_access_key_id = $aws_access_key_id| }" $aws_credentials_file
  sed -i "/^\[default\]/,/^\[/ { s|aws_secret_access_key.*|aws_secret_access_key = $aws_secret_access_key| }" $aws_credentials_file
  sed -i "/^\[default\]/,/^\[/ { s|region.*|region = $region| }" $aws_credentials_file

  # Print the fetched values
  echo "----- Default profile set to [ $command ] -----"
  echo "AWS Access Key ID: [****************${aws_access_key_id: -4}]"
  echo "AWS Secret Access Key: [****************${aws_secret_access_key: -4}]"
  echo "Default region name: [$region]\n"
}