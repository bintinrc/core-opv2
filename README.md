# Introduction

# Developer Guide

## Use RestAssured url utilities
Whenever you create a request please avoid using `StringBuilder`, `StringBuffer`, or any String manipulation.  
Please use `.baseUri(baseUri)` and use `.get(url, ...params)` to append the url, and replace the params into a value.

```
public static final String ORDER_PATH = "/2.0/orders";
public static final String ORDER_ID_PATH = ORDER_PATH+"/{orderId}";
Response orderDetailsResponse = given()
                .header("Authorization", SingleAPIAccessToken.getShipperBearerTokenHeader())
                .contentType(ContentType.JSON)
                .baseUri(APIEndpoint.API_BASE_URL)
                .when().get(ORDER_ID_PATH, orderId)
                .then()
                .statusCode(HttpConstants.RESPONSE_200_SUCCESS)
                .extract().response();
```

## All URL string should be declared in the corresponding step definitions.

# Previous README content
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
