    pipeline{
        agent any 
        environment{
            // Docker Hub public and private repository names
            DOCKER_DEV_REPO = "srisatyap/dev"
            DOCKER_PROD_REPO = "srisatyap/prod"
        }
        stages{
            stage('Setting Branch Name') {
                 steps {
                    script {
                    // Run git command to get the current branch
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Detected Git branch: ${branch}"
                    // Set it to environment variable
                    env.BRANCH_NAME = branch
                    }
                }
            }
            stage('show branch'){
                steps{
                    sh "echo ${env.BRANCH_NAME}"
                }
            }
            stage('Docker Image building and pushing to dev repo'){
                when {
                    expression { env.BRANCH_NAME == 'dev' }
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
                    expression { env.BRANCH_NAME == 'main' }
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