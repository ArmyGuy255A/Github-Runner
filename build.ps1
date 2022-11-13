#This is used to manually build the container locally. Replace the tags appropriately
docker build --build-arg RUNNER_VERSION=2.285.1 --build-arg MAVEN_VERSION=3.8.6 --build-arg JDK_VERSION=17.0.4.1 --tag armyguy255a/github-runner:2.285.1 --tag armyguy255a/github-runner-maven:latest .
