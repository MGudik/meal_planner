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
                sh "flutter channel stable"
                sh "flutter upgrade"
                sh "flutter config --enable-linux-desktop"
                sh "flutter doctor"
            }
        }
        stage('Compile to Linux') {
		   steps {
            sh "flutter build linux"
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
            archiveArtifacts artifacts: 'build/linux/x64/release/release-x64.tar.gz',
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
