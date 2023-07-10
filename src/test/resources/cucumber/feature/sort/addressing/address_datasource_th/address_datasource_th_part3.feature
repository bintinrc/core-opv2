@Sort @AddressDataSourceThPart3
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun @BeforeDeleteAddressCommonV2
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

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


  Scenario: TH Address Datasource - Edit Row - Whitelisted
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-3},{longitude-3} |
      | province    | {auto-province-th-3}       |
      | district    | {auto-district-th-3}       |
      | subdistrict | {auto-subdistrict-th-3}    |
      | postcode    | {postcode-3}               |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-3}, "longitude":{longitude-3}}|
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province    | {KEY_SORT_CREATED_ADDRESS.province}    |
      | district    | {KEY_SORT_CREATED_ADDRESS.district}    |
      | subdistrict | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
      | postcode    | {KEY_SORT_CREATED_ADDRESS.postcode}    |
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
      | province    | {auto-province-th-3}    |
      | district    | {auto-district-th-3}    |
      | subdistrict | {auto-subdistrict-th-3} |
      | postcode    | {postcode-3}            |
      | latitude    | {latitude-3}            |
      | longitude   | {longitude-3}           |
      | whitelisted | False                   |

  Scenario: TH Address Datasource - Edit Row - with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | postcode | {postcode-1} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | postcode | EMPTY |
    And Operator verifies empty field error shows up in address datasource page


  Scenario: TH Address Datasource - Edit Row - L1/L2/L3/L4
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-3},{longitude-3} |
      | province    | {auto-province-th-4}       |
      | district    | {auto-district-th-4}       |
      | subdistrict | {auto-subdistrict-th-4}    |
      | postcode    | {postcode-3}               |
      | whitelisted | True                       |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-3}, "longitude":{longitude-3}}|
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province    | {KEY_SORT_CREATED_ADDRESS.province}    |
      | district    | {KEY_SORT_CREATED_ADDRESS.district}    |
      | subdistrict | {KEY_SORT_CREATED_ADDRESS.subdistrict} |
      | postcode    | {KEY_SORT_CREATED_ADDRESS.postcode}    |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong     | {latitude-4},{longitude-4} |
      | province    | {auto-province-th-5}       |
      | district    | {auto-district-th-5}       |
      | subdistrict | {auto-subdistrict-th-5}    |
      | postcode    | {postcode-4}               |
      | whitelisted | False                      |
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-4}, "longitude":{longitude-4}}|
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasource details in Row Details modal:
      | province    | {auto-province-th-5}           |
      | district    | {auto-district-th-5}           |
      | subdistrict | {auto-subdistrict-th-5}        |
      | zone        | {KEY_SORT_ZONE_INFO.shortName} |
      | hub         | {KEY_HUB_DETAILS.name}         |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | postcode | {postcode-4} |
    Then Operator verifies new address datasource is added:
      | province    | {auto-province-th-5}    |
      | district    | {auto-district-th-5}    |
      | subdistrict | {auto-subdistrict-th-5} |
      | postcode    | {postcode-4}            |
      | latitude    | {latitude-4}            |
      | longitude   | {longitude-4}           |
      | whitelisted | False                   |

  Scenario: TH Address Datasource - Edit Row Form - Delete
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong     | {latitude-3},{longitude-3} |
      | province    | {auto-province-th-6}       |
      | district    | {auto-district-th-6}       |
      | subdistrict | {auto-subdistrict-th-6}    |
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
#    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
#    Then Operator verifies the address datasource details in Row Details modal:
#      | postcode | {datasource-postcode}     |
#      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
#      | hub      | {KEY_HUB_DETAILS.shortName}  |
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
#      | zone     | {KEY_SORT_ZONE_INFO.shortName} |
#      | hub      | {KEY_HUB_DETAILS.shortName}  |
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
    When API Sort - Operator get Addressing Zone with details:
      | request | {"type": "STANDARD", "latitude": {latitude-1}, "longitude":{longitude-1}} |
    And API Sort - Operator get hub details of hub id "{KEY_SORT_ZONE_INFO.hubId}"
    When Operator search the existing address datasource:
      | province    | {province-1}    |
      | district    | {district-1}    |
      | subdistrict | {subdistrict-1} |
      | postcode | {postcode-1} |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1} |
      | zone    | {KEY_SORT_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_DETAILS.name}         |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op