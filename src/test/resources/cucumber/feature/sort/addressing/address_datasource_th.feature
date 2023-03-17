@Sort @AddressDataSourceTh
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: TH Address Datasource Landing Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verify search field lable:
      | l1 | Province    |
      | l2 | District    |
      | l3 | Subdistrict |
      | l4 | Postcode    |

  Scenario: TH Address Datasource Landing Page - Search Box No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verifies search button is disabled

  Scenario: TH Address Datasource Landing Page - Search Box Invalid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province    | INVALID |
      | district    | INVALID |
      | subdistrict | INVALID |
      | postcode    | INVALID |
    Then Operator verifies no result found on Address Datasource page

  Scenario: TH Address Datasource Landing Page - Search Box 1 of 4 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {province-1} |
    Then Operator verifies new address datasource is added:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | latitude    | {latitude-1}    |
      | longitude   | {longitude-1}   |
      | whitelisted | True            |

  Scenario: TH Address Datasource Landing Page - Search Box 2 of 4 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {province-1} |
      | district | {district-1} |
    Then Operator verifies new address datasource is added:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | latitude    | {latitude-1}    |
      | longitude   | {longitude-1}   |
      | whitelisted | True            |

  Scenario: TH Address Datasource Landing Page - Search Box 3 of 4 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
    Then Operator verifies new address datasource is added:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | latitude    | {latitude-1}    |
      | longitude   | {longitude-1}   |
      | whitelisted | True            |

  Scenario: TH Address Datasource Landing Page - Search Box 4 of 4 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | postcode    | {postcode-1}    |
    Then Operator verifies new address datasource is added:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | latitude    | {latitude-1}    |
      | longitude   | {longitude-1}   |
      | whitelisted | True            |

  @DeleteAddressDatasource
  Scenario: TH Address Datasource - Add a Row with Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {province-2}               |
      | district    | {district-2}               |
      | subdistrict | {subdistrict-2}            |
      | postcode    | {postcode-2}               |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Row Details modal:
      | postcode    | {postcode-2}              |
      | province    | {province-2}              |
      | district    | {district-2}              |
      | subdistrict | {subdistrict-2}           |
      | zone        | {KEY_ZONE_INFO.shortName} |
      | hub         | {KEY_HUB_INFO.name}       |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province    | {KEY_CREATED_ADDRESSING.province}    |
      | district    | {KEY_CREATED_ADDRESSING.district}    |
      | subdistrict | {KEY_CREATED_ADDRESSING.subdistrict} |
      | postcode    | {KEY_CREATED_ADDRESSING.postcode}    |
    Then Operator verifies new address datasource is added:
      | province    | {KEY_CREATED_ADDRESSING.province}    |
      | district    | {KEY_CREATED_ADDRESSING.district}    |
      | subdistrict | {KEY_CREATED_ADDRESSING.subdistrict} |
      | postcode    | {KEY_CREATED_ADDRESSING.postcode}    |
      | latitude    | {KEY_CREATED_ADDRESSING.latitude}    |
      | longitude   | {KEY_CREATED_ADDRESSING.longitude}   |
      | whitelisted | True                                 |

  Scenario: TH Address Datasource - Add a Row with No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    Then Operator verifies Add Button is Disabled

  Scenario: TH Address Datasource - Add a Row with Invalid Latlong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | 1.1,1.11        |
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | postcode    | {postcode-1}    |
      | whitelisted | True            |
    Then Operator verifies Add Button is Disabled
    And Operator verifies invalid latlong message

  Scenario: TH Address Datasource - Add a Row with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | GENERATED    |
      | province    | {province-1} |
      | district    | {district-1} |
      | postcode    | {postcode-1} |
      | whitelisted | True         |
    Then Operator verifies Add Button is Disabled

#  @DeleteAddressDatasource
#  Scenario: TH Address Datasource - Add a Row with Valid Input Duplicate Entry
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given Operator go to menu Addressing -> Address Datasource
#    When Operator clicks on Add a Row Button on Address Datasource Page
#    And Operator fills address parameters in Add a Row modal on Address Datasource page:
#      | latlong     | {latitude-3},{longitude-3} |
#      | province    | {province-3}               |
#      | district    | {district-3}               |
#      | subdistrict | {subdistrict-3}            |
#      | postcode    | {postcode-3}               |
#      | whitelisted | True                       |
#    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
#    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
#    And Operator verify the data source toast:
#      | top  | Datasource Updated |
#      | body | 1 match added      |
#    When Operator refresh page
#    When Operator clicks on Add a Row Button on Address Datasource Page
#    And Operator fills address parameters in Add a Row modal on Address Datasource page:
#      | latlong     | {latitude-2},{longitude-2} |
#      | province    | {province-3}               |
#      | district    | {district-3}               |
#      | subdistrict | {subdistrict-3}            |
#      | postcode    | {postcode-3}               |
#      | whitelisted | True                       |
#    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
#    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
#    And Operator verify the data source toast:
#      | top  | Datasource Updated |
#      | body | 1 match added      |
#    When Operator search the created address datasource:
#      | province    | {KEY_CREATED_ADDRESSING.province}    |
#      | district    | {KEY_CREATED_ADDRESSING.district}    |
#      | subdistrict | {KEY_CREATED_ADDRESSING.subdistrict} |
#      | postcode    | {KEY_CREATED_ADDRESSING.postcode}    |
#    When Operator clicks on Edit Button on Address Datasource Page
#    And Operator fills address parameters in Edit Address modal on Address Datasource page:
#      | latlong     | {latitude-2},{longitude-2} |
#      | province    | {province-3}               |
#      | district    | {district-3}               |
#      | subdistrict | {subdistrict-3}            |
#      | postcode    | {postcode-3}               |
#      | whitelisted | False                      |

  Scenario: TH Address Datasource - Edit Row Form
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {postcode-1} |
    When Operator clicks on Edit Button on Address Datasource Page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasource details in Edit A Row modal:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | postcode    | {postcode-1}    |

  @DeleteAddressDatasource
  Scenario: TH Address Datasource - Edit Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-3},{longitude-3} |
      | province    | {province-3}               |
      | district    | {district-3}               |
      | subdistrict | {subdistrict-3}            |
      | postcode    | {postcode-3}               |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-3}  |
      | longitude | {longitude-3} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province    | {KEY_CREATED_ADDRESSING.province}    |
      | district    | {KEY_CREATED_ADDRESSING.district}    |
      | subdistrict | {KEY_CREATED_ADDRESSING.subdistrict} |
      | postcode    | {KEY_CREATED_ADDRESSING.postcode}    |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province    | {province-3}              |
      | district    | {district-3}              |
      | subdistrict | {subdistrict-3}           |
      | postcode    | {postcode-3}              |
      | zone        | {KEY_ZONE_INFO.shortName} |
      | hub         | {KEY_HUB_INFO.name}       |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {postcode-3} |
    Then Operator verifies new address datasource is added:
      | province    | {province-3}    |
      | district    | {district-3}    |
      | subdistrict | {subdistrict-3} |
      | postcode    | {postcode-3}    |
      | latitude    | {latitude-2}    |
      | longitude   | {longitude-2}   |
      | whitelisted | True            |

  Scenario: TH Address Datasource - Edit Row - Invalid LatLong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {postcode-1} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | 91,90 |
    And Operator verify the latlong error alert:
      | latlongError | Latitude must between -90 to 90 degrees |
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | 89.11111,181 |
    And Operator verify the latlong error alert:
      | latlongError | Longitude must between -180 to 180 degrees |
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | 89.11111,180 |
    And Operator verify the latlong error alert:
      | latlongError | Longitude must be at minimum 5 decimal places |
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | , |
    And Operator verify the latlong error alert:
      | latlongError | Please provide latitude |
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | 89.11111, |
    And Operator verify the latlong error alert:
      | latlongError | Please provide longitude |

  @DeleteAddressDatasource
  Scenario: TH Address Datasource - Edit Row - Whitelisted
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-3},{longitude-3} |
      | province    | {province-3}               |
      | district    | {district-3}               |
      | subdistrict | {subdistrict-3}            |
      | postcode    | {postcode-3}               |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-3}  |
      | longitude | {longitude-3} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province    | {KEY_CREATED_ADDRESSING.province}    |
      | district    | {KEY_CREATED_ADDRESSING.district}    |
      | subdistrict | {KEY_CREATED_ADDRESSING.subdistrict} |
      | postcode    | {KEY_CREATED_ADDRESSING.postcode}    |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | whitelisted | False |
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {postcode-3} |
    Then Operator verifies new address datasource is added:
      | province    | {province-3}    |
      | district    | {district-3}    |
      | subdistrict | {subdistrict-3} |
      | postcode    | {postcode-3}    |
      | latitude    | {latitude-3}    |
      | longitude   | {longitude-3}   |
      | whitelisted | False           |

  Scenario: TH Address Datasource - Edit Row - with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {postcode-1} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | postcode | EMPTY |
    And Operator verifies empty field error shows up in address datasource page

  @DeleteAddressDatasource
  Scenario: TH Address Datasource - Edit Row - L1/L2/L3/L4
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-3},{longitude-3} |
      | province    | {province-3}               |
      | district    | {district-3}               |
      | subdistrict | {subdistrict-3}            |
      | postcode    | {postcode-3}               |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-3}  |
      | longitude | {longitude-3} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province    | {KEY_CREATED_ADDRESSING.province}    |
      | district    | {KEY_CREATED_ADDRESSING.district}    |
      | subdistrict | {KEY_CREATED_ADDRESSING.subdistrict} |
      | postcode    | {KEY_CREATED_ADDRESSING.postcode}    |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong     | {latitude-2},{longitude-2} |
      | province    | {province-2}               |
      | district    | {district-2}               |
      | subdistrict | {subdistrict-2}            |
      | postcode    | {postcode-2}               |
      | whitelisted | False                      |
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province    | {province-2}              |
      | district    | {district-2}              |
      | subdistrict | {subdistrict-2}           |
      | zone        | {KEY_ZONE_INFO.shortName} |
      | hub         | {KEY_HUB_INFO.name}       |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {postcode-2} |
    Then Operator verifies new address datasource is added:
      | province    | {province-2}    |
      | district    | {district-2}    |
      | subdistrict | {subdistrict-2} |
      | postcode    | {postcode-2}    |
      | latitude    | {latitude-2}    |
      | longitude   | {longitude-2}   |
      | whitelisted | False           |

  @DeleteAddressDatasource
  Scenario: TH Address Datasource - Edit Row Form - Delete
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-3},{longitude-3} |
      | province    | {province-3}               |
      | district    | {district-3}               |
      | subdistrict | {subdistrict-3}            |
      | postcode    | {postcode-3}               |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | postcode | {postcode-3} |
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Delete Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {postcode-3} |
    Then Operator verifies no result found on Address Datasource page

    # Disabled for the duplicate flow, waiting confirmation from the team
#  Scenario: TH Address Datasource - Edit Row Form Duplicate Entry
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given Operator go to menu Addressing -> Address Datasource
#    When Operator clicks on Add a Row Button on Address Datasource Page
#    And Operator fills address parameters in Add a Row modal on Address Datasource page:
#      | latlong     | {latitude-1},{longitude-1} |
#      | postcode    | {datasource-postcode}      |
#      | whitelisted | True                       |
#    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
#    When API Operator get Addressing Zone:
#      | latitude  | {latitude-1}  |
#      | longitude | {longitude-1} |
#    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
#    Then Operator verifies the address datasource details in Row Details modal:
#      | postcode | {datasource-postcode}     |
#      | zone     | {KEY_ZONE_INFO.shortName} |
#      | hub      | {KEY_HUB_INFO.shortName}  |
#    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
#    And Operator verify the data source toast:
#      | top  | Datasource Updated |
#      | body | 1 match added      |
#    When Operator refresh page
#    When Operator search the existing address datasource:
#      | postcode | {datasource-postcode} |
#    When Operator clicks on Edit Button on Address Datasource Page
#    And Operator fills address parameters in Edit Address modal on Address Datasource page:
#      | postcode | {datasource-postcode-2} |
#    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
#    Then Operator verifies the address datasource details in Row Details modal:
#      | postcode | {datasource-postcode-2}   |
#      | zone     | {KEY_ZONE_INFO.shortName} |
#      | hub      | {KEY_HUB_INFO.shortName}  |
#    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
#    And Operator verify the data source toast:
#      | top  | Datasource Deleted |
#      | body | 1 match deleted    |
#    And Operator verify the data source toast disappears
#    And Operator verify the data source toast:
#      | top  | Datasource Updated |
#      | body | 1 match edited     |
#    When Operator refresh page
#    When Operator search the existing address datasource:
#      | postcode | {datasource-postcode-2} |
#    Then Operator verifies new address datasource is added:
#      | postcode  | {datasource-postcode-2} |
#      | latitude  | {latitude-1}            |
#      | longitude | {longitude-1}           |

  Scenario: TH Address Datasource - View Zone and Hub match - Existing Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator search the existing address datasource:
      | postcode | {postcode-1} |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1} |
      | zone    | {KEY_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_INFO.name}         |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op