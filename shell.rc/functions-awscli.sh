#!/bin/bash

_has aws || return

aws() {
    case "$1" in
        on)
            touch "$IAM_HOME/state/on_aws"
        ;;
        off)
            rm -f "$IAM_HOME/state/on_aws"
        ;;
        *)
            command aws "$@"
        ;;
    esac
}

# one-liner:
# export ROLE=arn:aws:iam::<AWS ACCOUNT>:role/<AWS ROLE> && unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN && set -- $(SESS_NAME=$(hostname -s); set -x; aws sts assume-role --role-arn "$ROLE" --role-session-name $SESS_NAME --output text --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]') && unset ROLE && export AWS_ACCESS_KEY_ID="$1" && export AWS_SECRET_ACCESS_KEY="$2" && export AWS_SESSION_TOKEN="$3" && export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}" && set --
aws_role() {
    if [ -z "$1" ]; then
        echo "Usage: aws_role <role ARN>"
        echo
        echo "Example: aws_role arn:aws:iam::<AWS ACCOUNT>:role/<AWS ROLE>"
        exit 1
    fi
    echo "Assume role: $1"
    if [ -n "$AWS_SESSION_TOKEN" ]; then
        unset AWS_SESSION_TOKEN
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
    fi
    export __ROLE="$1"
    export __SESS_NAME="$(hostname -s)"
    set -- $(set -x; aws sts assume-role --role-arn "$__ROLE" --role-session-name $__SESS_NAME --output text --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]')
    unset __ROLE
    unset __SESS_NAME
    export AWS_ACCESS_KEY_ID="$1"
    export AWS_SECRET_ACCESS_KEY="$2"
    export AWS_SESSION_TOKEN="$3"
    export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
    set --
}

if [ -x "/usr/local/aws/bin/aws_completer" ]; then
    complete -C '/usr/local/aws/bin/aws_completer' aws
elif _has aws_completer; then
    complete -C "$(command -v aws_completer)" aws
fi

