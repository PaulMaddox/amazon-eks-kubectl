FROM alpine:latest

ADD https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64 /usr/local/bin/aws-iam-authenticator
ADD kubectl.sh /usr/local/bin/kubectl.sh

RUN set -x && \
    \
    apk add --update --no-cache curl ca-certificates python py-pip jq && \
    chmod +x /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl.sh && \
    chmod +x /usr/local/bin/aws-iam-authenticator && \
    \
    # Create non-root user (with a randomly chosen UID/GUI).
    adduser kubectl -Du 2342 && \
    \
    # Install AWS CLI
    pip install --upgrade awscli && \
    # Basic check it works.
    aws --version && kubectl version --client

USER kubectl
ENTRYPOINT [ "/usr/local/bin/kubectl.sh" ]

