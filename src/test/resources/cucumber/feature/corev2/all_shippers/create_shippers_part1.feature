@OperatorV2 @CoreV2 @Shippers @CreateShipper
Feature: Create shipper part1

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create shipper - invalid prefix - fixed invalid character length
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    When Operator select tracking type = "Fixed" in shipper settings page
    When Operator fill shipper prefix with = "1234" in shipper settings page
    Then Operator check error message in shipper prefix input is "Must enter exactly 5 characters for Prefix"
    When Operator fill shipper prefix with = "123456" in shipper settings page
    Then Operator check error message in shipper prefix input is "Must enter exactly 5 characters for Prefix"


  Scenario: Create shipper - invalid prefix - multi fixed invalid character length
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    When Operator select tracking type = "MultiFixed" in shipper settings page
    When Operator fill multi shipper prefix "0" with = "1234" in shipper settings page
    Then Operator check error message in multi shipper prefix "0" input is "Must enter exactly 5 characters for Prefix"
    When Operator fill multi shipper prefix "0" with = "123456s" in shipper settings page
    Then Operator check error message in multi shipper prefix "0" input is "Must enter exactly 5 characters for Prefix"


  Scenario: Create shipper - invalid prefix - dynamic invalid character length
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    When Operator select tracking type = "Dynamic" in shipper settings page
    When Operator fill shipper prefix with = "1" in shipper settings page
    Then Operator check error message in shipper prefix input is "Must enter 2-5 characters for Prefix"
    When Operator fill shipper prefix with = "12525245354648738735435" in shipper settings page
    Then Operator check error message in shipper prefix input is "Must enter 2-5 characters for Prefix"


  Scenario: Create shipper - invalid prefix - multi fixed invalid character length
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    When Operator select tracking type = "MultiDynamic" in shipper settings page
    When Operator fill multi shipper prefix "0" with = "1" in shipper settings page
    Then Operator check error message in multi shipper prefix "0" input is "Must enter 2-5 characters for Prefix"
    When Operator fill multi shipper prefix "0" with = "12525245354648738735435" in shipper settings page
    Then Operator check error message in multi shipper prefix "0" input is "Must enter 2-5 characters for Prefix"


  Scenario: Create shipper - invalid prefix - existing fixed prefix in same system id
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    When Operator select tracking type = "Fixed" in shipper settings page
    When Operator fill shipper prefix with = "ABCDE" in shipper settings page
    Then Operator check error message in shipper prefix input is "Prefix already used"


  Scenario: Create shipper - invalid prefix - existing multi fixed prefix in same system id
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    When Operator select tracking type = "MultiFixed" in shipper settings page
    When Operator fill multi shipper prefix "0" with = "ABCDE" in shipper settings page
    Then Operator check error message in multi shipper prefix "0" input is "Prefix already used"


  Scenario: Create shipper - invalid prefix - existing dynamic prefix in same system id
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    When Operator select tracking type = "Dynamic" in shipper settings page
    When Operator fill shipper prefix with = "ABC" in shipper settings page
    Then Operator check error message in shipper prefix input is "Prefix already used"


  Scenario: Create shipper - invalid prefix - existing multi dynamic prefix in same system id
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    When Operator select tracking type = "MultiDynamic" in shipper settings page
    When Operator fill multi shipper prefix "0" with = "ABC" in shipper settings page
    Then Operator check error message in multi shipper prefix "0" input is "Prefix already used"


  Scenario: Create shipper - XB multidynamic disabled
    Given Operator go to menu Shipper -> All Shippers
    When Operator click create new shipper button
    When Operator switch to create new shipper tab
    Then Operator check prefix type "XBMultiDynamic" is disabled