import groovy.json.JsonOutput

node {
  def commitId, commitDate, pom, version
  def gitHubApiToken

  def postGitHub = { state, context, description, targetUrl = null ->
    def payload = JsonOutput.toJson(
            state: state,
            context: context,
            description: description,
            target_url: targetUrl
    )
    
    powershell label: 'RepoStatus', returnStdout: true, script: '''
                                                                  $SDToken = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("sky-kshatriyan:$gitHubApiToken"))
                                                                  $SDIRMParams  = @{
                                                                    Uri  =  "https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/${commitId}"
                                                                    Method = 'POST'
                                                                    ContentType = 'application/json'
                                                                    Headers = @{Authorization=('Basic {0}' -f $SDToken)}
                                                                    Body = "${payload}"
                                                                  }
                                                                  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                                                                  IWR @SDIRMParams
                                                                '''

  }

  stage('Preparation') {
    deleteDir()

    checkout scm
    commitId = powershell label: 'RepoCommitID', returnStdout: true, script: '''(git rev-parse HEAD).trim()'''
    commitDate = powershell label: 'RepoCommitDate', returnStdout: true, script: '''(git show -s --format=%cd --date=format:%Y%m%d%H-%M%S ${commitId}).trim()'''
    pom = readMavenPom file: 'pom.xml'

    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'GitLab_Pass',
                      usernameVariable: 'GITHUB_API_USERNAME', passwordVariable: 'GITHUB_API_PASSWORD']]) {
      gitHubApiToken = env.GITHUB_API_PASSWORD
    }
  }
  stage('Build') {
    postGitHub 'pending', 'build', 'Build is running'
    withMaven(jdk: 'JDK8u161', maven: 'M3', mavenSettingsConfig: 'nexus-settings') {
      bat 'mvn clean'
    }
    if (currentBuild.result == 'FAILURE') {
      postGitHub 'failure', 'build', 'Build failed'
      return
    } else {
      postGitHub 'success', 'build', 'Build succeeded'
    }    
  }    
}
