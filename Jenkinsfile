pipeline {
            agent {
                node {

                        label 'roboshop'

                }
            }

            environment {

                appversion = ""
                acc_id = "442940292368"
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

                stage('Read Version') {

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


        //         stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             def scannerHome = tool name: 'sonar-8'

        //             withSonarQubeEnv('sonar-server') {
        //                 sh "${scannerHome}/bin/sonar-scanner"
        //             }
        //         }
        //     }
        // }

        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 1, unit: 'HOURS') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }
         stage('Dependabot Security Check') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    script {
                        def owner = 'sreenivaschitti'
                        def repo  = 'catalogue'

                        def response = sh(
                            script: """
                                curl -s -w "\\n%{http_code}" \\
                                -H "Authorization: Bearer ${GITHUB_TOKEN}" \\
                                "https://api.github.com/repos/${owner}/${repo}/dependabot/alerts?severity=high,critical&state=open"
                            """,
                            returnStdout: true
                        ).trim()

                        def parts      = response.tokenize('\n')
                        def httpStatus = parts[-1]
                        def body       = parts[0..-2].join('\n')

                        if (httpStatus != '200') {
                            error "GitHub API failed: ${httpStatus}"
                        }

                        def alerts = readJSON text: body

                        if (alerts.size() > 0) {
                            error "High/Critical vulnerabilities found!"
                        }
                    }
                }
            }
        }
                stage('dockerbuild') {
                    steps {
                        script {

                                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                            
                        
                                sh """    
                                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${acc_id}.dkr.ecr.us-east-1.amazonaws.com
                                    docker build -t ${acc_id}.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:${appversion} .
                                    docker push ${acc_id}.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:${appversion}
                           
                                 """    
                        }
                    }
                }

                }
              
            }

}         
    
    
    