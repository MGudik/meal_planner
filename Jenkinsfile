pipeline {
    agent {
        label 'docker-agent-flutter'
    }
    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '3', daysToKeepStr: '3', artifactNumToKeepStr: '3', artifactDaysToKeepStr: '3'))
    }
    triggers {
        pollSCM('')
    }
    stages {
        stage('Setup & Configure') {
            steps {
                sh "flutter doctor"
            }
        }
        stage('Compile to Linux') {
		   steps {
            sh "flutter build linux -v --release"
            } 
		}
        stage('Compile to Android') {
		   steps {
            sh "flutter build apk -v --release"
            } 
		}
        stage('Create image') {
		   steps {
                sh "cd build/linux/x64/release && tar -czvf release-x64.tar.gz bundle"
		    }
		}
    }
    post {
        success {
            archiveArtifacts artifacts: 'build/linux/x64/release/release-x64.tar.gz, build/app/outputs/flutter-apk/app-release.apk',
                                allowEmptyArchive: false,
                                caseSensitive: true,
                                fingerprint: false,
                                defaultExcludes: true,
                                followSymlinks: true,
                                onlyIfSuccessful: true

        }
        failure {
            echo "Failed!"
        }
        cleanup {
            echo "Done!"
        }
    }
}
