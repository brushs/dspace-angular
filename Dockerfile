# This image will be published as dspace/dspace-angular
# See https://github.com/DSpace/dspace-angular/tree/main/docker for usage details

FROM node:14-alpine as build

WORKDIR /app
ADD . /app/

# We run yarn install with an increased network timeout (5min) to avoid "ESOCKETTIMEDOUT" errors from hub.docker.com
# See, for example https://github.com/yarnpkg/yarn/issues/5540
RUN yarn install --network-timeout 300000
#RUN yarn run build
RUN node --max_old_space_size=8192 node_modules/@angular/cli/bin/ng build



# Use second image to serve output
FROM node:12-alpine

WORKDIR /app
COPY --from=build ./app /app

RUN apk add curl

# Install OpenSSH and set the password for root to "Docker!"
ENV SSH_PASSWD "root:Docker!"
RUN apk add --no-cache openssh \
    && echo "$SSH_PASSWD" | chpasswd

# Copy the sshd_config file to the /etc/ssh/ directory
COPY sshd_config /etc/ssh/

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY ssh_setup.sh /tmp
#RUN chmod +x /tmp/ssh_setup.sh \
#    && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null)

# Expose port 80
EXPOSE 4000 2222

# We run yarn install with an increased network timeout (5min) to avoid "ESOCKETTIMEDOUT" errors from hub.docker.com
# See, for example https://github.com/yarnpkg/yarn/issues/5540
RUN yarn install --network-timeout 300000

# On startup, run in DEVELOPMENT mode (this defaults to live reloading enabled, etc).
# Listen / accept connections from all IP addresses.
# NOTE: At this time it is only possible to run Docker container in Production mode
# if you have a public IP. See https://github.com/DSpace/dspace-angular/issues/1485
#CMD yarn serve --host 0.0.0.0
#CMD /usr/sbin/sshd && yarn run start:dev
#CMD /usr/sbin/sshd && yarn run serve
CMD yarn run serve
