@DpAdministration @selenium
Feature: dp administration

  @LaunchBrowser @DpAdministration#01
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  # download dp partner
  @DpAdministration#01
  Scenario: op download dp partner csv list (uid:7554e32c-4b13-4693-8f0f-51faf3cc940b)
    Given op click navigation DP Administration in Distribution Points
    When download button in dp-partners is clicked
    Then file dp-partners should exist

  # add dp partner
  @DpAdministration#01
  Scenario: op add dp partner (uid:023ea7fd-d333-4736-b643-3d84fe0fbca5)
    Given op click navigation DP Administration in Distribution Points
    When add dp-partners button is clicked
    When enter default value of dp-partners
    Then verify result add dp-partners

  # search dp partner
  @DpAdministration#01
  Scenario: op searching for dp partner (uid:f1d47bea-17b7-4acf-8240-ac62acd5dd16)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners

  # edit dp partner
  @DpAdministration#01
  Scenario: op edit existing dp partner (uid:31794b7f-b82a-491e-a482-60a6fc04e409)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When edit dp-partners button is clicked
    Then verify result edit dp-partners

  # go to dps
  @DpAdministration#01
  Scenario: op click view dp (uid:96a2d074-06f6-4ab5-b344-1e8f81678411)
    Given op click navigation DP Administration in Distribution Points
    When view dps button is clicked
    Then verify page dps

  # add dps
  @DpAdministration#01
  Scenario: op add new dps (uid:666d5f35-fb35-4f6e-8431-00287b9c1821)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When add dps button is clicked
    When enter default value of dps
    Then verify result add dps

  # search dps
  @DpAdministration#01
  Scenario: op searching for dps (uid:98bbf1a1-24d3-4b92-af78-bde512a54d64)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When searching for dps

  # edit dps
  @DpAdministration#01
  Scenario: op edit dps (uid:c63b8e62-1817-48b9-adf0-598fdc3043d1)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When searching for dps
    When edit dps button is clicked
    Then verify result edit dps

  # download dps
  @DpAdministration#01
  Scenario: op download dps csv list (uid:bc5112eb-4ecd-4980-a7e8-1622cae68de1)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When download button in dps is clicked
    Then file dps should exist

  # go to dp user
  @DpAdministration#01
  Scenario: op view dp-users (uid:2178f934-0c0c-4958-95a3-12a645deeb97)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When searching for dps
    When view dp-users button is clicked
    Then verify page dp-users

  # add dp user
  @DpAdministration#01
  Scenario: op add dp-users (uid:156ad3be-3b8a-493c-b8e0-b38a422f11cc)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When searching for dps
    When view dp-users button is clicked
    When add dp-users button is clicked
    When enter default value of dp-users
    Then verify result add dp-users

  # search dp user
  @DpAdministration#01
  Scenario: op searching for dp-users (uid:7af2be79-e9db-4738-887f-f50241836a19)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When searching for dps
    When view dp-users button is clicked
    When searching for dp-users

  # edit dp user
  @DpAdministration#01
  Scenario: op edit dp-users (uid:bd4ee7dd-cf77-4b78-a724-5771a2f50e9a)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When searching for dps
    When view dp-users button is clicked
    When searching for dp-users
    When edit dp-users button is clicked
    Then verify result edit dp-users

  # download dp user
  @DpAdministration#01
  Scenario: op download dp users csv list (uid:7d5dd96f-0960-40f3-a89b-c691570ac101)
    Given op click navigation DP Administration in Distribution Points
    When searching for dp-partners
    When view dps button is clicked
    When searching for dps
    When view dp-users button is clicked
    When download button in dp-users is clicked
    Then file dp-users should exist

  @KillBrowser @DpAdministration#01
  Scenario: Kill Browser
