# Introduction

## run command 
`gradle clean runCucumber -Penvironment=corev2-qa-sg -Ptags="@CWF and (@ShouldAlwaysRun or @RT)"`

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
