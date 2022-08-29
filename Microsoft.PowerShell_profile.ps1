function Get-DockerProcessInfo () {
    [array]$results = [array](docker ps --format "{{json . }}" | convertfrom-json)
    return $results
  }
  
  function Start-GATechRunner ($Repository) {
    $imageName = "armyguy255a/github-runner:latest"
    docker pull $imageName
    docker run -e GH_PAT='<<put your PAT here>>' -e GH_OWNER='<<username>>' -e GH_REPOSITORY=$Repository -e GH_API_URL='https://github.gatech.edu/api/v3/repos' -e GH_URL='https://github.gatech.edu' --name $Repository -d $imageName
  }
  
  function Stop-GATechRunner ($Repository) {
    $dockerProcesses = Get-DockerProcessInfo 
    if ($dockerProcesses.Count -gt 1) {
      $dockerProcesses = $dockerProcesses | Where-Object $_.Names -eq $Repository
    }
    docker stop $dockerProcesses.ID && docker rm $dockerProcesses.ID
  }