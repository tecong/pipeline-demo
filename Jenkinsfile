node {
    // uncomment these 2 lines and edit the name 'node-4.6.0' according to what you choose in configuration
    // def nodeHome = tool name: 'node-4.6.0', type: 'jenkins.plugins.nodejs.tools.NodeJSInstallation'
    // env.PATH = "${nodeHome}/bin:${env.PATH}"

    stage('check tools') {
        sh "node -v"
        sh "npm -v"
        sh "bower -v"
        sh "gulp -v"
    }

    stage('checkout') {
        checkout scm
    }

    stage('npm install ') {
        dir('microservice-demo/demoapp') {
          sh "npm install"
        }
    }

    stage('clean') {
      parallel(demoapp: {
        dir('microservice-demo/demoapp') {
          sh "./mvnw clean"
        }
      }, repository: {
        dir('microservice-demo/repository') {
          sh "./mvnw clean"
        }
      })
    }

    stage('backend unit tests demoapp') {
        dir('microservice-demo/demoapp') {
          sh "./mvnw test"
          junit 'target/surefire-reports/*.xml'
        }
    }

    stage('backend unit tests repository-microservice') {
        dir('microservice-demo/repository') {
          sh "./mvnw test"
          junit 'target/surefire-reports/*.xml'
        }
    }


    stage('frontend unit tests') {
        dir('microservice-demo/demoapp') {
          sh "gulp test"
          junit 'target/test-results/karma/*.xml'
        }
    }

    stage('packaging') {
      parallel(demoapp: {
        dir('microservice-demo/demoapp') {
          sh "./mvnw package -Pprod -DskipTests"
        }
      }, repository: {
        dir('microservice-demo/repository') {
          sh "./mvnw package -Pprod -DskipTests"
        }
      })
    }

    stage('Install to test') {
        dir('microservice-demo/demoapp') {
          docker.withRegistry('https://docker-registry-default.cloudapps.ocp-teco.teco.prd.a.tecdomain.net', 'demoapp-test') {
            docker.withServer('tcp://127.0.0.1:4243') {
              def newDemoApp = docker.build "demoapp-test/demoapp:${env.BUILD_TAG}"
              newDemoApp.push()
              newDemoApp.push 'latest'
              newDemoApp.push 'test'
            }
          }
        }
        dir('microservice-demo/repository') {
          docker.withRegistry('https://docker-registry-default.cloudapps.ocp-teco.teco.prd.a.tecdomain.net', 'demoapp-test') {
            docker.withServer('tcp://127.0.0.1:4243') {
              def newRepositoryApp = docker.build "demoapp-test/repository:${env.BUILD_TAG}"
              newRepositoryApp.push()
              newRepositoryApp.push 'latest'
              newRepositoryApp.push 'test'
            }
          }
        }
   }

  stage('Install to UAT') {
    input message: 'Do you want to install this build to UAT env?', ok: 'Install to UAT'
    docker.withRegistry('https://docker-registry-default.cloudapps.ocp-teco.teco.prd.a.tecdomain.net', 'demoapp-test') {
      docker.withServer('tcp://127.0.0.1:4243') {
        def testimage = docker.image("demoapp-test/demoapp:${env.BUILD_TAG}")
        testimage.push 'uat'
        testimage = docker.image("demoapp-test/repository:${env.BUILD_TAG}")
        testimage.push 'uat'
      }
    }
  }

  stage('Install to prod') {
    input message: 'Do you want to install this build to prod env?', ok: 'Install to prod'
    docker.withRegistry('https://docker-registry-default.cloudapps.ocp-teco.teco.prd.a.tecdomain.net', 'demoapp-test') {
      docker.withServer('tcp://127.0.0.1:4243') {
        def testimage = docker.image("demoapp-test/demoapp:${env.BUILD_TAG}")
        testimage.push 'prod'
        testimage = docker.image("demoapp-test/repository:${env.BUILD_TAG}")
        testimage.push 'prod'
      }
    }
  }
}
