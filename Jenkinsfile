@Library('portfoliolib') _
pipeline {
    agent {label "agentdev"}
    
    parameters {
        string(name: 'IMAGE_TAG', defaultValue: '1.0.0', description: 'Docker image tag')
    }

    
    environment {
    	APP_PASSWORD     = credentials('APP_PASSWORD')     
    	DB_ROOT_PASSWORD = credentials('DB_ROOT_PASSWORD')
        branch = "main" 
    }

    stages {
        stage('git_verify') {
            when {
                branch : 'main' 
            }
            steps {
                script {
                    git_checkout("https://github.com/dev9913/portfolio2.0.git/","${branch}")
                }
            }
        }
        // BUILDING A WEB APP IMAGE VIA DOCKER 

        stage("Docker Image Build "){
            parallel{ 
                stage('image build frontend'){
                    steps{
                        script {
                            image_build("portfolio-frontend", "${params.IMAGE_TAG}", "dev7878","frontend")
                        }
                    }
                }
                stage('image build backend'){
                    steps{
                        script{
                            image_build("portfolio-backend", "${params.IMAGE_TAG}", "dev7878","backend")
                        }
                    }
                }
                stage('image build admin'){
                    steps{
                        script{
                            image_build("portfolio-admin", "${params.IMAGE_TAG}", "dev7878","admin")
                        }
                    }
                }
            }    
        }
        // PUSH A WEB APP DOCKER IMAGE TO DOCKER HUB 

        stage("Docker Images Push  to Docker Hub"){
            parallel{    
                stage('frontend image push'){
                    steps{
                        script{
                            image_push("portfolio-frontend", "${IMAGE_TAG}", "dev7878")
                        }
                    }
                }
                 stage('backend image push'){
                    steps{
                        script{
                            image_push("portfolio-backend", "${IMAGE_TAG}", "dev7878")
                        }
                    }
                }
                 stage('admin image push'){
                    steps{
                        script{
                            image_push("portfolio-admin", "${IMAGE_TAG}", "dev7878")
                        }
                    }
                }
            }           
        }


        // Kubernetes deployment image Update
        stage("k8s image updates "){
            parallel("k8s Frontend image update "){
                stage{
                    steps{
                        script{
                            k8s_image_tag_update("frontend","${IMAGE_TAG}")
                            k8s_image_push_on_git("frontend","${IMAGE_TAG}","dev9913")
                    
                        }
                    }
                }
                stage("k8s backend image update "){
                    steps{
                        script{
		        			k8s_image_tag_update("backend","${IMAGE_TAG}")
		        			k8s_image_push_on_git("backend","${IMAGE_TAG}","dev9913")
                        }
                    }
                }
                stage("k8s admin image update "){
                    steps{
                        script{
                            k8s_image_tag_update("admin","${IMAGE_TAG}")
		        			k8s_image_push_on_git("admin","${IMAGE_TAG}","dev9913")
                        }
                    }
                }
            }
        }
       
        // Check env variable persent or not 
        
        stage('Check env') {
            steps {
              sh '''
                if [ -z "$APP_PASSWORD" ]; then
                  echo "APP_PASSWORD missing"
                  exit 1
                fi
                if [ -z "$DB_ROOT_PASSWORD" ]; then
                  echo "DB_ROOT_PASSWORD missing"
                  exit 1
                fi
                echo "Credentials loaded successfully"
              '''
            }
        }

        // Terraform  creates Deployment infra-structure 
        
        stage('Terraform Init') {
            steps {
               sh 'terraform init'
            }
        }
    
        stage('Terraform Plan') {
             steps {
                sh 'terraform init'
              }
         } 


        stage('Terraform Apply') {
          steps {
            sh """
              terraform apply -auto-approve \
              -var "app_password=${APP_PASSWORD}" \
              -var "db_root_password=${DB_ROOT_PASSWORD}"
            """
          }
        }

    }
}


post {
    always {

        archiveArtifacts artifacts: 'tfplan, **/*.log', fingerprint: true

        emailext(
            to: 'devops@example.com',
            subject: "Jenkins ${currentBuild.currentResult}: ${JOB_NAME} #${BUILD_NUMBER}",
            body: """
            Job Name : ${JOB_NAME}
            Build No : ${BUILD_NUMBER}
            Status   : ${currentBuild.currentResult}

            Build URL:
            ${BUILD_URL}
            """,
            attachLog: true,
            attachmentsPattern: 'tfplan, **/*.log'
        )
    }

    always {
        cleanWs(deleteDirs: true)
    }
}


