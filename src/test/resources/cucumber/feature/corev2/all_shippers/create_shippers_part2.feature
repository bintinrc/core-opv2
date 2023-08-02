@OperatorV2 @CoreV2 @Shippers @CreateShipper
Feature: Create shipper part1

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Create normal shipper - all field filled
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    Then Operator fill Shipper Information Section with data:
      | Shipper Type         | Normal                          |
      | Shipper Name         | test from automation            |
      | Short Name           | testassad                       |
      | Shipper Phone Number | 4526589856                      |
      | Shipper Email        | testemail@ninjavan.co           |
      | Chanel               | B2B Distribution                |
      | Industry             | Entertainment (Books, Arts etc) |
      | Account Type         | B2C                             |
      | Sales person         | LI-Lianne                       |
    Then Operator fill Shipper Contact Details Section with data:
      | Liaison Name     | testCorev2            |
      | Liaison Contact  | 5626598562            |
      | Liaison Email    | testemail@ninjavan.co |
      | Liaison Address  | test address          |
      | Liaison Postcode | 569933                |
    Then Operator fill Service Offerings Section with data:
      | Parcel Delivery           | Yes                                |
      | Return                    | Yes                                |
      | Marketplace               | No                                 |
      | International             | No                                 |
      | Marketplace International | No                                 |
      | Document                  | No                                 |
      | Corporate                 | No                                 |
      | Corporate Return          | No                                 |
      | Corporate Manual AWB      | No                                 |
      | Corporate Document        | No                                 |
      | Service Level             | Same Day,Next Day,Express,Standard |
    Then Operator fill Operational settings Section with data:
      | Cash on Delivery(COD)               | Yes        |
      | Cash Pickup (CP)                    | Yes        |
      | Prepaid Account                     | Yes        |
      | Staged Orders                       | Yes        |
      | Multi Parcel                        | Yes        |
      | Allow Driver Reschedule             | Yes        |
      | Enforce Pickup Scanning             | Yes        |
      | Allow Enforce Delivery Verification | Yes        |
      | Delivery Address Validation         | Yes        |
      | No of Digits in delivery            | 5          |
      | No of validation attemps            | 4          |
      | Tracking type                       | Fixed      |
      | Prefix                              | RANDOM     |
      | Show Shipper Details                | Yes        |
      | Show COD                            | Yes        |
      | Show Parcel Description             | Yes        |
      | Printer IP                          | 123.12.2.1 |
    Then Operator fill Failed Delivery Management Section with data:
      | Shipper Bucket              | Pending |
      | XB Fulfillment Setting      | Yes     |
      | No. of Free Storage Days    | 15      |
      | No. of Maximum Storage Days | 46      |
    Then Operator click in more settings tab in shipper create edit page
    Then Operator Add new address in More Settings Section with data:
      | Contact Name          | testName         |
      | Contact Mobile Number | 5625985685       |
      | Contact Email         | test@ninjavan.co |
      | Pickup Address 1      | test address     |
      | Pickup Address 2      | test address2    |
      | Country               | Singapore        |
      | Pickup Postcode       | 569933           |
      | Latitude              | 1.3521           |
      | Longitude             | 103.8198         |
    Then Operator fill More Settings Section with data:
      | Shipper Customer Reservation                      | Yes            |
      | Allow premium pickup on Sunday                    | Yes            |
      | Premium pickup daily limit                        | 3              |
      | Service Level                                     | Premium        |
      | Default Pickup Time Selector                      | 9AM - 12PM     |
      | Returns for this Shipper                          | Active         |
      | Pickup Address 2                                  | test           |
      | Return City                                       | test           |
      | Last Return Number                                | 3              |
      | Integrated Vault                                  | Yes            |
      | Collect Customer NRIC Code                        | Yes            |
      | Return on DBMS                                    | Yes            |
      | Return on Vault                                   | Yes            |
      | Returns on Shipper Lite                           | Yes            |
      | Allow Fully Integrated Ninja Collect              | Yes            |
      | Allow doorstep delivery for no capacity scenarios | Yes            |
      | DPMS Logo URL                                     | https://tt.com |
      | Vault Logo URL                                    | https://tt.com |
      | Shipper Lite Logo URL                             | https://tt.com |
      | Eligible Service Levels for Ninja Collect         | SAMEDAY        |
      | Deadline Fallback Action                          | Doorstep       |
      | Transit Shipper                                   | Yes            |
      | Transit Customer                                  | Yes            |
      | Completed Shipper                                 | Yes            |
      | Completed Customer                                | Yes            |
      | Pickup fail Shipper                               | Yes            |
      | Pickup fail Customer                              | Yes            |
      | Delivery fail Shipper                             | Yes            |
      | Delivery fail Customer                            | Yes            |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator fill Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |
    Then Operator Add new profile in Pricing and Billing Section with data:
      | End Date        | {gradle-next-3-day-yyyy-MM-dd} |
      | Pricing Scripts | 6 - 1234                       |
      | Comments        | test                           |
      | Discount Value  | 1                              |
    Then Operator save new shipper
    Then Operator verify Shipper Information Section with data:
      | Shipper Status       | Active                          |
      | Shipper Type         | Normal                          |
      | Shipper Name         | test from automation            |
      | Short Name           | testassad                       |
      | Shipper Phone Number | 4526589856                      |
      | Shipper Email        | testemail@ninjavan.co           |
      | Chanel               | B2B Distribution                |
      | Industry             | Entertainment (Books, Arts etc) |
      | Account Type         | B2C                             |
      | Sales person         | LI-Lianne                       |
    Then Operator verify Shipper Contact Details Section with data:
      | Liaison Name     | testCorev2            |
      | Liaison Contact  | 5626598562            |
      | Liaison Email    | testemail@ninjavan.co |
      | Liaison Address  | test address          |
      | Liaison Postcode | 569933                |
    Then Operator verify Service Offerings Section with data:
      | Parcel Delivery           | Yes                                |
      | Return                    | Yes                                |
      | Marketplace               | No                                 |
      | International             | No                                 |
      | Marketplace International | No                                 |
      | Document                  | No                                 |
      | Corporate                 | No                                 |
      | Corporate Return          | No                                 |
      | Corporate Manual AWB      | No                                 |
      | Corporate Document        | No                                 |
      | Service Level             | Same Day,Next Day,Express,Standard |
    Then Operator verify Operational settings Section with data:
      | Cash on Delivery(COD)               | Yes                  |
      | Cash Pickup (CP)                    | Yes                  |
      | Prepaid Account                     | Yes                  |
      | Staged Orders                       | Yes                  |
      | Multi Parcel                        | Yes                  |
      | Allow Driver Reschedule             | Yes                  |
      | Enforce Pickup Scanning             | Yes                  |
      | Allow Enforce Delivery Verification | Yes                  |
      | Delivery Address Validation         | Yes                  |
      | No of Digits in delivery            | 5                    |
      | No of validation attemps            | 4                    |
      | Tracking type                       | Fixed                |
      | Prefix                              | {KEY_SHIPPER_PREFIX} |
      | Show Shipper Details                | Yes                  |
      | Show COD                            | Yes                  |
      | Show Parcel Description             | Yes                  |
      | Printer IP                          | 123.12.2.1           |
    Then Operator verify Failed Delivery Management Section with data:
      | Shipper Bucket              | Pending |
      | XB Fulfillment Setting      | Yes     |
      | No. of Free Storage Days    | 15      |
      | No. of Maximum Storage Days | 46      |
    Then Operator click in more settings tab in shipper create edit page
    Then Operator verify More Settings Section with data:
      | Shipper Customer Reservation                      | Yes            |
      | Allow premium pickup on Sunday                    | Yes            |
      | Premium pickup daily limit                        | 3              |
      | Service Level                                     | Premium        |
      | Default Pickup Time Selector                      | 9AM - 12PM     |
      | Returns for this Shipper                          | Active         |
      | Pickup Address 2                                  | test           |
      | Return City                                       | test           |
      | Last Return Number                                | 3              |
      | Integrated Vault                                  | Yes            |
      | Collect Customer NRIC Code                        | Yes            |
      | Return on DBMS                                    | Yes            |
      | Return on Vault                                   | Yes            |
      | Returns on Shipper Lite                           | Yes            |
      | Allow Fully Integrated Ninja Collect              | Yes            |
      | Allow doorstep delivery for no capacity scenarios | Yes            |
      | DPMS Logo URL                                     | https://tt.com |
      | Vault Logo URL                                    | https://tt.com |
      | Shipper Lite Logo URL                             | https://tt.com |
      | Eligible Service Levels for Ninja Collect         | SAMEDAY        |
      | Deadline Fallback Action                          | Doorstep       |
      | Transit Shipper                                   | Yes            |
      | Transit Customer                                  | Yes            |
      | Completed Shipper                                 | Yes            |
      | Completed Customer                                | Yes            |
      | Pickup fail Shipper                               | Yes            |
      | Pickup fail Customer                              | Yes            |
      | Delivery fail Shipper                             | Yes            |
      | Delivery fail Customer                            | Yes            |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator verify Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Create normal shipper - mandatory field
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    Then Operator fill Shipper Information Section with data:
      | Shipper Type         | Normal                |
      | Shipper Name         | test from automation  |
      | Shipper Phone Number | 4526589856            |
      | Shipper Email        | testemail@ninjavan.co |
      | Sales person         | LI-Lianne             |
    Then Operator fill Shipper Contact Details Section with data:
      | Liaison Address | test address |
    Then Operator fill Service Offerings Section with data:
      | Parcel Delivery           | Yes |
      | Return                    | Yes |
      | Marketplace               | No  |
      | International             | No  |
      | Marketplace International | No  |
      | Document                  | No  |
      | Corporate                 | No  |
      | Corporate Return          | No  |
      | Corporate Manual AWB      | No  |
      | Corporate Document        | No  |
    Then Operator fill Operational settings Section with data:
      | Prefix | RANDOM |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator fill Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |
    Then Operator Add new profile in Pricing and Billing Section with data:
      | End Date        | {gradle-next-3-day-yyyy-MM-dd} |
      | Pricing Scripts | 6 - 1234                       |
      | Comments        | test                           |
      | Discount Value  | 1                              |
    Then Operator save new shipper
    Then Operator verify Shipper Information Section with data:
      | Shipper Type         | Normal                |
      | Shipper Name         | test from automation  |
      | Shipper Phone Number | 4526589856            |
      | Shipper Email        | testemail@ninjavan.co |
      | Sales person         | LI-Lianne             |
    Then Operator verify Shipper Contact Details Section with data:
      | Liaison Address | test address |
    Then Operator verify Service Offerings Section with data:
      | Parcel Delivery           | Yes |
      | Return                    | Yes |
      | Marketplace               | No  |
      | International             | No  |
      | Marketplace International | No  |
      | Document                  | No  |
      | Corporate                 | No  |
      | Corporate Return          | No  |
      | Corporate Manual AWB      | No  |
      | Corporate Document        | No  |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator verify Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Create marketplace shipper - mandatory field
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    Then Operator fill Shipper Information Section with data:
      | Shipper Type         | Marketplace           |
      | Shipper Name         | test from automation  |
      | Shipper Phone Number | 4526589856            |
      | Shipper Email        | testemail@ninjavan.co |
      | Sales person         | LI-Lianne             |
    Then Operator fill Shipper Contact Details Section with data:
      | Liaison Address | test address |
    Then Operator fill Service Offerings Section with data:
      | Parcel Delivery           | Yes |
      | Return                    | Yes |
      | Marketplace               | Yes |
      | International             | No  |
      | Marketplace International | Yes |
      | Document                  | No  |
      | Corporate                 | No  |
      | Corporate Return          | No  |
      | Corporate Manual AWB      | No  |
      | Corporate Document        | No  |
    Then Operator fill Operational settings Section with data:
      | Prefix | RANDOM |
    Then Operator click in Marketplace settings tab in shipper create edit page
    Then Operator fill More Settings Section with data:
      | Premium pickup daily limit marktplace | 3 |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator fill Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |
    Then Operator Add new profile in Pricing and Billing Section with data:
      | End Date        | {gradle-next-3-day-yyyy-MM-dd} |
      | Pricing Scripts | 6 - 1234                       |
      | Comments        | test                           |
      | Discount Value  | 1                              |
    Then Operator save new shipper
    Then Operator verify Shipper Information Section with data:
      | Shipper Type         | Marketplace           |
      | Shipper Name         | test from automation  |
      | Shipper Phone Number | 4526589856            |
      | Shipper Email        | testemail@ninjavan.co |
      | Sales person         | LI-Lianne             |
    Then Operator verify Shipper Contact Details Section with data:
      | Liaison Address | test address |
    Then Operator verify Service Offerings Section with data:
      | Parcel Delivery           | Yes |
      | Return                    | Yes |
      | Marketplace               | Yes |
      | International             | No  |
      | Marketplace International | Yes |
      | Document                  | No  |
      | Corporate                 | No  |
      | Corporate Return          | No  |
      | Corporate Manual AWB      | No  |
      | Corporate Document        | No  |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator verify Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |

  @DeleteNewlyCreatedShipperCommonV2
  Scenario: Create corporate shipper - mandatory field
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    Then Operator fill Shipper Information Section with data:
      | Shipper Type         | Corporate HQ          |
      | Shipper Name         | test from automation  |
      | Shipper Phone Number | 4526589856            |
      | Shipper Email        | testemail@ninjavan.co |
      | Sales person         | LI-Lianne             |
    Then Operator fill Shipper Contact Details Section with data:
      | Liaison Address | test address |
    Then Operator fill Service Offerings Section with data:
      | Parcel Delivery           | Yes |
      | Return                    | Yes |
      | Marketplace               | No  |
      | International             | No  |
      | Marketplace International | No  |
      | Document                  | No  |
      | Corporate                 | Yes |
      | Corporate Return          | Yes |
      | Corporate Manual AWB      | Yes |
      | Corporate Document        | Yes |
    Then Operator fill Operational settings Section with data:
      | Prefix | RANDOM |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator fill Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |
    Then Operator Add new profile in Pricing and Billing Section with data:
      | End Date        | {gradle-next-3-day-yyyy-MM-dd} |
      | Pricing Scripts | 6 - 1234                       |
      | Comments        | test                           |
      | Discount Value  | 1                              |
    Then Operator save new shipper
    Then Operator verify Shipper Information Section with data:
      | Shipper Name         | test from automation  |
      | Shipper Phone Number | 4526589856            |
      | Shipper Email        | testemail@ninjavan.co |
      | Sales person         | LI-Lianne             |
    Then Operator verify Shipper Contact Details Section with data:
      | Liaison Address | test address |
    Then Operator verify Service Offerings Section with data:
      | Parcel Delivery           | Yes |
      | Return                    | Yes |
      | Marketplace               | No  |
      | International             | No  |
      | Marketplace International | No  |
      | Document                  | No  |
      | Corporate                 | Yes |
      | Corporate Return          | Yes |
      | Corporate Manual AWB      | Yes |
      | Corporate Document        | Yes |
    Then Operator click in Pricing and Billing tab in shipper create edit page
    Then Operator verify Billing information in Pricing and Billing Section with data:
      | Billing Name      | test name    |
      | Billing Contact   | 5698569859   |
      | Billing Address   | test address |
      | Billing Post Code | 45685        |