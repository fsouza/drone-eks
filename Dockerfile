FROM golang:1.11-alpine AS build

RUN apk add --no-cache git
ADD . /code

WORKDIR /code
ENV CGO_ENABLED 0
RUN go build -o /bin/drone-eks

FROM python:3-alpine


RUN pip3 install awscli

ENV KUBECTL_VERSION v1.12.2
ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /bin/kubectl

ENV AWS_IAM_AUTHENTICATOR_VERSION 0.4.0-alpha.1
ADD https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/${AWS_IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64 /bin/aws-iam-authenticator

RUN chmod +x /bin/kubectl /bin/aws-iam-authenticator

COPY --from=build /bin/drone-eks /bin/drone-eks

ENTRYPOINT ["/bin/drone-eks"]
