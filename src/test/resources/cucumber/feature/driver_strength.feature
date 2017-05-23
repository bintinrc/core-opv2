@DriverStrength @selenium @saas
Feature: driver strength

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  # add new
  Scenario: op add new driver (uid:b7a6c2b2-66c0-4e7d-890c-b0099cef4b5a)
    Given op click navigation Driver Strength in Fleet
    When in driver strength add new driver button is clicked
    When in driver strength enter default value of new driver
    Then in driver strength new driver should get created

  Scenario: op filter driver strength by zones (uid:70921910-cb0a-4283-93ad-34431fd86b98)
    Given op click navigation Driver Strength in Fleet
    When in driver strength searching driver
    When in driver find zone and type of the driver
    When in driver strength driver strength is filtered by zone

  Scenario: op filter driver strength by driver-type (uid:3f54984e-aaa1-494c-a27b-68af2d809071)
    Given op click navigation Driver Strength in Fleet
    When in driver strength searching driver
    When in driver find zone and type of the driver
    When in driver strength driver strength is filtered by driver-type

  Scenario: op search driver using searching box (uid:9e1d4874-d927-438a-abdf-8cde0308f35b)
    Given op click navigation Driver Strength in Fleet
    When in driver strength searching driver
    Then in driver strength verifying driver

  Scenario: op change driver coming status (uid:bd210076-fd96-4d1a-8277-ec119286680c)
    Given op click navigation Driver Strength in Fleet
    When in driver strength searching driver
    When in driver strength driver coming status is changed

  Scenario: op view contact (uid:830216ec-bc25-4921-8950-40e6bd8818af)
    Given op click navigation Driver Strength in Fleet
    When in driver strength searching driver
    When in driver strength clicking on view contact button

  # edit existing
  Scenario: op edit new driver (uid:204f21ef-8b0c-4b74-a6e0-c191199d3f5a)
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Driver Strength in Fleet
    When in driver strength searching new created driver
    When in driver strength edit new driver button is clicked

  # delete existing
  Scenario: op delete new driver (uid:419e1f4d-a226-492f-a655-eb92d48be704)
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Driver Strength in Fleet
    When in driver strength searching new created driver
    When in driver strength delete new driver button is clicked
    Then in driver strength the created driver should not exist

  @KillBrowser
  Scenario: Kill Browser
