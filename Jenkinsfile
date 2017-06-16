stage('check tools') {
  node {
        sh "node -v"
        sh "npm -v"
        sh "bower -v"
        sh "gulp -v"
  }
}

stage('checkout') {
  node {
        checkout scm
  }
}

stage('npm install ') {
  node {
        dir('demoapp') {
          sh "npm install"
        }
  }
}

stage('clean') {
  node {
      parallel(demoapp: {
        dir('demoapp') {
          sh "./mvnw clean"
        }
      }, repository: {
        dir('repository') {
          sh "./mvnw clean"
        }
      })
  }
}

stage('sonar') {
  node {
      parallel(demoapp: {
          dir('demoapp') {
            sh "./mvnw clean sonar:sonar"
          }
      }, repository: {
          dir('repository') {
            sh "./mvnw clean sonar:sonar"
          }
      })
  }
}

stage('backend unit tests demoapp') {
  node {
        dir('demoapp') {
          sh "./mvnw test"
          junit 'target/surefire-reports/*.xml'
        }
  }
}

stage('backend unit tests repository-microservice') {
  node {
        dir('repository') {
          sh "./mvnw test"
          junit 'target/surefire-reports/*.xml'
        }
  }
}


stage('frontend unit tests') {
  node {
        dir('demoapp') {
          sh "gulp test"
          junit 'target/test-results/karma/*.xml'
        }
  }
}

stage('packaging') {
  node {
      parallel(demoapp: {
          dir('demoapp') {
            sh "./mvnw package -Pprod -DskipTests"
          }
      }, repository: {
          dir('repository') {
            sh "./mvnw package -Pprod -DskipTests"
          }
      })
  }
}

stage('Install to test') {
  node {
        dir('demoapp') {
          docker.withRegistry('https://docker-registry-default.cloudapps.ocp-tdemo.teco.prd.a.tecdomain.net', 'demoapp-test') {
            docker.withServer('tcp://127.0.0.1:4243') {
              def newDemoApp = docker.build "demoapp-test/demoapp:${env.BUILD_TAG}"
              newDemoApp.push()
              newDemoApp.push 'latest'
              newDemoApp.push 'test'
            }
          }
        }
        dir('repository') {
          docker.withRegistry('https://docker-registry-default.cloudapps.ocp-tdemo.teco.prd.a.tecdomain.net', 'demoapp-test') {
            docker.withServer('tcp://127.0.0.1:4243') {
              def newRepositoryApp = docker.build "demoapp-test/repository:${env.BUILD_TAG}"
              newRepositoryApp.push()
              newRepositoryApp.push 'latest'
              newRepositoryApp.push 'test'
            }
          }
        }
  }
}

stage('End-to-end tests') {
  node ('test') {
    checkout scm
    dir('robot-tests') {
      sh 'mkdir -p tests/results'
      docker.withServer('tcp://127.0.0.1:4243') {
        docker.image('robot:latest').inside('--privileged=true -v $WORKSPACE/robot-tests/tests:/robot') {
          sh 'export ROBOT_TESTS=/robot/e2etests.robot;export PARAMETERS="-V /robot/test-env.py"; run-robot.sh'
        }
        sh 'docker logs $(docker ps -a | grep robot | head -1 | cut -d \' \' -f 1)'
      }
    }
  }
}

stage('Install to UAT') {
  input message: 'Do you want to install this build to UAT env?', ok: 'Install to UAT'
  node {
    docker.withRegistry('https://docker-registry-default.cloudapps.ocp-tdemo.teco.prd.a.tecdomain.net', 'demoapp-test') {
      docker.withServer('tcp://127.0.0.1:4243') {
        def testimage = docker.image("demoapp-test/demoapp:${env.BUILD_TAG}")
        testimage.push 'uat'
        testimage = docker.image("demoapp-test/repository:${env.BUILD_TAG}")
        testimage.push 'uat'
      }
    }
  }
}

stage('Install to prod') {
  input message: 'Do you want to install this build to prod env?', ok: 'Install to prod'
  node {
    docker.withRegistry('https://docker-registry-default.cloudapps.ocp-tdemo.teco.prd.a.tecdomain.net', 'demoapp-test') {
      docker.withServer('tcp://127.0.0.1:4243') {
        def testimage = docker.image("demoapp-test/demoapp:${env.BUILD_TAG}")
        testimage.push 'prod'
        testimage = docker.image("demoapp-test/repository:${env.BUILD_TAG}")
        testimage.push 'prod'
      }
    }
  }
}
