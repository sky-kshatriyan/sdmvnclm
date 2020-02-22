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