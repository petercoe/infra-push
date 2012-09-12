#
# set tcsh/csh variables
#
# setenv JAVA_HOME `/usr/libexec/java_home -v 1.6`
setenv JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64
setenv API_TOOLS ec2-api-tools-1.6.1.5
setenv PUSHDIR /home/pete/source/infra-push
setenv PATH ${PUSHDIR}/ec2-api-tools-1.6.1.5/bin:${PATH}
setenv EC2_HOME ${PUSHDIR}/${API_TOOLS}/
setenv EC2_PRIVATE_KEY   ${PUSHDIR}/pk-V7VWR7TTPH37Q3HV66WEKCXIQZQLBBQY.pem
setenv EC2_CERT  ${PUSHDIR}/cert-V7VWR7TTPH37Q3HV66WEKCXIQZQLBBQY.pem
setenv EC2_URL https://ec2.us-west-1.amazonaws.com

setenv AWS_ELB_HOME ${PUSHDIR}/ElasticLoadBalancing-1.0.17.0
setenv PATH ${AWS_ELB_HOME}/bin:${PATH}

