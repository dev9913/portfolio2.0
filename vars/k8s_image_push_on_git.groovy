def call(String imagename, String tag,  String username) {
    println "Login to the GIT-HUB !!"
   withCredentials([
        string(credentialsId: 'email', variable: 'GIT_EMAIL'),
        usernamePassword(
            credentialsId: 'github-creds',
            usernameVariable: 'GIT_USER',
            passwordVariable: 'GIT_TOKEN'
        )
    ]) {
 	try {
            sh """
            git config user.name "$GIT_USER"
            git config user.email "$GIT_EMAIL"

            git status
            git add k8s/${imagename}-deployment.yml
            git commit -m "ci: update ${imagename} image to ${tag}" || echo "Nothing to commit"

            git push https://${GIT_USER}:${GIT_TOKEN}@github.com/${username}/portfolio2.0.git HEAD:main
          
	   """
            
            println "Successfully pushed ${username}/${imagename}:${tag} to GitHub."
        } catch (Exception e) {
            println "Failed to push on github ${username}/${imagename}:${tag}."
            throw e
        }
	     
     }
}
