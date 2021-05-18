FROM golang:1.13-alpine

RUN apk --no-cache add alpine-sdk
WORKDIR /src

ADD hack/changelog.sh hack/changelog.sh
ADD hack/version.sh hack/version.sh

# Copy over dependency file and download it if files changed
# This allows build caching and faster re-builds
COPY go.mod  .
COPY go.sum  .
RUN go mod download

# Add rest of the source and build
COPY . .
RUN make all

# Copy to /opt/ so we can extract files later
RUN cp build/* /opt/