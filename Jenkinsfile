pipeline{
    agent any
    stages{
        stage('Build API') {
           steps {
               sh "cd spring-petclinic-rest && nohup mvn spring-boot:run &"
               sleep(20)
           }
        }
         stage('Build Website') {
            steps {
               sh 'cd spring-petclinic-angular/static-content && curl https://jcenter.bintray.com/com/athaydes/rawhttp/rawhttp-cli/1.0/rawhttp-cli-1.0-all.jar -o rawhttp.jar && nohup java -jar ./rawhttp.jar serve . -p 4200 &'  
                sleep(3)
                  }
           }
                stage('Postman') {
                            steps {
                                sh 'newman run Postman/PetClinic_04_collection.json --environment Postman/PetClinic_04_environment.json --reporters junit'
                            }
                            post {
                                always {
                                		junit '**/*xml'
                                	   }
                            }

                }

               
    }
     post {
            always {
                echo 'Hello! You Build a successful Build for API Testing !'
                emailext (
                subject: "YOUR Postman build in jenkin",
                body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                to: 'shubhangi.patil@iths.se',
                //attachmentsPattern: 'RobotFrameWork/Results/report.html, RobotFrameWork/Results/log.html'
                        )
                    }
               }
}
