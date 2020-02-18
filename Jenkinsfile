import groovy.json.JsonOutput

node {
  def pom, version

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
    withMaven(jdk: 'JDK8u121', maven: 'M3', mavenSettingsConfig: 'nexus-settings') {
      sh 'mvn clean install'
    }
  }
}
