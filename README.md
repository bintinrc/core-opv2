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
1. open terminal & change directory to your operator v2 project
2. run the following command

QA environment :

```
gradle --no-daemon --continue \
    clean runCucumber allureReport \
    -Dfile.encoding=UTF8 \
    -Penvironment=${service-name}-qa-sg \
    -Ptags=@opv2 \
    -PdbHost="10.80.0.33" \
    -PdbPort=6333 \
    -PdbUser=qa_automation \
    -PdbPass=Jz43S0xG852hcxmG3BAbrs7YWml6x5c4 \
    -PdbEnvironment=qa \
    -PapiBaseUrl="https://api-qa.ninjavan.co" \
    -PsystemId=sg \
    -PseleniumDriver=CHROME \
    -PseleniumDriverVersion=89 \
    -PseleniumHeadless=true
```

GAIA environment :
```
gradle --no-daemon --continue \
    clean runCucumber allureReport \
    -Penvironment=${service-name}-release-sg \
    -Ptags=@opv2 \
    -PdbHost="release-global-mysql-5-7-28.${gaia-release-name}.svc.cluster.local" \
    -PdbPort=3306 \
    -PdbUser=root \
    -PdbPass=SrmDHYwQ8v4CwjNyF9VvwCL2V8ej0XMB \
    -PdbEnvironment=release \
    -PapiBaseUrl="https://api-${gaia-release-name}.ninjavan.io" \
    -PsystemId=sg \
    -PseleniumDriver=CHROME \
    -PseleniumDriverVersion=89 \
    -PseleniumHeadless=true
```

from intellij gradle runner:
1. go to configuration, create new gradle config
2. fill in 'Name'
3. fill in 'Tasks' as : clean runCucumber
4. fill in 'Arguments' as : (please be careful with spaces, each variable must be separated with space and each value which contains space has to be in quotation mark "" e.g "not @opv2-core")


QA environment :
```
clean runCucumber
-Penvironment=core-qa-sg
-Ptags="@CWF and (@RT or @ShouldAlwaysRun)"
-PdbHost="mysql-6333.qa.db.nv"
-PdbPort=6333
-PdbUser=qa_automation
-PdbPass=Jz43S0xG852hcxmG3BAbrs7YWml6x5c4
-PdbEnvironment=qa
-PapiBaseUrl="https://api-qa.ninjavan.co"
-PsystemId=sg
-PdbQaHost="mysql-6333.qa.db.nv"
-PdbQaPort=6333
-PdbQaSchema=qa_automation
-PdbQaUser=qa_automation
-PdbQaPass=Jz43S0xG852hcxmG3BAbrs7YWml6x5c4
-PseleniumDriver=CHROME
-PseleniumDriverVersion="97.0"
-PseleniumHeadless=false
```

GAIA environment :

```
-Penvironment=${service-name}-release-sg
-Ptags=@opv2
-PdbHost="release-global-mysql-5-7-28.${gaia-release-name}.svc.cluster.local"
-PdbPort=3306
-PdbUser=root
-PdbPass=SrmDHYwQ8v4CwjNyF9VvwCL2V8ej0XMB
-PdbEnvironment=release
-PapiBaseUrl="https://api-${gaia-release-name}.ninjavan.io"
-PsystemId=sg
-PseleniumDriver=CHROME
-PseleniumDriverVersion=89
-PseleniumHeadless=true
```

further read: [confluence](https://confluence.ninjavan.co/display/NVQA/Run+an+automation+project)

feature's structure:

```
root
|
|__ sort
|  |
|  |__ inbounding
|  |   |__ global_inbound.feature 
|  |   |__ facilities_management.feature
|__ core
|  |
|  |__ inbounding
|  |   |
|  |   |__ global_inbound.feature 
|__ dash
|  |
|  |__ shipper
|  |   |
|  |   |__ 
```
