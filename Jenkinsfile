    pipeline{
        agent any 
        environment{
            // Docker Hub public and private repository names
            DOCKER_DEV_REPO = "srisatyap/dev"
            DOCKER_PROD_REPO = "srisatyap/prod"
            CONTAINER_NAME = "prod-react-app"
            EXPOSE_HOST = 80
            PROD_HOST = "ubuntu@3.109.203.128"
        }
        stages{
            stage('Setting Branch Name') {
                 steps {
                    script {
                    def fullbranch = "${env.GIT_BRANCH}"
                    def branch = fullbranch.tokenize('/').last()
                    echo "Detected Git branch: ${branch}"
                    env.BRANCH_NAME = branch
                    }
                }
            }
            stage('show branch'){
                steps{
                    sh "echo  ${env.BRANCH_NAME}"
                }
            }
            stage('Docker Image build and push to dev repo'){
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
                            sh "chmod +x ./build.sh"
                            sh "./build.sh ${env.DOCKER_DEV_REPO} ${buildTag}"
                        }
                
                }
            }
        }
        stage('Docker Image build and push to prod repo'){
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
                            sh "chmod +x ./build.sh"
                            sh "./build.sh ${env.DOCKER_PROD_REPO} ${buildTag}"
                        }
                
                }
            }
        }
        // now ssh into ec2 from jenkins using ssh key and pull the image on ec2 and run it using script
        stage('Deploy the application to Server'){
            when {
                expression { env.BRANCH_NAME == 'main' }
            }
            steps{
                script{
                    def releaseTag = "prodbuild-${env.BUILD_NUMBER}"
                    echo "Initiating deployment of image to ec2: ${PROD_HOST}"
                    sshagent(credentials: ['jenkins-ec2-deploy']){
                        sh 'chmod +x ./deploy.sh'
                        sh """ 
                         ssh -o StrictHostKeyChecking=no ${PROD_HOST} 'bash -s' < deploy.sh "${DOCKER_PROD_REPO}:${releaseTag}" "${CONTAINER_NAME}" "${EXPOSE_HOST}"
                        """
                    }
                    echo "SSH command to deploy has been sent to remote server"
                }

            }
        }
    }
    }