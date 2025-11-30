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
pipeline {
    agent any

    tools {
        maven 'maven'
        jdk 'jdk17'
    }

    environment {
        SONARQUBE = 'sonarqube-server'
        SLACK_CHANNEL = '#devops-ci'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/example/project.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Code Analysis - SonarQube') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    sh "mvn sonar:sonar"
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Publish to Nexus') {
            steps {
                sh 'mvn deploy'
            }
        }
    }

    post {
        success {
            slackSend(channel: "${SLACK_CHANNEL}", 
                      message: "🎉 SUCCESS: Build Passed for ${env.JOB_NAME} #${env.BUILD_NUMBER}")
        }
        failure {
            slackSend(channel: "${SLACK_CHANNEL}", 
                      message: "❌ FAILURE: Build Failed for ${env.JOB_NAME} #${env.BUILD_NUMBER}")
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
