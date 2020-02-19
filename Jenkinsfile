import groovy.json.JsonOutput

node {
  def commitId, commitDate, pom, version, sdToken
  def gitHubApiToken

  def postGitHub = { state, context, description, targetUrl = null ->
    def payload = JsonOutput.toJson(
            state: state;
            context: context;
            description: description;
            target_url: targetUrl
    )
    
    powershell label: 'RepoStatus', returnStdout: true, script: """
    	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    	$sdToken = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("sky-kshatriyan:$gitHubApiToken"))
    	write-Host "$sdToken"
		IRM -Uri https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/$commitId -Method POST -ContentType application/json -Headers @{Authorization=(Basic {0} -f $sdToken)} -Body $payload
	"""

  }

  stage('Preparation') {

    deleteDir()
    checkout scm

    commitId = powershell label: 'RepoCommitID', returnStdout: true, script: '''(git rev-parse HEAD).trim()'''
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
