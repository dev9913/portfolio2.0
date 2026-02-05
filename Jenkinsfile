@Library('portfoliolib') _

pipeline {
    agent { label 'agentdev' }

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: '1.0.0', description: 'Docker image tag')
    }

    environment {
        APP_PASSWORD     = credentials('APP_PASSWORD')
        DB_ROOT_PASSWORD = credentials('DB_ROOT_PASSWORD')
        BRANCH_NAME      = "${env.BRANCH_NAME ?: 'main'}"
        DOCKER_USER      = "dev7878"
        GIT_USER         = "dev9913"
    }

    stages {

        stage('Git Checkout') {
            when {
                expression { env.BRANCH_NAME == 'main' }
            }
            steps {
                script {
                    git_checkout(
                        "https://github.com/dev9913/portfolio2.0.git",
                        "${BRANCH_NAME}"
                    )
                }
            }
        }

        /* ================= DOCKER IMAGE BUILD ================= */

        stage('Docker Image Build') {
            parallel {
                stage('Build Frontend') {
                    steps {
                        script {
                            image_build(
                                "portfolio-frontend",
                                params.IMAGE_TAG,
                                DOCKER_USER,
                                "frontend"
                            )
                        }
                    }
                }

                stage('Build Backend') {
                    steps {
                        script {
                            image_build(
                                "portfolio-backend",
                                params.IMAGE_TAG,
                                DOCKER_USER,
                                "backend"
                            )
                        }
                    }
                }

                stage('Build Admin') {
                    steps {
                        script {
                            image_build(
                                "portfolio-admin",
                                params.IMAGE_TAG,
                                DOCKER_USER,
                                "admin"
                            )
                        }
                    }
                }
            }
        }

        /* ================= DOCKER IMAGE PUSH ================= */

        stage('Docker Image Push') {
            parallel {
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
        
        /* ================= DOCKER IMAGE SCAN ================= */

        stage('Docker Image Scan') {
            parallel {
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

        /* ================= K8S IMAGE UPDATE ================= */

        stage('Kubernetes Image Update') {
            parallel {
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

        /* ================= ENV CHECK ================= */

        stage('Check Environment Variables') {
            steps {
                sh '''
                  [ -z "$APP_PASSWORD" ] && echo "APP_PASSWORD missing" && exit 1
                  [ -z "$DB_ROOT_PASSWORD" ] && echo "DB_ROOT_PASSWORD missing" && exit 1
                  echo "Credentials loaded successfully"
                '''
            }
        }

        /* ================= TERRAFORM ================= */

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                  terraform apply -auto-approve tfplan
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan, **/*.log', fingerprint: true

            emailext(
                to: 'devjangig@gmail.com',
                subject: "Jenkins ${currentBuild.currentResult}: ${JOB_NAME} #${BUILD_NUMBER}",
                body: """
Job Name : ${JOB_NAME}
Build No : ${BUILD_NUMBER}
Status   : ${currentBuild.currentResult}

Build URL:
${BUILD_URL}
""",
                attachLog: true,
                attachmentsPattern: 'tfplan, **/*.log,trivy-frontend.txt,trivy-backend.txt,trivy-admin.txt'
            )

            cleanWs(deleteDirs: true)
        }
    }
}

