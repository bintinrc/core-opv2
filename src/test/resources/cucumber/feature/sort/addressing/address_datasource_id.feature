@Sort @AddressDataSourceId
Feature: Address Datasource

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  Scenario: ID Address Datasource - Add a Row with No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    Then Operator verifies Add Button is Disabled

  Scenario: ID Address Datasource - Add a Row with Empty Field
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong  | GENERATED  |
      | province | {province} |
      | kota     | {kota}     |
    Then Operator verifies Add Button is Disabled

  Scenario: ID Address Datasource - Add a Row with Invalid Latlong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | 1.1,1.11    |
      | province  | {province}  |
      | kota      | {kota}      |
      | kecamatan | {kecamatan} |
    Then Operator verifies Add Button is Disabled
    And Operator verifies invalid latlong message

  @DeleteAddressDatasource
  Scenario: ID Address Datasource - Add a Row with Valid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | {latitude-1},{longitude-1} |
      | province  | {province}                 |
      | kota      | {kota}                     |
      | kecamatan | {kecamatan}                |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
    Then Operator verifies new address datasource is added:
      | province  | {KEY_CREATED_ADDRESSING.province}  |
      | kota      | {KEY_CREATED_ADDRESSING.city}      |
      | kecamatan | {KEY_CREATED_ADDRESSING.district}  |
      | latitude  | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude | {KEY_CREATED_ADDRESSING.longitude} |

  @DeleteAddressDatasource
  Scenario: ID Address Datasource - Add a Row with Valid Input Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | {latitude-1},{longitude-1} |
      | province  | {province}                 |
      | kota      | {kota}                     |
      | kecamatan | {kecamatan}                |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | {latitude-2},{longitude-2} |
      | province  | {province}                 |
      | kota      | {kota}                     |
      | kecamatan | {kecamatan}                |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator search the created address datasource:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
    Then Operator verifies new address datasource is added:
      | province  | {KEY_CREATED_ADDRESSING.province}  |
      | kota      | {KEY_CREATED_ADDRESSING.city}      |
      | kecamatan | {KEY_CREATED_ADDRESSING.district}  |
      | latitude  | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude | {KEY_CREATED_ADDRESSING.longitude} |

  Scenario: ID Address Datasource Landing Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verify search field lable:
      | l1 | province         |
      | l2 | Kota / Kabupaten |
      | l3 | Kecamatan        |

  Scenario: ID Address Datasource  Landing Page - Search Box No Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator verifies search button is disabled

  Scenario: ID Address Datasource  Landing Page - Search Box 1 of 3 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {created-province} |
    Then Operator verifies new address datasource is added:
      | province  | {created-province}  |
      | kota      | {created-kota}      |
      | kecamatan | {created-kecamatan} |
      | latitude  | {latitude-1}        |
      | longitude | {longitude-1}       |

  Scenario: ID Address Datasource  Landing Page - Search Box 2 of 3 Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {created-province} |
      | kota     | {created-kota}     |
    Then Operator verifies new address datasource is added:
      | province  | {created-province}  |
      | kota      | {created-kota}      |
      | kecamatan | {created-kecamatan} |
      | latitude  | {latitude-1}        |
      | longitude | {longitude-1}       |

  Scenario: ID Address Datasource  Landing Page - Search Box 3 of 3  Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {created-province}  |
      | kota      | {created-kota}      |
      | kecamatan | {created-kecamatan} |
    Then Operator verifies new address datasource is added:
      | province  | {created-province}  |
      | kota      | {created-kota}      |
      | kecamatan | {created-kecamatan} |
      | latitude  | {latitude-1}        |
      | longitude | {longitude-1}       |

  Scenario: ID Address Datasource Landing Page - Search Box Invalid Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | INVALID |
      | kota      | INVALID |
      | kecamatan | INVALID |
    Then Operator verifies no result found on Address Datasource page

  Scenario: ID Address Datasource  Landing Page - Scrolling
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province | {province} |
    Then Operator verifies search box not affected by the scroll

  Scenario: ID Address Datasource - Edit Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {province-2}  |
      | kota      | {kota-2}      |
      | kecamatan | {kecamatan-2} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {province-2}              |
      | kota      | {kota-2}                  |
      | kecamatan | {kecamatan-2}             |
      | zone      | {KEY_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_INFO.shortName}  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |

  Scenario: ID Address Datasource  - View Zone and Hub match - Existing Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator search the existing address datasource:
      | province  | {created-province}  |
      | kota      | {created-kota}      |
      | kecamatan | {created-kecamatan} |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1} |
      | zone    | {KEY_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_INFO.shortName}    |

  @DeleteAddressDatasource
  Scenario: ID Address Datasource - View Zone and Hub Match - New Added Row
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | {latitude-1},{longitude-1} |
      | province  | {province}                 |
      | kota      | {kota}                     |
      | kecamatan | {kecamatan}                |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
    Then Operator verifies new address datasource is added:
      | province  | {KEY_CREATED_ADDRESSING.province}  |
      | kota      | {KEY_CREATED_ADDRESSING.city}      |
      | kecamatan | {KEY_CREATED_ADDRESSING.district}  |
      | latitude  | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude | {KEY_CREATED_ADDRESSING.longitude} |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-1}, {longitude-1} |
      | zone    | {KEY_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_INFO.shortName}    |

  @DeleteAddressDatasource
  Scenario: ID Address Datasource - View Zone and Hub Match - Edited Row - LatLong
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | {latitude-1},{longitude-1} |
      | province  | {province}                 |
      | kota      | {kota}                     |
      | kecamatan | {kecamatan}                |
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-1}  |
      | longitude | {longitude-1} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {KEY_CREATED_ADDRESSING.province} |
      | kota      | {KEY_CREATED_ADDRESSING.city}     |
      | kecamatan | {KEY_CREATED_ADDRESSING.district} |
    Then Operator verifies new address datasource is added:
      | province  | {KEY_CREATED_ADDRESSING.province}  |
      | kota      | {KEY_CREATED_ADDRESSING.city}      |
      | kecamatan | {KEY_CREATED_ADDRESSING.district}  |
      | latitude  | {KEY_CREATED_ADDRESSING.latitude}  |
      | longitude | {KEY_CREATED_ADDRESSING.longitude} |
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong | {latitude-2},{longitude-2} |
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {province}                |
      | kota      | {kota}                    |
      | kecamatan | {kecamatan}               |
      | zone      | {KEY_ZONE_INFO.shortName} |
      | hub       | {KEY_HUB_INFO.shortName}  |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator clicks on View Zone and Hub Match Button on Address Datasource Page
    Then Operator verifies the zone and hub details in View Zone and Hub Match modal:
      | latlong | {latitude-2}, {longitude-2} |
      | zone    | {KEY_ZONE_INFO.shortName}   |
      | hub     | {KEY_HUB_INFO.shortName}    |

  Scenario: ID Address Datasource - Edit Row Form
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {province-2} |
      | kota      | {kota-2}     |
      | kecamatan | {kecamatan-2}|
    When Operator clicks on Edit Button on Address Datasource Page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2} |
      | longitude | {longitude-2}|
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {province-2}             |
      | kota      | {kota-2}                 |
      | kecamatan | {kecamatan-2}            |
      | zone      | {KEY_ZONE_INFO.shortName}|
      | hub       | {KEY_HUB_INFO.shortName} |


  @DeleteAddressDatasource
  Scenario: ID Address Datasource - Edit Row - L1/L2/L3
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | {latitude-2},{longitude-2}|
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province  | {province-4} |
      | kota      | {kota-4}     |
      | kecamatan | {kecamatan-4}|
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {province-4} |
      | kota      | {kota-4}     |
      | kecamatan | {kecamatan-4}|
      | zone      | {KEY_ZONE_INFO.shortName}|
      | hub       | {KEY_HUB_INFO.shortName} |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match edited     |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {province-4} |
      | kota      | {kota-4}     |
      | kecamatan | {kecamatan-4}|
    Then Operator verifies new address datasource is added:
      | province  | {province-4} |
      | kota      | {kota-4}     |
      | kecamatan | {kecamatan-4}|
      | latitude  | {latitude-2}   |
      | longitude | {longitude-2}    |


  Scenario: ID Address Datasource - Edit Row - Invalid LatLong Input
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator search the existing address datasource:
      | province  | {province-2} |
      | kota      | {kota-2}     |
      | kecamatan | {kecamatan-2}|
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong   |91,90|
    And Operator verify the latlong error alert:
      | latlongError   |Latitude must between -90 to 90 degrees|
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong   |89.11111,181|
    And Operator verify the latlong error alert:
      | latlongError   |Longitude must between -180 to 180 degrees|
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong   |89.11111,180|
    And Operator verify the latlong error alert:
      | latlongError   |Longitude must be at minimum 5 decimal places|
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong   |,|
    And Operator verify the latlong error alert:
      | latlongError   |Please provide latitude|
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | latlong   |89.11111,|
    And Operator verify the latlong error alert:
      | latlongError   |Please provide longitude|


  Scenario: ID Address Datasource - Edit Row - Delete
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | {latitude-2},{longitude-2}|
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator search the created address datasource:
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
    When Operator clicks on Edit Button on Address Datasource Page
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |

  @MyTag2
  Scenario: ID Address Datasource - Edit Row - Duplicate Entry
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Address Datasource
    When Operator clicks on Add a Row Button on Address Datasource Page
    And Operator fills address parameters in Add a Row modal on Address Datasource page:
      | latlong   | {latitude-2},{longitude-2}|
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
    When Operator clicks on Add Button in Add a Row modal on Address Datasource page
    When API Operator get Addressing Zone:
      | latitude  | {latitude-2}  |
      | longitude | {longitude-2} |
    And Operator get info of hub details string id "{KEY_ZONE_INFO.hubId}"
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
      | zone      | {KEY_ZONE_INFO.shortName}         |
      | hub       | {KEY_HUB_INFO.shortName}          |
    When Operator clicks on Proceed Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Updated |
      | body | 1 match added      |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {province-3} |
      | kota      | {kota-3}     |
      | kecamatan | {kecamatan-3}|
    When Operator clicks on Edit Button on Address Datasource Page
    And Operator fills address parameters in Edit Address modal on Address Datasource page:
      | province  | {province-5} |
      | kota      | {kota-5}     |
      | kecamatan | {kecamatan-5}|
    When Operator clicks on Save Button in Edit a Row modal on Address Datasource page
    Then Operator verifies the address datasorce details in Row Details modal:
      | province  | {province-5} |
      | kota      | {kota-5}     |
      | kecamatan | {kecamatan-5}|
      | zone      | {KEY_ZONE_INFO.shortName}|
      | hub       | {KEY_HUB_INFO.shortName} |
    When Operator clicks on Replace Button in Row Details modal on Address Datasource page
    And Operator verify the data source toast:
      | top  | Datasource Deleted |
      | body | 1 match deleted    |
    When Operator refresh page
    When Operator search the existing address datasource:
      | province  | {province-5} |
      | kota      | {kota-5}     |
      | kecamatan | {kecamatan-5}|
    Then Operator verifies new address datasource is added:
      | province  | {province-5} |
      | kota      | {kota-5}     |
      | kecamatan | {kecamatan-5}|
      | latitude  | {latitude-2}   |
      | longitude | {longitude-2}    |

  @KillBrowser @ShouldAlwaysRun @MyTag2
  Scenario: Kill Browser
    Given no-op