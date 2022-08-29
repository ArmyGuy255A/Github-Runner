# GitHub Runner

## Running this container
In order to run this container, you must specify 5 environment variables:
- GH_PAT=''
  - This is a PAT from your GitHub account. This PAT should have the following permissions:
    - SCOPE:REPO and READ:ORG
- GH_OWNER=''
  - This is your GitHub username
- GH_REPOSITORY=''
  - This is your GitHub Repository Name
- GH_API_URL=''
  - This is the URL to your GitHub API
- GH_URL=''
  - This is the base URL to your GitHub environment

Example:
```bash
docker run -e GH_PAT='asdf!@#' -e GH_OWNER='ArmyGuy255a' -e GH_REPOSITORY='GITRunner' -e GH_API_URL='https://github.com/api/v3/repos' -e GH_URL='https://github.com' armyguy255a/github-runner:latest
```

The full path of the GitHub URL would look something like this:

https://github.com/ArmyGuy255a/GITRunner

https://api.github.com/ArmyGuy255a/GITRunner/actions/runners/registration-token