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
                                sh 'newman run RestfulBooker_collection.json --environment RestfulBooker_environment.json --reporters junit'
                            }
                            post {
                                	always {
                                		junit '**/*xml'
                                	}
                            }

                }

               
    }
}
