# Introduction

## Developer Guide

To run it through intellij, you can either add the following arguments:
### QA Environment
```
-Penvironment=hub-qa-sg
-Ptags="@CWF and (@ShouldAlwaysRun or @RT)"
-PdbHost="10.80.0.33"
-PdbPort=6333
-PdbUser=qa_automation
-PdbPass=Jz43S0xG852hcxmG3BAbrs7YWml6x5c4
-PdbEnvironment=qa
-PapiBaseUrl="https://api-qa.ninjavan.co"
-PsystemId=sg
-PseleniumDriver=CHROME
-PseleniumDriverVersion=89
-PseleniumHeadless=False
--continue
```
### GAIA Environment (qa-gaia-1 for this case)
```
-Penvironment=hub-qa-release-sg
-Ptags="@CWF and (@ShouldAlwaysRun or @RT)"
-PdbHost="release-global-mysql-5-7-28.qa-gaia-1.svc.cluster.local"
-PdbPort=3306
-PdbUser=root
-PdbPass=SrmDHYwQ8v4CwjNyF9VvwCL2V8ej0XMB
-PdbEnvironment=release
-PapiBaseUrl="https://api-qa-gaia-1.ninjavan.io"
-PsystemId=sg
-PseleniumDriver=CHROME
-PseleniumDriverVersion=89
-PseleniumHeadless=False
--continue
```