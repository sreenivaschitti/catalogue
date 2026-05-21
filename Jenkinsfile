pipeline {
    agent {
        node {

                label 'roboshop'

        }
    }

    environment {

        appversion = ""
    }
    // options { disableConcurrentBuilds() }
    //  parameters {
    //     string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

    //     text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

    //     booleanParam(name: 'DEPLOY', defaultValue: true, description: 'Toggle this value')

    //     choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')

    //     password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    // }
    stages {

        stage('Read Version'){

            steps {

                script {

                            // Read the file from the workspace
                    def packageJson = readJSON file: 'package.json'
                    
                    // Access properties
                    appversion = packageJson.version
                    // def name = packageJson.name
                    
                    echo "Building version ${appversion}"

                }

            }


        }


        stage('Installdependencies') {
            steps {
                script {

                        sh """    
                                

                                npm install
                            

                        """    
                }
            }
        }
        stage('dockerbuild') {
            steps {
                script {

                        sh """    
                            docker build -t catalogue:${appversion}

                        """    
                }
            }
        }
        stage('Deploy') {

            when {
                    expression { "$params.DEPLOY" == "true" }
            }
            steps {
                 script {

                        sh """    
                            echo "Deploy"

                        """    
                }
            }
        }
    }

     post { 
        always { 
            echo 'I will always say Hello again!'
        }
        success {

            echo 'sucess'
        }

        failure {

            echo 'failure'
        }
    }
}