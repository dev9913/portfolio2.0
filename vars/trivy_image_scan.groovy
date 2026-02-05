def call(String imagename , String tag){
	println" Scanning Docker Image ==> dev7878/portfolio-$imagename:$tag "
    sh """
        set -e
        trivy image \
        --skip-version-check \
        --exit-code 1 \
        --severity HIGH,CRITICAL \
        --format table \
        dev7878/portfolio-${imagename}:${tag} | tee trivy-${imagename}-${tag}.txt
    """
    println "IMAGE SCAN Successfully dev7878/portfolio-$imagename:$tag" 
}  
