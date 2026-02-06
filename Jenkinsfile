@Library('portfoliolib') _

pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timeout(time: 45, unit: 'MINUTES')
        timestamps()
    }

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: '1.0.0', description: 'Docker image tag')
    }

    environment {
        APP_PASSWORD     = credentials('APP_PASSWORD')
        DB_ROOT_PASSWORD = credentials('DB_ROOT_PASSWORD')
        VAULT_BOOTSTRAP_TOKEN = credentials('VAULT_BOOTSTRAP_TOKEN')
        USER_EMAIL       = credentials('USER_EMAIL')
        USER_EMAIL_PASSWORD = credentials('USER_EMAIL_PASSWORD')
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
                    git_checkout("https://github.com/dev9913/portfolio2.0.git","main")
                }
            }
        }

        /* ================= DOCKER IMAGE BUILD ================= */

        stage('Docker Image Build') {
            parallel {
                
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

        /* ================= TERRAFORM ================= */

        stage('Terraform validate'){
            steps{
                dir('terraform/Resource'){
                    sh 'terraform fmt '
                    sh 'terraform validate'

                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform/Resource'){
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform/Resource'){
                    sh 'terraform plan -out=tfplan'
                }
            }
        }       

        stage('Terraform Apply') {
		    steps {
		        dir('terraform/Resource') {
		            withEnv([
		                "VAULT_ADDR=http://vault.vault.svc.cluster.local:8200",
		                "VAULT_TOKEN=${VAULT_BOOTSTRAP_TOKEN}",
		
		                "TF_VAR_vault_bootstrap_token=${VAULT_BOOTSTRAP_TOKEN}",
		                "TF_VAR_app_password=${APP_PASSWORD}",
		                "TF_VAR_db_root_password=${DB_ROOT_PASSWORD}",
		                "TF_VAR_user_email=${USER_EMAIL}",
		                "TF_VAR_user_email_password=${USER_EMAIL_PASSWORD}"
		            ]) {
		                sh 'terraform apply -auto-approve tfplan'
		            }
		        }
		    }
		}
	}

    // Post Action 
    post {
        always {
            archiveArtifacts artifacts: 'terraform/Resource/tfplan, **/*.log', fingerprint: true
            
            emailext(
                to: "${env.USER_EMAIL}",
				
                subject: "Jenkins ${currentBuild.currentResult}: ${JOB_NAME} #${BUILD_NUMBER}",
                body: """
Job Name : ${JOB_NAME}
Build No : ${BUILD_NUMBER}
Status   : ${currentBuild.currentResult}

Build URL:
${BUILD_URL}
""",
                attachLog: true,
                attachmentsPattern: 'terraform/Resource/tfplan, **/*.log,trivy-*.txt'
            )

            cleanWs(deleteDirs: true)
        }
    }
}


