# zbrew
_zbrew_ is an experimental idea for z/OS package management.

_zbrew_ lets you search, secure, install, and configure software on z/OS using a prescriptive approach, 
especially with respect to naming conventions for the software. 

***zbrew Development Philosophy***

1. Automation is paramount. The only way to achieve drastic time reduction is through automation
2. Since our philosophy is to work with an automated, prescriptive approach, zbrew must define it's own set of 
_Best Practices for z/OS Automated Software Installation_ and Configuration to achieve #1  
3. _zbrew_ will not be useful with an all-or-nothing approach. _zbrew_ needs to interact with traditional 
software installation and configuration
4. _zbrew_ needs feedback to ensure these _Best Practices_ can be applied to real-world shops

***zbrew Divide and Conquer Model***

z/OS is a complex, multi-tenant, multi-application operating system responsible for running the world's largest businesses. 
As such, installing and configuring software can require multiple people to be involved in the process along with 
product-specific installation requirements. In addition, it is critical that z/OS software installation and configuration
be automated so that the specialized skills of systems programmers can be used for higher level tasks rather than mundane 
and error prone manual installation and configuration. Finally, with the emergence of stand-alone dev/test environments 
for use by individuals or small teams, the need for simple, automated installation of z/OS software on these systems 
without the need for systems programmers is becoming more critical. 

_zbrew_ tackles these issues by providing services for common functions (like receiving and applying software from ShopZ), 
and delegating product specific function to the products in question. There are 3 functions that _zbrew_ delegates 
to the underlying product:

- **Prerequisites Checking**: products require other software to function correctly. Before installing the software,
a check needs to be made that the products are available, configured correctly, and with the right level of maintenance.
- **Secure**: products require security changes to be made to function correctly. The security updates would typically 
be performed by a different person on a production system (TBD... not yet in the code base)
- **Installation**: products require datasets to be allocated and zFS directories to be created before an SMP/E apply 
can be performed. 
- **Configuration**: products need to be configured after the software is installed. This configuration step may be as 
simple as running an installation verification program (IVP), but in general, there are quite a few things required to
configure software

***How to install zbrew:***

*From github*
You can download zbrew from github directly into _ZBREWROOT_. You will need to 'build' zbrew before you can use it. To do so:
- cd _ZBREWROOT_/build
- ./build.sh

*From artifactory*
You can also get zbrew from artifactory: https://bintray.com/zbrew/zbrew
To install from artifactory:
- download the latest pax file, and unpax it into a directory _ZBREWROOT_

You will then want to pick up pax files for each software package you want to install. 
Start with _zbrew-zhw_, which is just a hello world package, to ensure it all works. Install all pax files in the _ZBREW\_WORKROOT_ directory. 

If you want to look at any of the source for zbrew, go to:
- https://github.com/zbrewdev/zbrew
There are corresponding git repos for the software packages which have a -<sw> after them, e.g.
- https://github.com/mikefultonbluemix/zbrew-eqa

***How to run zbrew:***

The zbrew program resides in _ZBREWROOT/bin_ directory. You can either run the program with the fully qualified name or you can put the _ZBREWROOT/bin_ directory into your PATH. The instructions that follow assume it is in your PATH. 

If you do not know the name of the product, issue:
- zbrew search _string_
e.g.
- zbrew search debug
which will then tell you that debug is _eqae20_ (EQA 14.2.0)

To install a product, you will need the ORDER JSON file for that product. 
Currently, we support products:
- ordered from ShopZ
- ordered from Passport Advantage
- in the local zFS file system
All ORDER files go into a directory you create called _ZBREW\_WORKROOT/order_ 
The name of the ORDER file is: 
- _sw_ order.json
e.g.
- _zhw110order.json_

*For ShopZ:*
- Go into ShopZ and order your CBPDO software as you normally would. You will be send information on how to install, along with a file called _rfnjobs.txt_
- Copy this file to z/OS under _/tmp/rfnjobs.txt_, then issue:
- _ZBREWROOT/utils/shopzgenorder sw </tmp/rfnjobs.txt >ZBREWROOT/*sw*order.json_, where _sw is the software you are installing, e.g. eqae20

*For Local zFS file system*
- Only zhw110 has been created as a local zFS product. The ORDER file for _zhw110order.json_ is:
```
{
 	"software": [{
		"name":"ZHW110",
		"order":{
			"SMPE_DELIVERY":"LOCAL",
			"SMPE_LOCALREPO":"https://github.com/mikefultonbluemix"
                 }
	}]
}
```


To run zbrew to install and configure a particular software package, issue:
- zbrew install _sw
- zbrew configure _sw
e.g.
- zbrew install zhw110
- zbrew configure zhw110

