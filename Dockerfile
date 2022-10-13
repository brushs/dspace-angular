# This image will be published as dspace/dspace-angular
# See https://github.com/DSpace/dspace-angular/tree/main/docker for usage details

FROM node:14-alpine as build

# make sure the package repository is up to date
RUN apk update \
 && apk upgrade \
 && apk add bash \
 && rm -rf /var/cache/*/* \
 && echo "" > /root/.ash_history

# change default shell from ash to bash
RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

ENV LC_ALL=en_US.UTF-8

ARG TEST_ARG=testArgument
RUN echo "Test Arg: " || $TEST_ARG

WORKDIR /app
ADD . /app/

# We run yarn install with an increased network timeout (5min) to avoid "ESOCKETTIMEDOUT" errors from hub.docker.com
# See, for example https://github.com/yarnpkg/yarn/issues/5540
RUN yarn install --network-timeout 300000
ARG TARGET_ENV
RUN echo "Target Env: " || $TARGET_ENV
ENV NODE_ENV $TARGET_ENV
RUN yarn run set-env
ENV NODE_ENV $BUILD_ENV
RUN yarn run build

# Use second image to serve output
# Use official nginx image as the base image
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=build /app/dist/browser /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx

# Install OpenSSH and set the password for root to "Docker!"
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
  && apt-get install -y --no-install-recommends openssh-server \
  && echo "$SSH_PASSWD" | chpasswd

# Copy the sshd_config file to the /etc/ssh/ directory
COPY sshd_config /etc/ssh/

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY ssh_setup.sh /tmp
RUN sed -i 's/\r//g' /tmp/ssh_setup.sh
RUN chmod +x /tmp/ssh_setup.sh \
    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

# Expose
EXPOSE 4000 2222

# On startup, run in DEVELOPMENT mode (this defaults to live reloading enabled, etc).
# Listen / accept connections from all IP addresses.
# NOTE: At this time it is only possible to run Docker container in Production mode
# if you have a public IP. See https://github.com/DSpace/dspace-angular/issues/1485

CMD /usr/sbin/sshd && nginx -g 'daemon off;'
