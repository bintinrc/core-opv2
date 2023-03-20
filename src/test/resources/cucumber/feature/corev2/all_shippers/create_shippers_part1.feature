@OperatorV2 @CoreV2 @Shippers @CreateShipperPart1 @CWF
Feature: Create shipper part1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


  @RT
  Scenario: Create shipper - invalid prefix - multi dynamic invalid character length
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab

