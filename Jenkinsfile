@Library('portfoliolib') _

pipeline {
    agent { label 'agentdev' }

    options {
        disableConcurrentBuilds()
        timeout(time: 45, unit: 'MINUTES')
        timestamps()
    }

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: '3.0.0', description: 'Docker image tag')
    }
 
    environment {
        USER_EMAIL                  = credentials('USER_EMAIL')
        USER_EMAIL_PASSWORD         = credentials('USER_EMAIL_PASSWORD')
        ARTIFACTS                   = '**/*.log,trivy-*.txt'
        ANSIBLE_HOST_KEY_CHECKING   = 'False'
        TF_IN_AUTOMATION            = "true"
        BRANCH                      = "main"
        DOCKER_USER                 = "dev7878"
        GIT_USER                    = "dev9913"
    }

    stages {

        /* ================= ENV CHECK ================= */

        stage('Check Environment Variables') {
            steps {
                sh '''
                  [ -z "$USER_EMAIL" ] && echo "USER_EMAIL missing" && exit 1
                  [ -z "$USER_EMAIL_PASSWORD" ] && echo "USER_EMAIL_PASSWORD missing" && exit 1
                  echo "Credentials loaded successfully"
                '''
            }
        }

        stage('Git Checkout') {
            steps {
                script {
                    git_checkout("https://github.com/dev9913/portfolio2.0.git", BRANCH)
                }
            }
        }

        /* ================= DOCKER IMAGE BUILD ================= */

        stage('Docker Image Build') {
            when { expression { BRANCH == 'main' } }
            steps {
                script {
                    parallel failFast: true,
                        frontend: {
                            image_build("portfolio-frontend", params.IMAGE_TAG, DOCKER_USER, "frontend")
                        },
                        backend: {
                            image_build("portfolio-backend", params.IMAGE_TAG, DOCKER_USER, "backend")
                        },
                        admin: {
                            image_build("portfolio-admin", params.IMAGE_TAG, DOCKER_USER, "admin")
                        }
                }
            }
        }

        /* ================= DOCKER IMAGE SCAN ================= */

        stage('Docker Image Scan') {
            when { expression { BRANCH == 'main' } }
            steps {
                script {
                    parallel failFast: true,
                        frontend: {
                            trivy_image_scan("frontend", params.IMAGE_TAG)
                        },
                        backend: {
                            trivy_image_scan("backend", params.IMAGE_TAG)
                        },
                        admin: {
                            trivy_image_scan("admin", params.IMAGE_TAG)
                        }
                }
            }
        }

        /* ================= DOCKER IMAGE PUSH ================= */

        stage('Docker Image Push') {
            when { expression { BRANCH == 'main' } }
            steps {
                script {
                    parallel failFast: true,
                        frontend: {
                            image_push("portfolio-frontend", params.IMAGE_TAG, DOCKER_USER)
                        },
                        backend: {
                            image_push("portfolio-backend", params.IMAGE_TAG, DOCKER_USER)
                        },
                        admin: {
                            image_push("portfolio-admin", params.IMAGE_TAG, DOCKER_USER)
                        }
                }
            }
        }

        /* ================= K8S IMAGE UPDATE ================= */

        stage('Kubernetes Image Update') {
            when { expression { BRANCH == 'main' } }
            steps {
                script {
                    parallel failFast: true,
                        frontend: {
                            k8s_image_tag_update("frontend", params.IMAGE_TAG)
                            k8s_image_push_on_git("frontend", params.IMAGE_TAG, GIT_USER)
                        },
                        backend: {
                            k8s_image_tag_update("backend", params.IMAGE_TAG)
                            k8s_image_push_on_git("backend", params.IMAGE_TAG, GIT_USER)
                        },
                        admin: {
                            k8s_image_tag_update("admin", params.IMAGE_TAG)
                            k8s_image_push_on_git("admin", params.IMAGE_TAG, GIT_USER)
                        }
                }
            }
        }

        /* ================= Ansible ================= */

        stage('Install Ansible') {
            steps {
                sh '''
                  if ! command -v ansible >/dev/null 2>&1; then
                    sudo apt update
                    sudo apt install -y ansible
                  fi
                '''
            }
        }
        stage('Ping Test') {
            steps {
                sh '''
                  ansible -i ansible/inventory.ini server -m ping
                '''
            }
        }
        stage('Install k3s  and Helm Chart ') {
            steps {
                sh '''
                  ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml
                '''
            }
        }
        
        
        /* ================= Terraform ================= */

        stage("Terraform Init"){
            steps{
                dir('terraform'){
                    sh ' terraform init '
                }
            }    
        }

        stage("Terraform Validate"){
            steps{
                dir('terraform'){
                    sh ' terraform validate '
                }
            }    
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    withCredentials([
                        
                        string(credentialsId: 'app_password', variable: 'TF_VAR_app_password'),
                        string(credentialsId: 'db_root_password', variable: 'TF_VAR_db_root_password'),
                        string(credentialsId: 'user_email', variable: 'TF_VAR_user_email'),
                        string(credentialsId: 'user_email_password', variable: 'TF_VAR_user_email_password')
                    ]) {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    withCredentials([
                        
                        string(credentialsId: 'app_password', variable: 'TF_VAR_app_password'),
                        string(credentialsId: 'db_root_password', variable: 'TF_VAR_db_root_password'),
                        string(credentialsId: 'user_email', variable: 'TF_VAR_user_email'),
                        string(credentialsId: 'user_email_password', variable: 'TF_VAR_user_email_password')
                    ]) {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }

        /* ================= Stop Pipeline ================= */


    }

    /* ================= POST ACTIONS ================= */

    post {
        success {
            archiveArtifacts artifacts: env.ARTIFACTS,
                         allowEmptyArchive: true
            emailext(
                to: "${env.USER_EMAIL}",
                subject: "SUCCESS : ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Bhai Pipeline Completed Successfully.\n${env.BUILD_URL}",
                attachLog: true,
                attachmentsPattern: '**/*.log,trivy-*.txt'
            )
        }

        failure {
            archiveArtifacts artifacts: env.ARTIFACTS,
                         allowEmptyArchive: true
            emailext(
                to: "${env.USER_EMAIL}",
                subject: "FAILED : ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Bhai Pipeline Failed.\nCheck logs:\n${env.BUILD_URL}",
                attachLog: true,
                attachmentsPattern: '**/*.log,trivy-*.txt'
            )
        }

        unstable {
            archiveArtifacts artifacts: env.ARTIFACTS,
                         allowEmptyArchive: true
            emailext(
                to: "${env.USER_EMAIL}",
                subject: "UNSTABLE : ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Bhai Pipeline Unstable.\n${env.BUILD_URL}",
                attachLog: true,
                attachmentsPattern: '**/*.log,trivy-*.txt'
            )
        }

        always {
            cleanWs(deleteDirs: true)
            sh 'rm -rf $WORKSPACE/.trivy-cache-* || true'
        }
    }
}
