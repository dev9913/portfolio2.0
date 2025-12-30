def call(String imagename, String tag, String username, String location){
	println "Building the $imagename Docker image !! "
	try {
    		sh "docker build -t $username/$imagename:$tag ./$location"
	} catch (Exception e) {
    		println "Docker build failed for $imagename"
    		throw e 
	}
	println "$imagename Docker Image Build Success !!!"
}

