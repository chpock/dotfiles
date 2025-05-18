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
    # Execute in subshell to suppress trace messages in this function, but leave
    # the default trace status in the original shell instance.
    (
        { set +x; } 2>/dev/null
        _maybe_local "aws"
        if [ -e "$IAM_HOME/state/on_aws_localstack" ]; then
            AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=${DEFAULT_REGION:-${AWS_DEFAULT_REGION:-eu-west-1}} \
                command aws --endpoint-url=http://${LOCALSTACK_HOST:-localhost}:4566 "$@"
        else
            command aws "$@"
        fi
    )
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
    region)
        local __AWS_REGION="$AWS_DEFAULT_REGION"
        if [ -n "$AWS_PROFILE" ] && [ -z "$__AWS_REGION" ]; then
            if [ -n "$2" ]; then
                aws configure set region "$2" --profile "$AWS_PROFILE"
                aws configure set default.region "$2" --profile "$AWS_PROFILE"
            fi
            __AWS_REGION="$(aws configure list 2>/dev/null | awk '$1 == "region" { print $2 }')"
            [ "$__AWS_REGION" != "<not" ] || __AWS_REGION=""
        else
            if [ -n "$2" ]; then
                AWS_DEFAULT_REGION="$2"
                __AWS_REGION="$2"
                export AWS_DEFAULT_REGION
            fi
        fi
        if [ -z "$__AWS_REGION" ]; then
            echo "Current AWS default region is not defined."
        else
            echo "Current AWS default region: $__AWS_REGION"
        fi
        ;;
    eks-update-kubeconfig)
        if [ -z "$2" ]; then
            echo "Error: EKS cluster name not specified"
            return 1
        fi
        (set -x; aws eks update-kubeconfig --name "$2")
        ;;
    ecr-auth-docker|ecr-auth-helm)
        local REGION
        local ECR_HOST
        local ACCOUNT
        local LOGIN_TARGET
        [ "$1" = "ecr-auth-docker" ] && LOGIN_TARGET="docker" || LOGIN_TARGET="helm registry"
        if [ -z "$2" ]; then
            if [ -z "$AWS_DEFAULT_REGION" ]; then
                echo "Error: the default AWS region is not configured"
                return 1
            fi
            REGION="$AWS_DEFAULT_REGION"
            if ! ACCOUNT="$(command aws sts get-caller-identity --query Account --output text 2>&1)"; then
                # Trim possible leading spaces
                ACCOUNT=${ACCOUNT#"${ACCOUNT%%[![:space:]]*}"}
                echo "Error retrieving AWS account: $ACCOUNT"
                return 1
            fi
            ECR_HOST="${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com"
        else
            ECR_HOST="$2"
            REGION="$(echo "$ECR_HOST" | cut -d. -f4)"
        fi
        (set -x; aws ecr get-login-password --region "$REGION" | $LOGIN_TARGET login --username AWS --password-stdin "$ECR_HOST")
        ;;
    unset-environment-variables)
        unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_DEFAULT_REGION AWS_PROFILE AWS_PROFILE_INACTIVE
        ;;
    profile)
        if [ "$2" = "-" ]; then
            unset AWS_PROFILE AWS_PROFILE_INACTIVE
        elif [ -n "$2" ]; then
            [ -z "$AWS_ACCESS_KEY_ID" ] && export AWS_PROFILE="$2" || AWS_PROFILE_INACTIVE="$2"
        fi
        if [ -n "$AWS_PROFILE" ]; then
            echo "Active AWS profile: $AWS_PROFILE"
        elif [ -n "$AWS_PROFILE" ]; then
            echo "Inactive AWS profile: $AWS_PROFILE_INACTIVE"
        else
            echo "There is no active/inactive profile"
        fi
        ;;
    update-profile)
        if [ -z "$AWS_PROFILE_INACTIVE" ]; then
            echo "Error: there is no inactive profile"
            return 1
        fi
        aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile "$AWS_PROFILE_INACTIVE"
        aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$AWS_PROFILE_INACTIVE"
        aws configure set aws_session_token "$AWS_SESSION_TOKEN" --profile "$AWS_PROFILE_INACTIVE"
        export AWS_PROFILE="$AWS_PROFILE_INACTIVE"
        unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE_INACTIVE
        ;;
    *)
        echo "Unknown command: '$1'"
        return 1
        ;;
    esac
}

__,aws() {

    if [ "$1" = "--install-completion" ]; then
        complete -F __,aws ,aws
        return
    fi

    local RESULT
    # These regions have been generate using the following oneliner:
    # aws ssm get-parameters-by-path --path /aws/service/global-infrastructure/regions --query 'Parameters[*].Value' --output text | tr '\n' ' ' | sed -r -e 's/\s+/ /g' -e 's/\s+$//'
    local AWS_AVAILABLE_REGIONS="ap-northeast-1 ap-southeast-5 ap-southeast-7 eu-central-1 eu-north-1 me-south-1 sa-east-1 us-gov-east-1 us-gov-west-1 us-west-1 ap-northeast-2 ap-northeast-3 ap-south-1 ap-southeast-3 cn-north-1 eu-south-1 eu-west-1 eu-west-3 il-central-1 us-east-2 af-south-1 ap-east-1 ap-south-2 ap-southeast-1 ap-southeast-2 ca-west-1 cn-northwest-1 eu-central-2 me-central-1 us-west-2 ap-southeast-4 ca-central-1 eu-south-2 eu-west-2 mx-central-1 us-east-1"

    local CUR="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()

    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=($(compgen -W "on off local remote role region eks-update-kubeconfig ecr-auth-docker ecr-auth-helm unset-environment-variables profile update-profile" -- "$CUR"))
        return
    fi

    local CMD="${COMP_WORDS[1]}"
    local VAR

    case "$CMD" in
    region)
        if [ $COMP_CWORD -eq 2 ]; then
            COMPREPLY=($(compgen -W "$AWS_AVAILABLE_REGIONS" -- "$CUR"))
            return
        fi
        ;;
    eks-update-kubeconfig)
        if [ $COMP_CWORD -eq 2 ]; then
            if ! RESULT="$(aws eks list-clusters --query 'clusters' --output text 2>&1)"; then
                # Trim possible leading spaces
                RESULT=${RESULT#"${RESULT%%[![:space:]]*}"}
                printf '\nError: %s' "$RESULT"
                COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
                return
            elif [ -z "$RESULT" ]; then
                RESULT="There are no EKS clusters in the selected AWS region."
                printf '\nError: %s' "$RESULT"
                COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
                return
            fi
            COMPREPLY=($(compgen -W "$RESULT" -- "$CUR"))
            return
        fi
        ;;
    ecr-auth-docker)
        if [ $COMP_CWORD -eq 2 ]; then
            printf '\nEnter the ECR host name here or leave it blank for automatic detection.'
            COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
            return
        fi
        ;;
    profile)
        if [ $COMP_CWORD -eq 2 ]; then
            COMPREPLY=($(compgen -W "$(aws configure list-profiles)" -- "$CUR"))
            return
        fi
    esac

    compopt -o default
    return

}

__,aws --install-completion

if _has aws_completer; then
    complete -C "$(command -v aws_completer)" aws
elif [ -x "/usr/local/aws/bin/aws_completer" ]; then
    complete -C '/usr/local/aws/bin/aws_completer' aws
fi

