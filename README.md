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

<h1>Getting Started</h1>

recommended environment:
- gradle 5.4
- java 1.8

further read: [confluence](https://confluence.ninjavan.co/display/NVQA/D+-+Environment+Setup)

<h2>Run</h2>
from terminal:
1. open terminal & change directory to your order create project
2. run the following command

```gradle --no-daemon --continue \
     clean runCucumber allureReport \
     -Penvironment=qa-sg \
     -Ptags=@order-create \
     -PdbHost="10.80.0.33" \
     -PdbPort=6333 \
     -PdbUser=qa_automation \
     -PdbPass=Jz43S0xG852hcxmG3BAbrs7YWml6x5c4 \
     -PdbEnvironment=qa \
     -PapiBaseUrl="https://api-qa.ninjavan.co" \
     -PsystemId=sg```

from intellij gradle runner:
1. go to configuration, create new gradle config
2. fill in 'Name'
3. fill in 'Tasks' as : clean runCucumber
4. fill in 'Arguments' as : (please be careful with spaces, each variable must be separated with space and each value which contains space has to be in quotation mark "" e.g "not @webhook")

```
-Penvironment=qa-sg -Ptags=@ocv4 -PdbHost="10.80.0.33" -PdbPort=6333 -PdbUser=qa_automation -PdbPass=spMYtbidBKPaAV6BVxG0O9IfBzdMUtwA -PdbEnvironment=qa -PapiBaseUrl="https://api-qa.ninjavan.co" -PsystemId=sg
```
further read: [confluence](https://confluence.ninjavan.co/display/NVQA/E+-+Run+Automation+Project)
