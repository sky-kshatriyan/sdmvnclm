import groovy.json.JsonOutput

node {
  def commitId, commitDate, pom, version, sdUri
  def gitHubApiToken

  def postGitHub = { state, context, description, targetUrl = null ->
    def payload = JsonOutput.toJson(
            state: state,
            context: context,
            description: description,
            target_url: targetUrl
    )
    echo payload
 //    powershell label: 'RepoStatus', returnStdout: true, script: '''
 //    	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 //    	$SDToken = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("sky-kshatriyan:$gitHubApiToken"))
	// 	Invoke-RestMethod -Uri \'https://api.github.com/repos/sky-kshatriyan/sdmvnclm/statuses/\$commitId\' -Method \'POST\' -ContentType \'application/json\' -Headers @{Authorization=(\'Basic {0}\' -f '\$SDToken')} -Body '\$payload'
	// '''

  }

  stage('Preparation') {

    deleteDir()
    checkout scm
    commitId = powershell label: 'RepoCommitID', returnStdout: true, script: '''(git rev-parse HEAD).trim()'''
    sdUri = 'shashi'
    postGitHub 'pending', 'build', 'Build is running'  
    powershell script: '''
      echo '\$sdUri'
    '''
    pom = readMavenPom file: 'pom.xml'

    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'GitLab_Pass',
                      usernameVariable: 'GITHUB_API_USERNAME', passwordVariable: 'GITHUB_API_PASSWORD']]) {
      gitHubApiToken = env.GITHUB_API_PASSWORD
    }
  }

  // stage('Build') {
  //   postGitHub 'pending', 'build', 'Build is running'
  //   withMaven(jdk: 'JDK8u161', maven: 'M3', mavenSettingsConfig: 'nexus-settings') {
  //     bat 'mvn clean'
  //   }
  //   if (currentBuild.result == 'FAILURE') {
  //     postGitHub 'failure', 'build', 'Build failed'
  //     return
  //   } else {
  //     postGitHub 'success', 'build', 'Build succeeded'
  //   }    
  // }
}
