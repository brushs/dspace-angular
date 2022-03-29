# This image will be published as dspace/dspace-angular
# See https://dspace-labs.github.io/DSpace-Docker-Images/ for usage details

FROM node:12-alpine as build

WORKDIR /app
ADD . /app/

# We run yarn install with an increased network timeout (5min) to avoid "ESOCKETTIMEDOUT" errors from hub.docker.com
# See, for example https://github.com/yarnpkg/yarn/issues/5540
RUN yarn install --network-timeout 300000
RUN yarn run build
#RUN node --max_old_space_size=8192 node_modules/@angular/cli/bin/ng build



# Use second image to serve output
#FROM node:12-alpine

# Use official nginx image as the base image
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=build /app/dist/browser /usr/share/nginx/html
#COPY --from=build /app/src/environments/environment.ts /usr/share/nginx

COPY ./nginx.conf /etc/nginx

#WORKDIR /app
#COPY --from=build ./app /app

#RUN apk add curl

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
CMD /usr/sbin/sshd && nginx -g 'daemon off;'
