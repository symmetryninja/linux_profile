#!/bin/bash
# AWS profile stuff - allows you to specify the aws-profile you wish to use - just sets an env var
aws-profile() {
  if [ -z ${1} ]
  then # Blankville
    echo "No profile specified - select from:";
    cat ~/.aws/config | grep profile  | cut -d " " -f2 | cut -d "]" -f1
  else
    if [ -z `cat ~/.aws/config | grep profile  | cut -d " " -f2 | cut -d "]" -f1 | grep ${1}` ]
    then # Not found?? list the ones we have
      echo "Profile not found, select from:";
      cat ~/.aws/config | grep profile  | cut -d " " -f2 | cut -d "]" -f1
    else # coolzies - found one, here the login just to be smug
      export AWS_PROFILE=${1};
      echo selected profile: ${1} - account sts id;
      echo `aws sts get-caller-identity`;
    fi
  fi
}

# uses the ~/.aws/config file as a source for auto-complete with the above command
# requires the config file to be populated.

_aws-profile_completions() {
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  ACCOUNTS=`cat ~/.aws/config | grep profile  | cut -d " " -f2 | cut -d "]" -f1`
  COMPREPLY=($(compgen -W "${ACCOUNTS}" "${COMP_WORDS[1]}"))
}

complete -F _aws-profile_completions aws-profile

# assumes a role in the CLI based on params account number, role, session name (optional)
aws-assume-role() {
  export ASSUME_ROLE_ACCOUNT=$1
  export ASSUME_ROLE_ROLE=$2
  export ASSUME_ROLE_SESSION="${3:-myCoolSession}"
  export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
    $(aws sts assume-role \
    --role-arn arn:aws:iam::${ASSUME_ROLE_ACCOUNT}:role/${ASSUME_ROLE_ROLE} \
    --role-session-name ${ASSUME_ROLE_SESSION} \
    --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
    --output text))
}

# AWS SSO useage - get the sso access token
aws-access-token() {
  cat $(ls -1d ~/.aws/sso/cache/* | grep -v botocore) |  jq -r "{accessToken} | .[] | select ( . != null)"
}

# AWS SSO useage - lists SSO accounts
aws-list-accounts() {
  aws sso list-accounts --access-token $(aws-access-token) --output table
}
