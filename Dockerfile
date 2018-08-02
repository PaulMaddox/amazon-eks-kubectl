FROM alpine:latest

ADD https://storage.googleapis.com/kubernetes-release/release/v1.11.1/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64 /usr/local/bin/aws-iam-authenticator
ADD kubeconfig /home/kubectl/.kube/config

RUN set -x && \
    \
    apk add --update --no-cache curl ca-certificates python py-pip jq && \
    chmod +x /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/aws-iam-authenticator && \
    \
    # Create non-root user (with a randomly chosen UID/GUI).
    adduser kubectl -Du 2342 && \
    \
    # Install AWS CLI
    pip install --upgrade awscli && \
    # Basic check it works.
    aws --version && kubectl version --client && \
    export EKS_ENDPOINT=$(aws eks describe-cluster --name ${CLUSTER} | jq -r .cluster.endpoint) && \
    export EKS_CA=$(aws eks describe-cluster --name ${CLUSTER} | jq -r .cluster.certificateAuthority.data) && \
    sed -i "s/%ENDPOINT%/${EKS_ENDPOINT}/g" /home/kubectl/.kube/config && \
    sed -i "s/%CA%/${EKS_CA}/g" /home/kubectl/.kube/config && \
    sed -i "s/%CLUSTER%/${CLUSTER}/g" /home/kubectl/.kube/config

USER kubectl
ENTRYPOINT [ "/usr/local/bin/kubectl" ]