This whole test can be invoked by the following command:
- gradle cucumber
- gradle test


During project import by JIdea, do not commit "JIdea related" or any "Auto generated" files. e.g.:
- .gradle
- .idea
- build
- gradle
- gradlew
- gradlew.bat
- *.iml


Gradle home location on mac:
/usr/local/Cellar/gradle/2.10/libexec/


To fix language level issue after JIdea import:
- Right click on project
- Choose "Open Module Setting"
- On the "Source" tab, change the language level from "Project Default" to "8"

For cucumber file structure:
Feature file: src/test/resources/cucumber/feature/<MODULE NAME>
Glue file: src/test/java/com/nv/qa/cucumber/glue/<MODULE NAME>



