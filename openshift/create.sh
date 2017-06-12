#!/bin/bash

oc new-project demoapp-test
oc project demoapp-test
oc create serviceaccount pusher
oc policy add-role-to-user edit system:serviceaccount:demoapp-test:pusher
oc create -f demoapp-test-project.json

oc new-project demoapp-uat
oc project demoapp-uat
oc policy add-role-to-group system:image-puller system:serviceaccounts:demoapp-uat -n demoapp-test
oc create -f demoapp-uat-project.json

oc new-project demoapp-prod
oc project demoapp-prod
oc policy add-role-to-group system:image-puller system:serviceaccounts:demoapp-prod -n demoapp-test
oc create -f demoapp-prod-project.json

oc project demoapp-test
oc describe sa pusher

echo "Run 'oc describe secret <token-name>' to get the secret token for imager repository account"
