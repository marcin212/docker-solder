FROM alpine:latest

# Download and install dependencies
RUN apk --no-cache add curl

# Add gfs for easier file upload
RUN curl -o /usr/local/bin/gfs -sSL "https://github.com/zlepper/gfs/releases/download/0.0.4/gfs-linux-x64" && chmod +x /usr/local/bin/gfs

COPY ./entrypoint.sh .

# Actually configure solder
ENTRYPOINT ["/entrypoint.sh"]