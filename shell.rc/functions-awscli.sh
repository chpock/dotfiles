#!/bin/bash

_has aws || return

# In environments that are not in AWS EC2, requests to metadata must be disabled.
# Requests to http://169.254.169.254/ are completely useless there and can cause
# significant delays in requests to the AWS API, as they time out. Let's disable
# them if we have curl and don't have aws. We cannot rely only on the aws check,
# as this check depends on curl, and it is possible that this check returned FALSE
# when curl does not exist, even if the environment is on AWS EC2.
if _has curl && _isnot aws; then
    AWS_EC2_METADATA_DISABLED=true
    export AWS_EC2_METADATA_DISABLED
fi

aws() {
    case "$1" in
    on|off|local|remote|role)
        ,aws "$1"
        ;;
    *)
        if [ -e "$IAM_HOME/state/on_aws_localstack" ]; then
            AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=${DEFAULT_REGION:-${AWS_DEFAULT_REGION:-eu-west-1}} \
                command aws --endpoint-url=http://${LOCALSTACK_HOST:-localhost}:4566 "$@"
        else
            command aws "$@"
        fi
        ;;
    esac
}

,aws() {
    case "$1" in
    on) touch "$IAM_HOME/state/on_aws" ;;
    off) rm -f "$IAM_HOME/state/on_aws" ;;
    local) touch "$IAM_HOME/state/on_aws_localstack" ;;
    remote) rm -f "$IAM_HOME/state/on_aws_localstack" ;;
    role)
        # one-liner:
        # export ROLE=arn:aws:iam::<AWS ACCOUNT>:role/<AWS ROLE> && unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN && set -- $(SESS_NAME=$(hostname -s); set -x; aws sts assume-role --role-arn "$ROLE" --role-session-name $SESS_NAME --output text --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]') && unset ROLE && export AWS_ACCESS_KEY_ID="$1" && export AWS_SECRET_ACCESS_KEY="$2" && export AWS_SESSION_TOKEN="$3" && export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}" && set --
        if [ -z "$2" ]; then
            echo "Usage: ,aws role <role ARN>"
            echo
            echo "Example: ,aws role arn:aws:iam::<AWS ACCOUNT>:role/<AWS ROLE>"
            exit 1
        fi
        echo "Assume role: $2"
        if [ -n "$AWS_SESSION_TOKEN" ]; then
            unset AWS_SESSION_TOKEN
            unset AWS_ACCESS_KEY_ID
            unset AWS_SECRET_ACCESS_KEY
        fi
        set -- $(set -x; aws sts assume-role --role-arn "$2" --role-session-name "$(hostname -s)" \
            --output text --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]')
        export AWS_ACCESS_KEY_ID="$1"
        export AWS_SECRET_ACCESS_KEY="$2"
        export AWS_SESSION_TOKEN="$3"
        export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
        echo "Role assumption: ok"
        ;;
    esac
}

complete -W 'on off local remote role' ,aws

if [ -x "/usr/local/aws/bin/aws_completer" ]; then
    complete -C '/usr/local/aws/bin/aws_completer' aws
elif _has aws_completer; then
    complete -C "$(command -v aws_completer)" aws
fi


