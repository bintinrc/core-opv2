@OperatorV2 @OperatorV2Part1 @LaunchBrowser @SalesOps
Feature: All test cases related to insufficient permission for Finance related pages in OperatorV2

  Background: Login to Operator Portal V2  and go to Order Billing Page
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @KillBrowser
  Scenario: Generate Success Billing - Insufficient Permissions
    Given Operator go to menu Finance Tools -> Order Billing
    Then Operator verifies that error toast displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                                  |
      | bottom | Error Message: Access denied. Insufficient Permissions. Required any one of the scopes : SHIPPER_ADMIN,SHIPPER_GET_SHIPPER,ALL_ACCESS,INTERNAL_SERVICE |

  #not working
  @KillBrowser
  Scenario: Search by Uploading CSV file - Insufficient Permissions
    Given Operator go to menu Finance Tools -> Invoiced Orders Search
    Then Operator verifies that error toast displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                                  |
      | bottom | Error Message: Access denied. Insufficient Permissions. Required any one of the scopes : SHIPPER_ADMIN,SHIPPER_GET_SHIPPER,ALL_ACCESS,INTERNAL_SERVICE |

  @KillBrowser
  Scenario: Active Pricing Script - Insufficient Permissions
    Given Operator go to menu Shipper -> Pricing Scripts V2
    Then Operator verifies that error toast displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                              |
      | bottom | Error Message: Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ALL_ACCESS, SCRIPT_ADMIN, SCRIPT_GET |

    #todo
  Scenario: Draft Pricing Script - Insufficient Permissions
    Given Operator go to menu Shipper -> Pricing Scripts V2
    Then Operator clicks on Drafts tab
    Then Operator verifies that error toast displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                              |
      | bottom | Error Message: Access token verification failed: insufficient permissions (required scopes: INTERNAL_SERVICE, ALL_ACCESS, SCRIPT_ADMIN, SCRIPT_GET |

  #@nadeera
  @KillBrowser
  Scenario: Edit Pricing Script - Insufficient Permissions
    Given Operator go to menu Finance Tools -> Order Billing
    Then Operator verifies that error toast displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                                  |
      | bottom | Error Message: Access denied. Insufficient Permissions. Required any one of the scopes : SHIPPER_ADMIN,SHIPPER_GET_SHIPPER,ALL_ACCESS,INTERNAL_SERVICE |

  @KillBrowser
  Scenario: Edit Pricing Profile - Insufficient Permissions
    Given Operator go to menu Finance Tools -> Order Billing
    Then Operator verifies that error toast displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                                  |
      | bottom | Error Message: Access denied. Insufficient Permissions. Required any one of the scopes : SHIPPER_ADMIN,SHIPPER_GET_SHIPPER,ALL_ACCESS,INTERNAL_SERVICE |

  @KillBrowser
  Scenario: Create Pricing Profile - Insufficient Permissions
    Given Operator go to menu Finance Tools -> Order Billing
    Then Operator verifies that error toast displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                                  |
      | bottom | Error Message: Access denied. Insufficient Permissions. Required any one of the scopes : SHIPPER_ADMIN,SHIPPER_GET_SHIPPER,ALL_ACCESS,INTERNAL_SERVICE |

  @nadeera
  @KillBrowser
  Scenario: Upload Invoiced Orders - Insufficient Permissions (uid:7868e75b-9772-4b82-a046-228327a80b0a)
    Given Operator go to menu Finance Tools -> Upload Invoiced Orders
    Then Operator waits for 2 seconds
    And Operator clicks Upload Invoiced Orders with CSV button on the Upload Invoiced Orders Page
    And Operator upload a CSV file with below order ids
      | TEST |
    Then Operator verifies that error toast displayed on Order Billing page:
      | top    | Network Request Error                                                                                                                                  |
      | bottom | Error Message: Access denied. Insufficient Permissions. Required any one of the scopes : SHIPPER_ADMIN,SHIPPER_GET_SHIPPER,ALL_ACCESS,INTERNAL_SERVICE |
