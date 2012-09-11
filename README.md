bonobos-push
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
