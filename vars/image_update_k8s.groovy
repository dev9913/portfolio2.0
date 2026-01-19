def call(String imagename , String tag){
	println"Update $imagename-Image Tag..."
    sh """
	        yq e -i  '.spec.template.spec.containers[] 
                  | select(.name == "${imagename}") 
                  | .image |= sub(":(.*)$"; ":${tag}")' 
                    k8s/${imagename}-deployment.yml   
	"""
    println"Successfully change  IMAGE-tag $tag" 
}  
