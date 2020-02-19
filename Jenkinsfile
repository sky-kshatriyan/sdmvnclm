import groovy.json.JsonOutput


node {
  sdPreperation()
  sdBuild()
  // sdNexusLifeCycleCheck()
  // sdDeploy()
}

def sdPreperation () {
	stage 'Prepare the Build'
	context="Preparing to Build"
	checkout scm
	setBuildStatus ("${context}", 'Checkout Completed', 'Success')
}

def sdBuild () {
	stage 'Build'
	mvn 'clean install -DskipTests=true -Dmaven.javadoc.skip=true -Dcheckstyle.skip=true -B -V'
}

def mvn(args) {
    withMaven(
        jdk: 'JDK8u161', 
        maven: 'M3', 
        mavenSettingsConfig: 'nexus-settings'
        ) {
    	  def commitId = getCommitId()
        sdPostgitHubStatus.statusUpdate commitId, 'pending', 'Build', 'Build Process Starting'
        bat "mvn $args -Dmaven.test.failure.ignore"
        if (currentBuild.result == 'FAILURE') {
	      sdPostgitHubStatus.statusUpdate commitId, 'failure', 'Build', 'Build Failed'
	      return
	    } else {
	      sdPostgitHubStatus.statusUpdate commitId, 'pending', 'Build', 'Build Passed'
	    }
    }
}

String getCommitId() {
  return runSafely ('git rev-parse HEAD', true)
}

String apiToken = null
withCredentials([[$class          : 'UsernamePasswordMultiBinding', credentialsId: 'GitLab_Pass',
                  usernameVariable: 'GITHUB_API_USERNAME', passwordVariable: 'GITHUB_API_PASSWORD']]) {
  apiToken = env.GITHUB_API_PASSWORD
}
GitHub sdPostgitHubStatus = new GitHub(this, 'jenkinsci/nexus-platform-plugin', apiToken)
Closure postHandler = {
  currentBuild, env ->
    def commitId = getCommitId()
    if (currentBuild.currentResult == 'SUCCESS') {
      sdPostgitHubStatus.statusUpdate commitId, 'success', 'CI', 'CI Passed'
    }
    else {
      sdPostgitHubStatus.statusUpdate commitId, 'failure', 'CI', 'CI Failed'
    }
}

// def getRepoSlug() {
//     tokens = "${env.JOB_NAME}".tokenize('/')
//     org = tokens[tokens.size()-3]
//     repo = tokens[tokens.size()-2]
//     return "${org}/${repo}"
// }

// void setGitHubStatus(state, targetUrl, description) {
//     withCredentials([usernamePassword(credentialsId: 'GitLab_Pass', passwordVariable: 'GITHUB_API_PASSWORD', usernameVariable: 'GITHUB_API_USERNAME')]) {
//     	def commitId = powershell(returnStdout: true, script: "git rev-parse HEAD").trim()
//       def payload = JsonOutput.toJson(["state": "${state}", "target_url": "${targetUrl}", "description": "${description}"])
//       def apiUrl = "https://api.github.com/repos/${getRepoSlug()}/statuses/${commitId}"
//       String apiUN = env.GITHUB_API_USERNAME
//       String apiPW = env.GITHUB_API_PASSWORD
//       // def sdToken = powershell(returnStdout:true, script: "[System.Convert]::ToBase64String([System.Text.Encoding]::Ascii.GetBytes(${apiUN}:${apiPW}))")
//       def response = powershell(returnStdout: true, script: "Invoke-WebRequest -Uri ${apiUrl} -Headers @{'Authorization'='Basic c2t5LWtzaGF0cml5YW46U2FyYWgxNDMq'} -ContentType 'application/json' -Method 'POST' -Body ${payload}").trim()
//     }
// }

// void setBuildStatus(context, message, state) {
//   step([
//       $class: "GitHubCommitStatusSetter",
//       contextSource: [$class: "ManuallyEnteredCommitContextSource", context: context],
//       reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://api.github.com/repos/${getRepoSlug()}"],
//       errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
//       statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
//   ]);
// }