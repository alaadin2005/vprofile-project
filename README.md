<<<<<<< HEAD
# Prerequisites
#######
- JDK 11 
- Maven 3 
- MySQL 8

# Technologies 
- Spring MVC
- Spring Security
- Spring Data JPA
- Maven
- JSP
- Tomcat
- MySQL
- Memcached
- Rabbitmq
- ElasticSearch
# Database
Here,we used Mysql DB 
sql dump file:
- /src/main/resources/db_backup.sql
- db_backup.sql file is a mysql dump file.we have to import this dump to mysql db server
- > mysql -u <user_name> -p accounts < db_backup.sql

# Project Title

🚀 CI Pipeline with Jenkins, SonarQube, Nexus & Slack Notifications

📘 Overview

This repository demonstrates an automated Continuous Integration (CI) pipeline using modern DevOps tools.
The pipeline ensures:

Automated build & test workflow

Static code analysis and quality gate checks

Centralized artifact storage

Real-time notifications to the development team

Faster feedback loops and improved code quality

🏗️ Pipeline Architecture
Developer → GitHub → Jenkins Pipeline
             ↓
        SonarQube (Quality Scan)
             ↓
         Maven Build & Test
             ↓
         Nexus (Artifact Repo)
             ↓
 Slack (Success / Failure Alerts)

🔧 Tools & Technologies
Tool	Purpose
Jenkins	Automates CI workflow
SonarQube	Static code analysis & quality gates
Nexus Repository Manager	Stores built artifacts
Slack	Build status notifications
Maven	Build and dependency management
GitHub	Version control repository
Java 17	Application language
📂 Jenkins Pipeline Stages
1. Checkout Code

Pulls code from GitHub.

2. Build with Maven

Runs:

mvn clean install

3. Static Code Analysis (SonarQube)

Runs:

mvn sonar:sonar

4. Quality Gate Check

Fail pipeline if SonarQube quality gate fails.

5. Publish Artifacts to Nexus

Runs:

mvn deploy


Artifacts are pushed to:

/nexus/repository/releases
/nexus/repository/snapshots

6. Slack Notifications

Notifies success/failure in Slack channel.

🧩 Jenkinsfile (Declarative Pipeline)
def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]
pipeline {
	agent any
	tools {
	    maven "MAVEN3.9"
	    jdk "JDK17"
	}

	stages {

		stage('test slack'){
			steps{
				sh 'NotARealCommand'

			}
		}
	    stage('Fetch code') {
            steps {
               git branch: 'atom', url: 'https://github.com/hkhcoder/vprofile-project.git'
            }

	    }


	    stage('Build'){
	        steps{
	           sh 'mvn install -DskipTests'
	        }

	        post {
	           success {
	              echo 'Now Archiving it...'
	              archiveArtifacts artifacts: '**/target/*.war'
	           }
	        }
	    }

	    stage('UNIT TEST') {
            steps{
                sh 'mvn test'
            }
        }

        stage('Checkstyle Analysis') {
            steps{
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage("Sonar Code Analysis") {
        	environment {
                scannerHome = tool 'sonar6.2'
            }
            steps {
              withSonarQubeEnv('sonarserver') {
                sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
              }
            }
        }

        stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
          }

	     stage("UploadArtifact"){
            steps{
                nexusArtifactUploader(
                  nexusVersion: 'nexus3',
                  protocol: 'http',
                  nexusUrl: '172.31.25.14:8081',
                  groupId: 'QA',
                  version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                  repository: 'vprofile-repo',
                  credentialsId: 'nexuslogin',
                  artifacts: [
                    [artifactId: 'vproapp',
                     classifier: '',
                     file: 'target/vprofile-v2.war',
                     type: 'war']
                  ]
                )
            }
        }


	}

  post {
        always {
            echo 'Slack Notifications.'
            slackSend channel: '#devopscicd',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }

}

📦 Nexus Repository Structure
nexus-repository/
├── snapshots/
│     └── project-name-1.0-SNAPSHOT.jar
└── releases/
      └── project-name-1.0.0.jar

✔️ Prerequisites

Before running the pipeline ensure:

Jenkins

Pipeline plugin

Maven plugin

SonarQube plugin

Slack Notification plugin

Credentials configured (GitHub, Nexus, Slack, SonarQube token)

SonarQube

Server running

Project created

Authentication token generated

Nexus

Release & Snapshot repositories created

Slack

Webhook or Jenkins Slack plugin configured

🚀 How to Run the Pipeline

Add this Jenkinsfile to your repository.

Create a Jenkins Pipeline job → “Pipeline from SCM”.

Enter Git repo URL and branch.

Run build.

Check:

Jenkins console log

SonarQube dashboard

Nexus repo artifacts

Slack channel notifications

🎉 Conclusion

This CI pipeline provides:

Automated builds

Enforced code quality & security

Artifact versioning

Instant feedback to teams

A strong foundation for end-to-end CI/CD
