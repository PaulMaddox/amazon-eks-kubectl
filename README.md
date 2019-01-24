# Amazon EKS kubectl

This is a convenient docker image that contains:

 - kubectl (v1.11.0)
 - aws-iam-authenticator (v0.3.0)
 - AWS CLI (v1.15.69)

The default entrypoint for this container, is a small wrapper script for `kubectl` that automatically populates a `~/.kube/config` with the correct EKS cluster details (endpoint, certificate authority).

## Usage

```bash
$ docker run -e CLUSTER=demo maddox/kubectl get services
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP        PORT(S)          AGE
kubernetes      ClusterIP      10.100.0.1     <none>             443/TCP          57d
```

You can also provide AWS credentials directly by providing environment variables to docker
```bash
docker run -e CLUSTER=master -e AWS_DEFAULT_REGION=<REGION> \
    -e AWS_ACCESS_KEY_ID=<ACCESS_KEY_ID> -e AWS_SECRET_ACCESS_KEY=<SECRET_KEY> \
    maddox/kubectl get pods
```

## AWS Credentials

The kubectl wrapper script used by this container uses the AWS CLI to fetch the necessary cluster details for the kube config file (api endpoint, certificate authority etc). 

The AWS CLI will automatically pick up AWS credentials from environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN`), the AWS credentials file (`~/.aws/credentials`), container credentials (ECS role) or EC2 instance role (in that order).

If you already have AWS credentials configured in `~/.aws/credentials` you can pass these through by running:

```
$ docker run -v ~/.aws:/home/kubectl/.aws -e CLUSTER=demo maddox/kubectl get services
```

