def call(String imagename, String tag) {
    println "Scanning Docker Image ==> dev7878/portfolio-${imagename}:${tag}"

    sh(
        script: '''
            set -euo pipefail
            export TRIVY_CACHE_DIR="$WORKSPACE/.trivy-cache-${imagename}"

            trivy image \
              --scanners vuln \
              --skip-version-check \
              --exit-code 1 \
              --severity CRITICAL \
              --format table \
              dev7878/portfolio-${imagename}:${tag} | tee trivy-${imagename}-${tag}.txt
        ''',
        shell: '/bin/bash'
    )

    println "IMAGE SCAN Successfully dev7878/portfolio-${imagename}:${tag}"
}
