#!/bin/bash
# lists the profile names in ~/.aws/config
__aws_profiles() {
  sed -n 's/^\[profile \([^]]*\)\].*/\1/p' ~/.aws/config 2>/dev/null
}

# AWS profile stuff - allows you to specify the aws-profile you wish to use - just sets an env var
aws-profile() {
  if [ -z "${1}" ]
  then # Blankville
    echo "No profile specified - select from:";
    __aws_profiles
  else
    if ! __aws_profiles | grep -qxF -- "${1}"
    then # Not found?? list the ones we have
      echo "Profile not found, select from:";
      __aws_profiles
    else # coolzies - found one, here the login just to be smug
      export AWS_PROFILE="${1}";
      echo "selected profile: ${1} - account sts id";
      aws sts get-caller-identity
    fi
  fi
}

# uses the ~/.aws/config file as a source for auto-complete with the above command
# requires the config file to be populated.

_aws-profile_completions() {
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  local ACCOUNTS
  ACCOUNTS=$(__aws_profiles)
  mapfile -t COMPREPLY < <(compgen -W "${ACCOUNTS}" -- "${COMP_WORDS[1]}")
}

complete -F _aws-profile_completions aws-profile

# assumes a role in the CLI based on params account number, role, session name (optional)
aws-assume-role() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "usage: aws-assume-role <account-number> <role-name> [session-name]"
    return 1
  fi
  local CREDS SESSION="${3:-myCoolSession}"
  CREDS=$(aws sts assume-role \
    --role-arn "arn:aws:iam::${1}:role/${2}" \
    --role-session-name "${SESSION}" \
    --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
    --output text) || { echo "assume-role failed - credentials unchanged"; return 1; }
  read -r AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< "${CREDS}"
  export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  export ASSUME_ROLE_ACCOUNT="$1"
  export ASSUME_ROLE_ROLE="$2"
  export ASSUME_ROLE_SESSION="${SESSION}"
}

# AWS SSO useage - get the sso access token
aws-access-token() {
  local f
  for f in ~/.aws/sso/cache/*.json; do
    [[ "$f" == *botocore* ]] || cat "$f"
  done | jq -r "{accessToken} | .[] | select ( . != null)"
}

# AWS SSO useage - lists SSO accounts
aws-list-accounts() {
  aws sso list-accounts --access-token "$(aws-access-token)" --output table
}
