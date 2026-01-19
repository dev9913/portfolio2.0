@Library('portfoliolib') _
pipeline {
    agent {label "agentdev"}
    
    parameters {
        string(name: 'IMAGE_TAG', defaultValue: '1.0.0', description: 'Docker image tag')
    }

    stages {
        stage('git_verify') {
            steps {
                script {
                    git_checkout("https://github.com/dev9913/portfolio2.0.git/","main")
                }
            }
        }
        // BUILDING A WEB APP IMAGE VIA DOCKER  
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
        // PUSH A WEB APP DOCKER IMAGE TO DOCKER HUB V 
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
        stage("k8s frontend image update "){
            steps{
                script{
                    image_update_k8s("frontend",${IMAGE_TAG})
                }
            }
        }
        stage("k8s backend image update "){
            steps{
                script{
                    image_update_k8s("backend",${IMAGE_TAG})
                }
            }
        }
        stage("k8s admin image update "){
            steps{
                script{
                    image_update_k8s("admin",${IMAGE_TAG})
                }
            }
        }
    }
}
