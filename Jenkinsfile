import groovy.json.JsonOutput
void postGitHub(state, context, description, targetUrl) {
    withCredentials([[$class: 'StringBinding', credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB_TOKEN']]) {
        def payload = JsonOutput.toJson(["state": "${state}", "context": "${context}", "description": "${description}", "target_url": "${targetUrl}"])
        def apiUrl = "https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/${commitId}"
        def response = powershell(returnStdout: true, script: "curl -s -H \"Authorization: Token ${env.GITHUB_TOKEN}\" -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '${payload}' ${apiUrl}").trim()
    }
}

node {
  def commitId, commitDate, pom, version
  def gitHubApiToken

  stage('Preparation') {

    deleteDir()
    checkout scm

    commitId = powershell label: 'RepoCommitID', returnStdout: true, script: '''(git rev-parse HEAD).trim()'''
    pom = readMavenPom file: 'pom.xml'

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
