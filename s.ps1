# Invoke-RestMethod -Uri "https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/${commitId}" -Method POST -ContentType "application/json" -Body "${payload}" -Headers @{Authorization=("Basic {0}" -f $gitHubApiToken)}

$ApiToken = 'sky-kshatriyan:695ab53fe8cc377efad224b7e32ada72435334db'
$Base64Token   =    [System.Convert]::ToBase64String([char[]]$ApiToken)
$Headers = @{
    Authorization=("Basic {0}" -f $gitHubApiToken)
}
$commitId = powershell label: 'RepoCommitID', returnStdout: true, script: '(git rev-parse HEAD).trim()'
$SDURI = "http://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/${commitId}"
$payload = @{
            state = 'state'
            context = 'context'
            description = 'description'
            target_url = 'targetUrl'
    }

Invoke-RestMethod -Headers $Headers -Method POST -Body $payload -Uri $SDURI


[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("sky-kshatriyan:695ab53fe8cc377efad224b7e32ada72435334db"))


                                                                  $SDToken = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("sky-kshatriyan:$gitHubApiToken"))
                                                                  $SDIRMParams   = @{
                                                                    Uri  =  "https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/${commitId}"
                                                                    Method = "POST"
                                                                    ContentType = \'application/json\'
                                                                    Headers = @{Authorization=(\'Basic {0}\' -f "$SDToken")}
                                                                    Body = "$payload"
                                                                  }
                                                                  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                                                                  Invoke-RestMethod @SDIRMParams | Out-Null



                                                                  $SDToken = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("sky-kshatriyan:$gitHubApiToken"))
                                                                  $SDIRMParams  = @{
                                                                    Uri         =  
                                                                    Method      = 'POST'
                                                                    ContentType = 'application/json'
                                                                    Headers     = @{Authorization=('Basic {0}' -f $SDToken)}
                                                                    Body        = "$payload"
                                                                  }
                                                                  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                                                                  Write-Host $sdUri
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12                                                                  
Invoke-RestMethod -Uri https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/$commitId -Method 'POST' -ContentType 'application/json' -Headers @{Authorization=('Basic {0}' -f $SDToken)} -Body $payload



// Jenkinsfile
// Testing PR from MBPLJ

node {
  stage('pre-build') {
      checkout scm
  }
  stage('Build') {
    if (isUnix()) {
      withMaven(jdk: 'java180', maven: 'mvn362') {
          sh label: 'AEM_Prj', script: 'mvn clean'
      }
    }else {
      withMaven(jdk: 'java180', maven: 'mvn362') {
        bat label: 'AEM_Prj', script: 'mvn clean'
      }
    }
  }
}