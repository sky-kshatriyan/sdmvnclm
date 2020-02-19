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
    	setBuildStatus ('Build', 'Building Project', 'Starting')
        bat "mvn $args -Dmaven.test.failure.ignore"
        if (currentBuild.result == 'FAILURE') {
	      setGitHubStatus ('failure', 'Build', 'Build failed')
	      return
	    } else {
	      setGitHubStatus ('success', 'Build', 'Build Successful')
	    }
	    setBuildStatus ('Build', 'Building Project', 'Completed')
    }
}

def getRepoSlug() {
    tokens = "${env.JOB_NAME}".tokenize('/')
    org = tokens[tokens.size()-3]
    repo = tokens[tokens.size()-2]
    return "${org}/${repo}"
}

void setGitHubStatus(state, targetUrl, description) {
    withCredentials([[$class: 'StringBinding', credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB_TOKEN']]) {
    	def commitId = powershell(returnStdout: true, script: "git rev-parse HEAD").trim()
        def payload = JsonOutput.toJson(["state": "${state}", "target_url": "${targetUrl}", "description": "${description}"])
        def apiUrl = "https://api.github.com/repos/${getRepoSlug()}/statuses/${commitId}"
        def response = powershell(returnStdout: true, script: "curl -s -H \"Authorization: Token ${env.GITHUB_TOKEN}\" -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '${payload}' ${apiUrl}").trim()
    }
}

void setBuildStatus(context, message, state) {
  step([
      $class: "GitHubCommitStatusSetter",
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: context],
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://api.github.com/repos/${getRepoSlug()}"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}