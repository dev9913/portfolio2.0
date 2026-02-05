def call(String imagename , String tag){
	println" Scaning Docker Image ==> dev7878/portfolio-$imagename-$tag "
    sh """

        trivy image \
        --skip-version-check \
        --exit-code 1 \
        --severity HIGH,CRITICAL \
        --format table \
        dev7878/portfolio-${imagename}:${tag} | tee trivy-${imagename}.txt


        export IMAGE_TAG=${tag}
        yq -i e '.spec.template.spec.containers[0].image 
                 |= sub(":.*"; ":" + strenv(IMAGE_TAG))' k8s/${imagename}-deployment.yml
    """
    println"IMAGE SCAN Successfully dev7878/portfolio-$imagename:$tag" 
}  
