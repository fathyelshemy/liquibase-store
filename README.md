# Getting Started
this is liquibase sample project to demo ideas for rollback
## Main Target for this repo is to practice on liquibase 

#### setup project 
to run the project you must install the following 
#### prerequisites 
- install [JDK-17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html) or more
- install [maven](https://maven.apache.org/download.cgi)
- install [liquibase](https://www.liquibase.com/download)

#### rollback feature
automatic rollback is not support for sql, it's support only for agnostic language model (XML, YAML, JSON) for more
info check [automatic and custom rollback](https://docs.liquibase.com/workflows/liquibase-community/automatic-custom-rollbacks.html)
###### - What's rollback? 
rollback if a feature that's can undo your applied change from database it has set of use-case like
* revert  not ready changes from pushing  production 
###### - How to apply setup rollback?


liquibase provide us 3 ways to rollback set of changes 

* Count 
* TimeStamp
* Tag 

## problem? 
### use case 1:
In a shared service we sql script that's deployed on DEV env and still in testing so shouldn't push for UAT now , another script is ready and  urgent need to push without ```cherry-pick``` because of 2 files are tightly couples ?
### use case 2:
:) super case of requirement change in the middle of sprint so you lookup table might be change or need to revert back some data 
#### process flow for rollback (rollback strategy)
##### current strategy
we're using ```fast-forward``` strategy currently I've some changes which is I don't want to push for next environment (UAT for example),then we should add new file contains anti-script (sql script) to rollback changes
###### Pros
- easy to implement 
- only add when it's needed 
###### cons 
- messy of new files added 
- when new file script failed take time to recover and customer might be impacted

##### Suggested strategy
* Must use ```--rollback ``` attribute in every liquibase sql script to run  anti-script (undo script)
* Deploying ```do sql script``` should run liquibase tag commend ```liquibase --changeLogFile=changelog.xml  tag --tag <git Tag version>```
* Try rollback changes locally first using one of rollback commit and check everything if fine on working as expected 
* Provide new pipeline for rollback changes on target ENV
* remove rolled back file from git repo 
* re-run new pipeline to apply changes without removed files 
###### Pros
- our system be more automatic 
- save files mess by saving creating new files 
###### cons
- more difficult to implement
- need all team be knowledgeable about the steps and do it exactly (required more and more controller on new files scripts)

### Guides

The following guides illustrate how to use some features concretely:

* [liquibase documentation](https://docs.liquibase.com/home.html)

