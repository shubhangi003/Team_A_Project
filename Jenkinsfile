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
                                sh 'newman run Postman/PetClinic_05_collection.json --environment Postman/PetClinic_05_environment.json --reporters junit'
                               }
                            post {
                                always {
                                		junit '**/*xml'
                                	   }
                                 }
                               }
           stage('Robot Tests') {
            steps {
                //sh 'robot --variable BROWSER:headlesschrome -d Results  Tests'
                sh 'robot --variable BROWSER:headlesschrome -d RobotFrameWork/Results RobotFrameWork/Tests'
            }
            post {
                always {
                    script {
                          step(
                                [
                                  $class              : 'RobotPublisher',
                                  outputPath          : 'Results',
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
