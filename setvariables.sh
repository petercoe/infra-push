#
# set tcsh/csh variables
#

# export JAVA_HOME=`/usr/libexec/java_home -v 1.6`
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
export API_TOOLS=ec2-api-tools-1.6.1.5
export PUSHDIR=/home/pete/source/infra-push
export PATH=${PUSHDIR}/ec2-api-tools-1.6.1.5/bin:${PATH}
export EC2_HOME=${PUSHDIR}/${API_TOOLS}/
export EC2_PRIVATE_KEY= ${PUSHDIR}/pk-V7VWR7TTPH37Q3HV66WEKCXIQZQLBBQY.pem
export EC2_CERT=${PUSHDIR}/cert-V7VWR7TTPH37Q3HV66WEKCXIQZQLBBQY.pem
export EC2_URL=https://ec2.us-west-1.amazonaws.com

export AWS_ELB_HOME=${PUSHDIR}/ElasticLoadBalancing-1.0.17.0
export PATH=${AWS_ELB_HOME}/bin:${PATH}

