## Background Information

This was build out of the need to send data between Salesforce and custom applications without saving Salesforce username and password in a config file outside of Salesforce. Rather than using OAuth to communicate to Salesfroce from the application, the decision was made to send the data to AWS then have either Salesforce or the custom application send or receive the data for process. This allowed for sending data in and out of Salesforce without having to store Salesforce username and password in a config file (or equivalent) on external systems. 

I had to rebuild this from scratch so I apologize ahead of time for any issues, but I am more than willing to help get you up and running. The most important file is [AmzAwsSender.cls](https://github.com/userraj/sfdc-aws-sign4/blob/master/classes/AmzAwsSender.cls) as it contains the logic required for AWS Signature Version 4. You can use the class to both send and receive data. 

I did not see any open source version of this so I decided to make this public to help others who may want to do the same. I work full time so I will try to respond to queries asap so appreciate the patience ahead of time. I also developed a similar process to send data to Microsoft Azure using [Service Bus authentication with Shared Access Signatures](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-sas). A direct link to that repository can be found [here](https://github.com/userraj/sfdc-microsoft-azure-service-bus)

## Getting Started

I would like to stress the importance of keeping up with the latest changes in regards to [AWS Signature Version 4 Signing Process](https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html). The process may change faster than I can update the code. 

## Considerations

* Ensure you follow the most up to date signing process
* Test classes were added in order to assure code coverage, but you just need to use the [AmzAwsSender](https://github.com/userraj/sfdc-aws-sign4/blob/master/classes/AmzAwsSender.cls). It will allow you to send data to AWS endpoint in JSON format. 
* [AmzAwsSenderTest](https://github.com/userraj/sfdc-aws-sign4/blob/master/classes/AmzAwsSenderTest.cls) highlights an example usage of how to send data to AWS. This will need to be modified to best meet your situation.
* I purposedly did not include a test mock callout because I do not have access to a live instance so assume you will need to create one according to [Salesforce's example](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing_httpcalloutmock.htm)
* For companies with multiple sandboxes and a production org, I would recommend using [forcedevtool](https://github.com/amtrack/force-dev-tool) to help manage differences between versions. This is an awesome tool that will make continuous integration easy.

## AWS Connection Object

AWS Connection was a custom object created to store the configurations of the connection between Salesforce and AWS endpoint. The main reason for choosing a custom object was because of the text(encrypted) field type, which is currently not available on custom settings nor custom metatdata types. Text (Encrypted) field type allows for an administrator to get the necessary security tokens that are needed for the AWS signing process to be stored securely. Through testing, I found that after I insert the key value into the field, I was no longer able to see what the value was because it was masked with characters. After attempting to access the value via [Apex Data Loader](https://developer.salesforce.com/page/Data_Loader) and other similar tools that allow for API access, I could not access the values, all I got was the masked characters, which made this a very secure option. 

Field History tracking was added just in case a value was changed incedently. 

* For more information, see [About Encrypted Fields](https://help.salesforce.com/articleView?id=fields_about_encrypted_fields.htm&type=5) for more information.

## AWS Log Entry Object

This object was mainly added for logging purposes from Salesforce regardless of sending or receiving. It contains the basic fields such as the body, header, status, and status code. Whether or not you use this is totally dependent on the use case. If you have a method of logging requests then this may be overkill, but for those who do not have access to proper logging mechanisms, this object can be used to store any exceptions or successful requests to and from AWS. 

### Prerequisites

What things you need to install the software and how to install them

```
* Install Ant Migration Tool (or MavenMate, Force.com IDE)
* Install Git
```

## Running the tests

* Test classes can be run through the command line via a tool such as [forcedevtool](https://github.com/amtrack/force-dev-tool), Force.com IDE, or through the [Developer Console](https://developer.salesforce.com/page/Developer_Console)

## Batch Job

Given that there are [Apex Callout Limits](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts_timeouts.htm), you should write a batch class that will process all the records you need, insert it into a single JSON with your desired format, and then make one callout. A future release will be to write one in this repository, but given time limits, the dates are to be determined.

## Deployment

* Download the repo
* Using [Ant Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool.htm) deploy to your sandbox for further testing

## Built With

* [Git](https://git-scm.com/) - Version Control System
* [Ant Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool_install.htm) - Used for exporting and importing metadata

## Versioning

I use [Git](https://git-scm.com/) for versioning.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](https://github.com/userraj/sfdc-aws-sign4/blob/master/LICENSE) file for details

