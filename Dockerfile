# Dockerfile

FROM centos:7

# Install necessary packages
RUN yum update -y && \
    yum install -y https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm epel-release && \
    yum install -y gcc gzip xz-utils make cmake git curl rsync pkgconfig unzip autoconf automake libtool bison flex which gtk-update-icon-cache file
