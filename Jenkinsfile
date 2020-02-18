import groovy.json.JsonOutput

node {
  def pom, version
  def gitHubApiToken

  def postGitHub = { state, context, description, targetUrl = null ->
    def payload = JsonOutput.toJson(
            state: state,
            context: context,
            description: description,
            target_url: targetUrl
    )
    
    powershell label: 'RepoStatus', script: 'Invoke-RestMethod -Uri "https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/${commitId}" -Method POST -ContentType "application/json" -Body "${payload}" -Headers @{Authorization=("Basic {0}" -f $gitHubApiToken)} | Out-Null'

  }

  stage('Preparation') {
    deleteDir()

    checkout scm

    pom = readMavenPom file: 'pom.xml'

    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'GitLab_Pass',
                      usernameVariable: 'GITHUB_API_USERNAME', passwordVariable: 'GITHUB_API_PASSWORD']]) {
      gitHubApiToken = env.GITHUB_API_PASSWORD
    }
  }
  stage('Build') {
    withMaven(jdk: 'JDK8u161', maven: 'M3', mavenSettingsConfig: 'nexus-settings') {
      bat 'mvn clean install'
    }
    if (currentBuild.result == 'FAILURE') {
      postGitHub 'failure', 'build', 'Build failed'
      return
    } else {
      postGitHub 'success', 'build', 'Build succeeded'
    }    
  }    
}
