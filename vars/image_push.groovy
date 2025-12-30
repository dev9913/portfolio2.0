def call (String imgname, String tag, String username ){
	println "Login to the Docker Hub !!"
	withCredentials([usernamePassword(
		credentialsId: 'docker',
		usernameVariable: 'DOCKER_USER',
		passwordVariable: 'DOCKER_PASS'
	)]){
	  
	try {
           	 // Login to DockerHub
            	    sh """
                 	echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            	    """

            	// Push Docker image
            	    sh """
                	docker push ${userName}/${imgName}:${tag}
            	    """

            	println "Successfully pushed ${userName}/${imgName}:${tag} to Docker Hub."
        	
	} catch (Exception e) {
            println "Failed to push Docker image ${userName}/${imgName}:${tag}."
            throw e 
    }
  }
}
