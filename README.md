infra-push
============

General usage: 

Once code is in place (see below for recipe), use create-keypair.sh to generate a keypair.  Code is written so that the hostnames and loadbalancer name are keyed off the keypair name.  This way we can manage multiple clusters with the same code, just changing the keypair name on the command line. 

Once the keypair is created, use create-instances.sh <keyname> [hostcount] to create the ec2 instances.  keyname is required, and hostcount defaults to 4 if not specified.

Once loadbalancer is initialized, all hosts should be available behind elb.  index.html is untouched, 
test file is pushed to servers as http://<host>/home.html.  File is created from home.shtml and pushed
as part of initialization process. File has hostname inserted in an html comment.

Arbitary code can be pushed out to the servers using push-prod.sh <keyname> <file>.

=============

    #
    # Installation recipe for creating hosting environment from scratch.
    #
    git clone https://github.com/petercoe/infra-push.git
    cd infra-push
    # download and extract into infra-push http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip EC2 api tools
    # download and extract into infra-push http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip - Elastic Load Balancer utilities
    # update setvariables.{csh,sh} with any updated paths (Java, EC2 version etc)
    # source setvariables.{csh,sh}
    create-keypair.sh <Keyname>
    ec2-authorize default -p 22
    ec2-authorize default -p 80
    create-instances.sh <Keyname> <number of hosts>

Code can be commited back into git tree by usual git commands.
============
Bonobos - Infrastructure Coding Challenge

Given:

    HTML file that displays "FOO" when viewed in browser
    Configuration files and HTML are stored and version controlled at Github.com
    Assume that you have AWS access keys with full privileges to all AWS services
    Assume that once Apache is appropriately configured and started, that the webserver is in a fully functional state

 

Do:

    Create 4 identical, functional web servers with identical HTML files from a consistent version in github
    All 4 web servers should be accessible by a single DNS record, IE fronted by an Elastic Load Balancer
    The mechanism to create, deploy, configure the stack should not involve the AWS web console at all
    Can be multi-step process orchestration, image-based deployment, or (not limited to) a monolithic script/program/service. 
    Bonus points for creating/managing an auto-scaling group, "automagic" DNS management, or any other optimization/refactor that you think is a net win.
    Extra bonus points if you can account for patching and/or release orchestration


Constraints:

    With the exception of creating and retrieving AWS keys, no part of your solution should require use of the AWS Web Console.
