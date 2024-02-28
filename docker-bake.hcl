group "linux" {
  targets = [
    "oraclelinux9_jdk11",
    "oraclelinux9_jdk21",
    "oraclelinux8slim_jdk11",
    "oraclelinux8_jdk11"
 ]
}

group "linux-arm64" {
  targets = [
    "debian_jdk11",
    "debian_jdk21",
    "debian_jdk17",
  ]
}

group "linux-s390x" {
  targets = [
    "debian_jdk11",
    "debian_jdk21",
  ]
}

group "linux-ppc64le" {
  targets = [
    "debian_jdk11",
    "debian_jdk21",
    "debian_jdk17",
  ]
}

variable "REGISTRY" {
  default = "localhost:5000"
}

variable "JENKINS_REPO" {
  default = "jenkins/ssh-agent"
}

variable "ON_TAG" {
  default = "false"
}

variable "VERSION" {
  default = ""
}

target "alpine_jdk17" {
  dockerfile = "17/alpine/Dockerfile"
  context = "."
  tags = [
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}-alpine-jdk17": "",
    "${REGISTRY}/${JENKINS_REPO}:alpine-jdk17",
    "${REGISTRY}/${JENKINS_REPO}:latest-alpine-jdk17",
  ]
  platforms = ["linux/amd64"]
}

target "alpine_jdk11" {
  dockerfile = "11/alpine/Dockerfile"
  context = "."
  tags = [
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}-alpine-jdk11": "",
    "${REGISTRY}/${JENKINS_REPO}:alpine",
    "${REGISTRY}/${JENKINS_REPO}:alpine-jdk11",
    "${REGISTRY}/${JENKINS_REPO}:latest-alpine-jdk11",
  ]
  platforms = ["linux/amd64"]
}


target "oraclelinux8_jdk11" {
  dockerfile = "11/oraclelinux/ol8/Dockerfile"
  context = "."
  tags = [
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}": "",
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}-jdk11": "",
    "${REGISTRY}/${JENKINS_REPO}:oraclelinux8-jdk11"
  ]
  platforms = ["linux/amd64", "linux/arm64", "linux/s390x", "linux/ppc64le"]
}

target "oraclelinux8slim_jdk11" {
  dockerfile = "11/oraclelinux/ol8slim/Dockerfile"
  context = "."
  tags = [
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}": "",
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}-jdk11": "",
    "${REGISTRY}/${JENKINS_REPO}:oraclelinux8slim-jdk11"
  ]
  platforms = ["linux/amd64", "linux/arm64", "linux/s390x", "linux/ppc64le"]
}

target "oraclelinux9_jdk11" {
  dockerfile = "11/oraclelinux/ol9slim/Dockerfile"
  context = "."
  tags = [
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}": "",
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}-jdk11": "",
    "${REGISTRY}/${JENKINS_REPO}:oraclelinux9-jdk11"
  ]
  platforms = ["linux/amd64", "linux/arm64", "linux/s390x", "linux/ppc64le"]
}


target "oraclelinux9_jdk21" {
  dockerfile = "21/oraclelinux/ol9slim/Dockerfile"
  context = "."
  tags = [
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}": "",
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}-jdk21": "",
    "${REGISTRY}/${JENKINS_REPO}:oraclelinux9-jdk21"
  ]
  platforms = ["linux/amd64", "linux/arm64", "linux/s390x", "linux/ppc64le"]
}

target "debian_jdk11" {
  dockerfile = "11/bullseye/Dockerfile"
  context = "."
  tags = [
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}": "",
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}-jdk11": "",
    "${REGISTRY}/${JENKINS_REPO}:bullseye-jdk11",
    "${REGISTRY}/${JENKINS_REPO}:jdk11",
    "${REGISTRY}/${JENKINS_REPO}:latest",
    "${REGISTRY}/${JENKINS_REPO}:latest-bullseye-jdk11",
    "${REGISTRY}/${JENKINS_REPO}:latest-jdk11",
  ]
  platforms = ["linux/amd64", "linux/arm64", "linux/s390x", "linux/ppc64le"]
}

target "debian_jdk17" {
  dockerfile = "17/bullseye/Dockerfile"
  context = "."
  tags = [
    equal(ON_TAG, "true") ? "${REGISTRY}/${JENKINS_REPO}:${VERSION}-jdk17": "",
    "${REGISTRY}/${JENKINS_REPO}:bullseye-jdk17",
    "${REGISTRY}/${JENKINS_REPO}:jdk17",
    "${REGISTRY}/${JENKINS_REPO}:latest-bullseye-jdk17",
    "${REGISTRY}/${JENKINS_REPO}:latest-jdk17",
  ]
  platforms = ["linux/amd64", "linux/arm64", "linux/ppc64le"]
}
