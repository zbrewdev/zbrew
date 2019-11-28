# zbrew
_zbrew_ is an experiment, patterned after the popular Mac install technology **brew**. 

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
