    pipeline{
        agent any 
        environment{
            // Docker Hub public and private repository names
            DOCKER_DEV_REPO = "srisatyap/dev"
            DOCKER_PROD_REPO = "srisatyap/prod"
        }
        stages{
            stage('Debug Branch') {
                steps {
                    echo "Current branch: ${env.BRANCH_NAME}"
                }
            }
            stage('Docker Image building and pushing to dev repo'){
                when {
                    branch 'dev'
                }
                steps {
                    script{
                        // Docker Hub Credentials
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]){
                            //Login to dockerhub using the above injected variables
                            sh 'echo "${DOCKER_PASSWORD}" | docker login -u ${DOCKER_USERNAME} --password-stdin'
                            def buildTag = "devbuild-${env.BUILD_NUMBER}"
                            echo "Building and pushing docker image to '${env.BRANCH_NAME}' with tag '${buildTag}'" 
                            sh "./build.sh ${env.DOCKER_DEV_REPO} ${buildTag}"
                        }
                
                }
            }
        }
        stage('Docker Image building and pushing to prod repo'){
                when {
                    branch 'main'
                }
                steps {
                   script{
                        // Docker Hub Credentials
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]){
                            //Login to dockerhub using the above injected variables
                            sh ' echo "${DOCKER_PASSWORD}" | docker login -u ${DOCKER_USERNAME} --password-stdin'
                            def buildTag = "prodbuild-${env.BUILD_NUMBER}"
                            echo "Building and pushing docker image to '${env.BRANCH_NAME}' with tag '${buildTag}'" 
                            sh "./build.sh ${env.DOCKER_PROD_REPO} ${buildTag}"
                        }
                
                }
            }
        }
    }
    }