def call(String imagename , String tag){
	println"Update $imagename-Image Tag..."
    sh """
        export IMAGE_TAG=${tag}
        yq -i e '.spec.template.spec.containers[0].image 
                 |= sub(":.*"; ":" + strenv(IMAGE_TAG))' k8s/${imagename}-deployment.yml
    """
    println"Successfully change  IMAGE-tag $tag" 
}  
