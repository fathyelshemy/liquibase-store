# Getting Started

## Main Target for this repo is to practice on liquibase 

#### setup project 

#### rollback feature
###### - What's rollback? 
rollback if a feature that's can undo your applied change from database it has set of usecase like
* revert  not ready changes from pushing  production 
###### - How to apply setup rollback?
on

liquibase provide us 3 ways to rollback set of changes 

* Count 
* TimeStamp
* Tag 

#### process flow for rollback (rollback strategy)

##### current 

##### Suggested 
* Must use ```--rollback ``` attribute in every liquibase sql script to run  anti-script (undo script)
* Deploying ```do sql script``` should run liquibase tag commend ```liquibase --changeLogFile=changelog.xml  tag --tag <git Tag version>```
* Try rollback changes locally first using one of rollback commit and check everything if fine on working as expected 
* Provide new pipeline for rollback changes on target ENV
* remove rolled back file from git repo 
* re-run new pipeline to apply changes without removed files 

### Guides

The following guides illustrate how to use some features concretely:

* [liquibase documentation](https://docs.liquibase.com/home.html)

