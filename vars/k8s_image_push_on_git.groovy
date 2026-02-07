def call(String imagename, String tag, String username) {

    println " Pushing updated Kubernetes file to GitHub..."

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
              set -e
              set -x

              git config user.name "\$GIT_USER"
              git config user.email "\$GIT_EMAIL"

              git pull origin main 
              git status
              git add k8s/${imagename}-deployment.yml
              git commit -m "Ci: update ${imagename} image to ${tag} " || true
              git push https://\$GIT_USER:\$GIT_TOKEN@github.com/${username}/portfolio2.0.git HEAD:main
            
            """
        } catch (Exception e) {
            println "Failed to push ${username}/${imagename}:${tag} to GitHub."
            throw e
        }
    }
}
