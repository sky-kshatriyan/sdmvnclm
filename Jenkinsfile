// Jenkinsfile
// Testing PR from MBPLJ

node {
	stage('pre-build') {
    	checkout scm
	}
	stage('Build') {
		if (isUnix()) {
			sh label: 'AEM_Prj', script: 'mvn clean'
		}else {
			bat label: 'AEM_Prj', script: 'mvn clean'
		}
	}
}