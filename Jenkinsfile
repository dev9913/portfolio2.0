@Library('portfoliolib') _

pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timeout(time: 45, unit: 'MINUTES')
        timestamps()
    }

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: '3.0.0', description: 'Docker image tag')
    }

    environment {
        // APP_PASSWORD     = credentials('APP_PASSWORD')
        // DB_ROOT_PASSWORD = credentials('DB_ROOT_PASSWORD')
        // VAULT_BOOTSTRAP_TOKEN = credentials('VAULT_BOOTSTRAP_TOKEN')
        USER_EMAIL       = credentials('USER_EMAIL')
        USER_EMAIL_PASSWORD = credentials('USER_EMAIL_PASSWORD')
        BRANCH = "main"
        DOCKER_USER      = "dev7878"
        GIT_USER         = "dev9913"
    }

    stages {

        /* ================= ENV CHECK ================= */

        stage('Check Environment Variables') {
            steps {
                sh '''
                  [ -z "$APP_PASSWORD" ] && echo "APP_PASSWORD missing" && exit 1
                  [ -z "$DB_ROOT_PASSWORD" ] && echo "DB_ROOT_PASSWORD missing" && exit 1
                  [ -z "$VAULT_BOOTSTRAP_TOKEN" ] && echo "VAULT_BOOTSTRAP_TOKEN missing" && exit 1
                  [ -z "$USER_EMAIL" ] && echo "USER_EMAIL missing" && exit 1
                  [ -z "$USER_EMAIL_PASSWORD" ] && echo "USER_EMAIL_PASSWORD missing" && exit 1

                  echo "Credentials loaded successfully"
                '''
            }
        }

        stage('Git Checkout') {
            steps {
                script {
                    git_checkout("https://github.com/dev9913/portfolio2.0.git",BRANCH)
                }
            }
        }

        /* ================= DOCKER IMAGE BUILD ================= */

        stage('Docker Image Build') {
            when {
                branch 'main'
            }
            parallel {
                failFast true 

                stage('Build Frontend') {
                    steps {
                        script {
                            image_build("portfolio-frontend",params.IMAGE_TAG,DOCKER_USER,"frontend")
                        }
                    }
                }

                stage('Build Backend') {
                    steps {
                        script {
                            image_build("portfolio-backend",params.IMAGE_TAG,DOCKER_USER,"backend")
                        }
                    }
                }

                stage('Build Admin') {
                    steps {
                        script {
                            image_build("portfolio-admin",params.IMAGE_TAG,DOCKER_USER,"admin")
                        }
                    }
                }
            }
        }

		/* ================= DOCKER IMAGE SCAN ================= */

        stage('Docker Image Scan') {
            when {
                branch 'main'
            }
            parallel {
                failFast true 
                stage('Image Scan Frontend') {
                    steps {
                        script {
                            trivy_image_scan("frontend", params.IMAGE_TAG)
                        }
                    }
                }

                stage('Image Scan Backend') {
                    steps {
                        script {
                            trivy_image_scan("backend", params.IMAGE_TAG)
                        }
                    }
                }

                stage('Image Scan Admin') {
                    steps {
                        script {
                            trivy_image_scan("admin", params.IMAGE_TAG)
                        }
                    }
                }
            }
        }

        /* ================= DOCKER IMAGE PUSH ================= */

        stage('Docker Image Push') {
            when {
                branch 'main'
            }
            parallel {
                failFast true  
                stage('Push Frontend') {
                    steps {
                        script {
                            image_push("portfolio-frontend", params.IMAGE_TAG, DOCKER_USER)
                        }
                    }
                }

                stage('Push Backend') {
                    steps {
                        script {
                            image_push("portfolio-backend", params.IMAGE_TAG, DOCKER_USER)
                        }
                    }
                }

                stage('Push Admin') {
                    steps {
                        script {
                            image_push("portfolio-admin", params.IMAGE_TAG, DOCKER_USER)
                        }
                    }
                }
            }
        }
        
        

        /* ================= K8S IMAGE UPDATE ================= */

        stage('Kubernetes Image Update') {
            when {
                branch 'main'
            }
            parallel {
                failFast true 
                stage('Frontend Update') {
                    steps {
                        script {
                            k8s_image_tag_update("frontend", params.IMAGE_TAG)
                            k8s_image_push_on_git("frontend", params.IMAGE_TAG, GIT_USER)
                        }
                    }
                }

                stage('Backend Update') {
                    steps {
                        script {
                            k8s_image_tag_update("backend", params.IMAGE_TAG)
                            k8s_image_push_on_git("backend", params.IMAGE_TAG, GIT_USER)
                        }
                    }
                }

                stage('Admin Update') {
                    steps {
                        script {
                            k8s_image_tag_update("admin", params.IMAGE_TAG)
                            k8s_image_push_on_git("admin", params.IMAGE_TAG, GIT_USER)
                        }
                    }
                }
            }
        }

        
	}

    // Post Action 
    post {
        
        success {
            archiveArtifacts artifacts: '**/*.log', fingerprint: true
            emailext(
                to: "${env.USER_EMAIL}",
                subject: " SUCCESS : ${env.JON_NAME} # ${env.BUILD_NUMBER}",
                body: " Bhai Pipeline Completed Successfully. \n${env.BUILD_URL}",
                attachLog: true,
                attachmentsPattern: '**/*.log,trivy-*.txt'
            )
        }

        failure{
            archiveArtifacts artifacts: '**/*.log', fingerprint: true
            emailext(
                to: "${env.USER_EMAIL}",
                subject: " FAILED : ${env.JON_NAME} # ${env.BUILD_NUMBER}",
                body: " Bhai Pipeline Failed.\nCheck logs:\n${env.BUILD_URL}",
                attachLog: true,
                attachmentsPattern: '**/*.log,trivy-*.txt'
            )
        }
        unstable{
            archiveArtifacts artifacts: '**/*.log', fingerprint: true
            emailext(
                to: "${env.USER_EMAIL}",
                subject: " UNSTABLE : ${env.JON_NAME} #${env.BUILD_NUMBER}",
                body: " Bhai Pipeline Unstable.\n${env.BUILD_URL}",
                attachLog: true,
                attachmentsPattern: '**/*.log,trivy-*.txt'
            )
        }
        always {
            cleanWs(deleteDirs: true)
        }

    }
}

