    pipeline{
        agent { any }
        environment{
            // Docker Hub Credentials
            DOCKER_HUB_USERNAME = credentials('docker-hub-credentials').getUsername()
            DOCKER_HUB_PASSWORD = credentials('docker-hub-credentials').getPassword()
            // Docker Hub public and private repository names
            DOCKER_DEV_REPO = "srisatyap/dev"
            DOCKER_PROD_REPO = "srisatyap/prod"
        }
        stages{
            stage('Docker Image building and pushing to dev repo'){
                when {
                    branch 'dev'
                }
                steps {
                    script{
                        def buildTag = "devbuild-${env.BUILD_NUMBER}"
                        echo "Building and pushing docker image to '${env.BRANCH_NAME}' with tag '${buildTag}'" 
                        sh "./build.sh ${env.DOCKER_DEV_REPO} ${buildTag}"
                
                }
            }
        }
        stage('Docker Image building and pushing to prod repo'){
                when {
                    branch 'main'
                }
                steps {
                    script{
                         def buildTag = "prodbuild-${env.BUILD_NUMBER}"
                        echo "Building and pushing docker image to '${env.BRANCH_NAME}' with tag '${buildTag}'" 
                        sh "./build.sh ${env.DOCKER_PROD_REPO} ${buildTag}"
                
                }
            }
        }
    }
    }