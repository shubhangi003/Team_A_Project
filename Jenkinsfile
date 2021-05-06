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
                stage('Postman') {
                            steps {
                                sleep(10)
                                sh 'newman run copy1.postman_collection.json --environment copy1.postman_environment.json --reporters junit'
                            }
                            post {
                                	always {
                                		junit '**/*xml'
                                	}
                            }

                }

               
    }
}
