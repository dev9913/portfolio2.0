def call(String imgname, String tag, String username) {
    println "Login to the Docker Hub !!"
    withCredentials([usernamePassword(
        credentialsId: 'docker',
        usernameVariable: 'DOCKER_USER',
        passwordVariable: 'DOCKER_PASS'
    )]) {
        try {
            // Login to Docker Hub
            sh """
                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            """

            // Push Docker image
            sh """
                docker push ${username}/${imgname}:${tag}
            """

            println "Successfully pushed ${username}/${imgname}:${tag} to Docker Hub."
        } catch (Exception e) {
            println "Failed to push Docker image ${username}/${imgname}:${tag}."
            throw e
        }
    }
}
