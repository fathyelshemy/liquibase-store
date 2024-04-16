# Getting Started
this is liquibase sample project to demo ideas for 
rollback and how to build docker images to update & rollback both by tage
## what's the problem?
### use case 1:
In a shared service we sql script that's deployed on DEV env and still in testing so shouldn't push for UAT now , another script is ready and  urgent need to push without ```cherry-pick``` because of 2 files are tightly couples ?
### use case 2:
:) super case of requirement change in the middle of sprint so you lookup table might be change or need to revert back some data

## Main Target for this repo is to practice on liquibase 
### explanation  liquibase rollback feature
#### rollback feature
 how we undo already applied changes on database liquibase are supprt partial kind of rollback for agnositic schema (``` yaml``` & ``` xml``` & ``` json```) and for some command for more info kindly check [automatic and custom rollback](https://docs.liquibase.com/workflows/liquibase-community/automatic-custom-rollbacks.html) 
so automatic rollback is not support for sql, so we're trying to show how we can do that using docker 
###### - How to apply setup rollback?
liquibase provide us 3 ways to rollback set of changes

* Count --> ```liquibase --changeLogFile=changelog.xml  rollbackCount <Number>```
    - used to rollback starting from  the latest then pop up to execute rollback-scripts for the same provided number it's more like ```~head``` pointer in ```git revert```
* TimeStamp --> ```liquibase --changeLogFile=changelog.xml  rollbackToDate "2024-04-13 15:55:31.090928"```
  - used to rollback starting from  today then pop up to execute rollback-scripts until the  provided date 
* Tag --> ``` liquibase --changeLogFile=changelog.xml  rollback"```
  - used to rollback starting from  the latest snapshot version to the target tag version

#### process flow for rollback (rollback strategy)
##### fix-forward
we're using ```fix-forward``` strategy currently I've some changes which is I don't want to push for next environment (UAT for example),then we should add new file contains anti-script (sql script) to rollback changes
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

#### setup project 
to run the project you must install the following 
#### prerequisites 
- install [JDK-17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html) or more
- install [maven](https://maven.apache.org/download.cgi)
- install [liquibase](https://www.liquibase.com/download)

#### how to run project 
 - start with main branch  ```git checkout main```

we prepare 2 docker files for update & rollback liquibase scripts
- ```migrations.Dockerfile``` --> used to update database then tag database from env-variable```gitTag``` 
    - apply liquibase update command using docker image 
        - we should build docket image  using ``` docker build  -f migrations.Dockerfile -t liquibase_store_image . ``` 
        - use  docker image we built it before to apply update & tag command using 
      ```
      docker run --rm --name liquibase_store_image \
      --network liquibase_experiment -e URL=jdbc:postgresql://d360_postgres:5432/liquibasestore \
      -e CONTEXTS=prod \
      -e USERNAME=postgres \
      -e PASSWORD=silic0n \
      -e gitTag=1.1.1_dev liquibase_store_image
      ```
        - after successful run we should check ```databasechangelog```  table we'll find notice ```tag``` column you'll find entered tag by cmd on the latest row
      ```
      | id | author       | filename                                          | orderexecuted | description | tag        | liquibase | contexts |
      | :- | :----------- | :-----------------------------------------------  | :------------ | :---------- | :--------- | :-------- | :------- |
      | 1  | fathyelshemy | changelog/01\_store\_initial\_product\_schema.sql | 1             | sql         | null       | 4.27.0    | prod     |
      | 1  | fathyelshemy | changelog/02\_insert\_rows.sql                    | 2             | sql         | 1.1.1_dev  | 4.27.0    | prod     |
      ```
        - we should remove build image ``` liquibase_store_image ``` to build new one with every liquibase change (should done by devops pipeline )
            using ``` docker rmi liquibase_store_image ```
      
- ``` migrations.rollback.Dockerfile``` --> used rollback operation based on tag received from env-variable ```gitTag```
    - we can build rollback image using the following command  ``` docker build  -f migrations.rollback.Dockerfile -t liquibase_store_rollack_image .``` to build image which will use later to rollback 

- then checkout ``` changes_to_rollback``` branch 
at that branch I just added more sql file to demo the rollback after run the first update& tag image
  - we should build docket image  using ``` docker build  -f migrations.Dockerfile -t liquibase_store_image . ```
  - run docker image again with different ```gitTag``` e.g ```1.1.2.dev``` like 
  ```
      docker run --rm --name liquibase_store_image \
      --network liquibase_experiment -e URL=jdbc:postgresql://d360_postgres:5432/liquibasestore \
      -e CONTEXTS=prod \
      -e USERNAME=postgres \
      -e PASSWORD=silic0n \
      -e gitTag=1.1.2_dev liquibase_store_image
  ```
    - then check  ```databasechangelog```  table to see changes on it and confirm from tag column 

```
      | id | author       | filename                                          | orderexecuted | description | tag        | liquibase | contexts |
      | :- | :----------- | :-----------------------------------------------  | :------------ | :---------- | :--------- | :-------- | :------- |
      | 1  | fathyelshemy | changelog/01\_store\_initial\_product\_schema.sql | 1             | sql         | null       | 4.27.0    | prod     |
      | 1  | fathyelshemy | changelog/02\_insert\_rows.sql                    | 2             | sql         | 1.1.1_dev  | 4.27.0    | prod     |
      | 1  | fathyelshemy | changelog/03\_add\_products.sql                   | 3             | sql         | 1.1.2_dev  | 4.27.0    | prod     |

```
 for rollback scenario we should run the following command
 - build rollback image using ``` docker build  -f migrations.rollback.Dockerfile -t liquibase_store_rollack_image .```
 - use built image to run rollback scenario using 
```
 docker run --rm --name liquibase_store_rollack_image \                                                                                           5s  18:57:43
--network liquibase_experiment -e URL=jdbc:postgresql://d360_postgres:5432/liquibasestore \
-e CONTEXTS=prod \
-e USERNAME=postgres \
-e PASSWORD=silic0n \
-e gitTag=1.1.1_dev liquibase_store_rollack_image
```
- then check  ```databasechangelog```  table to see changes on it and confirm from tag column we should notice that 3rd row is remove and our database back 1 step
  ```
  | id | author       | filename                                          | orderexecuted | description | tag        | liquibase | contexts |
  | :- | :----------- | :-----------------------------------------------  | :------------ | :---------- | :--------- | :-------- | :------- |
  | 1  | fathyelshemy | changelog/01\_store\_initial\_product\_schema.sql | 1             | sql         | null       | 4.27.0    | prod     |
  | 1  | fathyelshemy | changelog/02\_insert\_rows.sql                    | 2             | sql         | 1.1.1_dev  | 4.27.0    | prod     |
  ```


### Guides

The following guides illustrate how to use some features concretely:

* [liquibase documentation](https://docs.liquibase.com/home.html)

