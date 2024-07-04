# Dockerfile

FROM centos:7

# Switch to working repositories
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
# Install necessary packages
RUN yum update -y && \
    yum install -y https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm epel-release && \
    yum install -y gcc gzip xz-utils make cmake git curl rsync pkgconfig unzip autoconf automake libtool bison flex which gtk-update-icon-cache file
