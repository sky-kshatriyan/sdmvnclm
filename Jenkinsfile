// Jenkinsfile
// Testing PR from MBPLJ

node {
	stage('pre-build') {
    	checkout scm
	}
	stage('Build') {
		bat label: 'AEM_Prj', script: 'mvn clean'
	}
}