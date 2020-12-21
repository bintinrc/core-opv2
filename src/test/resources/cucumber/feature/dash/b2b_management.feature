@MileZero @B2B
Feature: B2B Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: View list of master shipper (uid:921e8a50-6f50-4f25-a4fe-544f0b38661e)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    When Operator go to menu Shipper -> B2B Management
    And API Operator get b2b master shippers
    Then QA verify b2b management page is displayed
    And QA verify correct master shippers are displayed on b2b management page

  Scenario Outline: Search master shipper by name (uid:45f8d624-d652-4c1d-ad54-70e849f6ec08)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<searchValue>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<searchValue>" is displayed on b2b management page

    Examples:
      | searchValue                        | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | uid:d32e9751-c5ed-41c6-a2c0-d8f3ad74bf85 |

  Scenario Outline: Search master shipper by email (uid:58a96bac-9a11-4a9a-a473-9d40f82958b2)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill email search field with "<searchValue>" on master shipper table on b2b management page
    Then QA verify master shippers with email contains "<searchValue>" is displayed on b2b management page

    Examples:
      | searchValue                         | hiptest-uid                              |
      | {operator-b2b-master-shipper-email} | uid:9b7f113a-6f3a-473e-9e28-00c1046ec60a |

  Scenario Outline: View list of sub shippers (uid:89214868-e3b8-4d44-a607-4dcc20632033)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When API Operator get b2b sub shippers for master shipper id "<masterShipperId>"
    And Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    Then QA verify correct sub shippers is displayed on b2b management page

    Examples:
      | masterShipperName                  | masterShipperId                  | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | {operator-b2b-master-shipper-id} | uid:0ba4ae4d-74ee-437e-95cc-17a71308ea8a |

  Scenario Outline: Search sub shippers by name (uid:ff881b4b-e552-4bbb-af24-0eb66f34677e)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When API Operator get b2b sub shippers for master shipper id "<masterShipperId>"
    And Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    And Operator fill name search field with "<searchValue>" on sub shipper table on b2b management page
    Then QA verify sub shippers with name contains "<searchValue>" is displayed on b2b management page

    Examples:
      | masterShipperName                  | masterShipperId                  | searchValue                     | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | {operator-b2b-master-shipper-id} | {operator-b2b-sub-shipper-name} | uid:0de07764-d4bc-4298-9705-326595bd0119 |

  Scenario Outline: Search sub shippers by email (uid:f1933bd2-20e7-43de-8177-19fb043d2951)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When API Operator get b2b sub shippers for master shipper id "<masterShipperId>"
    And Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    And Operator fill email search field with "<searchValue>" on sub shipper table on b2b management page
    Then QA verify sub shippers with email contains "<searchValue>" is displayed on b2b management page

    Examples:
      | masterShipperName                  | masterShipperId                  | searchValue                      | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | {operator-b2b-master-shipper-id} | {operator-b2b-sub-shipper-email} | uid:2cc0b647-a92a-4135-bdfb-c6d16625b97f |

  Scenario Outline: Create sub shipper on b2b management page (uid:136facd1-b3eb-44b3-aa3e-1d17361d35e2)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    And Operator click add sub-shipper button on b2b management page
    And Operator fill seller id field with "random" on b2b management page
    And Operator fill name field with "random" on b2b management page
    And Operator fill email field with "random" on b2b management page
    And Operator click create sub-shipper account button on b2b management page
    Then QA verify sub shipper is created on b2b management page

    Examples:
      | masterShipperName                  | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | uid:b610d8ad-58f5-430a-ae8b-564e5958ee90 |

  @CloseNewWindows
  Scenario Outline: Edit sub shippers on b2b management (uid:194b7d19-189f-419a-abcc-eefc58d77aac)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    And Operator fill name search field with "<searchValue>" on sub shipper table on b2b management page
    Then QA verify sub shippers with name contains "<searchValue>" is displayed on b2b management page

    When Operator click edit action button for sub shipper with seller id contains "<searchValue>" on b2b management page
    Then QA verify shipper details page with id "{operator-b2b-sub-shipper-id}" is displayed

    Examples:
      | masterShipperName                  | searchValue                          | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | {operator-b2b-sub-shipper-seller-id} | uid:2300d1be-3d97-49ad-afb1-ca8adf4a15ba |

  Scenario Outline: Create sub shipper with empty seller id field on b2b management page (uid:efc01b1f-7ad8-4059-a650-b60f94b5065d)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    And Operator click add sub-shipper button on b2b management page
    And Operator fill name field with "random" on b2b management page
    And Operator fill email field with "random" on b2b management page
    And Operator click create sub-shipper account button on b2b management page
    Then QA verify error message "Seller ID must be filled." is displayed on b2b management page

    Examples:
      | masterShipperName                  | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | uid:f59905a3-f150-431d-aece-e7faa49aae16 |

  Scenario Outline: Create sub shipper with empty name field on b2b management page (uid:b19876f6-38e8-4c78-86b8-9033f17706ec)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    And Operator click add sub-shipper button on b2b management page
    And Operator fill seller id field with "random" on b2b management page
    And Operator fill email field with "random" on b2b management page
    And Operator click create sub-shipper account button on b2b management page
    Then QA verify error message "Name must be filled." is displayed on b2b management page

    Examples:
      | masterShipperName                  | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | uid:41016957-fdb7-453c-b868-2eb8523c04a5 |

  Scenario Outline: Create sub shipper with empty email field on b2b management page (uid:4be10e78-3f50-4077-b8b5-718a8cab0c5d)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    And Operator click add sub-shipper button on b2b management page
    And Operator fill seller id field with "random" on b2b management page
    And Operator fill name field with "random" on b2b management page
    And Operator click create sub-shipper account button on b2b management page
    Then QA verify error message "Email must be filled." is displayed on b2b management page

    Examples:
      | masterShipperName                  | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | uid:b5703a3d-5d57-486f-8663-dbb0b5ef0640 |

  Scenario Outline: Create sub shipper with invalid email format on b2b management page (uid:e4076be6-1fdc-4a68-80dc-27d33956f595)
    Given Operator refresh page
    Given QA verify b2b management page is displayed
    When Operator fill name search field with "<masterShipperName>" on master shipper table on b2b management page
    Then QA verify master shippers with name contains "<masterShipperName>" is displayed on b2b management page
    When Operator click view sub-shippers button for shipper "<masterShipperName>" on b2b management page
    And Operator click add sub-shipper button on b2b management page
    And Operator fill seller id field with "random" on b2b management page
    And Operator fill name field with "random" on b2b management page
    And Operator fill email field with "wrong.format" on b2b management page
    And Operator click create sub-shipper account button on b2b management page
    Then QA verify error message "Email not formatted as _@_._" is displayed on b2b management page

    Examples:
      | masterShipperName                  | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | uid:c344e290-7672-47d6-917a-de46b70aa7e2 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op