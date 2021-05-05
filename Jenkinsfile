pipeline{
    agent any
    stages{
        stage('Para'){
            parallel{
                 stage('Build and Run the Server'){
                            steps{
                                sh 'cd spring-petclinic-rest && nohup mvn spring-boot:run &'
                            }
                }
                 stage('Run the Frontend'){
                              steps{
                                    sleep(10)
                                    sh 'cd spring-petclinic-angular/static-content && curl https://jcenter.bintray.com/com/athaydes/rawhttp/rawhttp-cli/1.0/rawhttp-cli-1.0-all.jar -o rawhttp.jar && nohup java -jar ./rawhttp.jar serve . -p 4200 &'
                              }
                }
                stage('Newman by Postman') {
                            steps {
                                sleep(10)
                                	script {
                                        try {
                                			sh 'newman run Spring_PetClinic_Copy.postman_collection.json --environment PetClinic_Environment.postman_environment.json --reporters junit'
                                		}
                                		catch (Exception e) {
                                             echo "Tests are failing, continue pipeline..."
                                        }
                                    }
                            }
                            post {
                                	always {
                                		junit '**/*xml'
                                	}
                                    always {
                                    emailext body: 'A Test EMail', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Test'
                                        }
                            }

                }

                stage('Robot Framework') {
                              steps {
                                    sleep(10)
                                    sh 'robot --variable BROWSER:headlesschrome -d RobotFrameWork/Results RobotFrameWork/Tests/**.robot'
                              }
                              post {
                                    always {
                                           script {
                                                  step(
                                                       [
                                                             $class              : 'RobotPublisher',
                                                              outputPath          : 'RobotFrameWork/Results',
                                                              outputFileName      : '**/output.xml',
                                                              reportFileName      : '**/report.html',
                                                              logFileName         : '**/log.html',
                                                              disableArchiveOutput: false,
                                                              passThreshold       : 50,
                                                              unstableThreshold   : 40,
                                                              otherFiles          : "**/*.png,**/*.jpg",
                                                       ]
                                                  )
                                           }
                                    }
                              }
                }
            }
       }
    }
}
