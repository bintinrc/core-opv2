@selenium @shipment
Feature: shipment inbound scanning

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  Scenario: shipment inbound to van (uid:eed4a9d2-45c9-4b77-9b71-f88ff1423f0f)
###create shipment
    Given op click navigation Shipment Management in Inter-Hub
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    When filter Shipment Status is Pending
    When filter End Hub is DOJO
    When op click Load All Shipment
    Then get first shipment for shipment inbound scanning
###inbound shipment
    Given op click edit filter
    Given clear filter
    Given op click navigation Inbound Scanning in Inter-Hub
    When choose inbound hub 30JKB
    When click button Into Van on Inbound Scanning
    When click button Start Inbound on Inbound Scanning
    When scan shipment to inbound
###check status shipment
    Given op click navigation Shipment Management in Inter-Hub
    When filter Shipment Status is Transit
    When filter Last Inbound Hub is 30JKB
    When op click Load All Shipment
    Then inbounded shipment exist
    When shipment Scans action button clicked
    Then shipment scan with source VAN_INBOUND in hub 30JKB
    When shipment Delete action button clicked
    Then shipment deleted


  Scenario: shipment inbound to transit hub (uid:12758688-5e0d-4121-9b27-e11765138648)
###search shipment
    Given op click edit filter
    When clear filter
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    When filter Shipment Status is Pending
    When filter End Hub is DOJO
    When op click Load All Shipment
    Then get first shipment for shipment inbound scanning
###inbound shipment
    Given op click edit filter
    Given clear filter
    Given op click navigation Inbound Scanning in Inter-Hub
    When choose inbound hub EASTGW
    When click button Into Hub on Inbound Scanning
    When click button Start Inbound on Inbound Scanning
    When scan shipment to inbound
###check status shipment
    Given op click navigation Shipment Management in Inter-Hub
    When filter Shipment Status is Transit
    When filter Last Inbound Hub is EASTGW
    When op click Load All Shipment
    Then inbounded shipment exist
    When shipment Scans action button clicked
    Then shipment scan with source HUB_INBOUND in hub EASTGW
    When shipment Delete action button clicked
    Then shipment deleted

  Scenario: shipment inbound to destination hub (uid:595ea161-b4a0-4490-b4c2-e439f2bd6293)
###search shipment
    Given op click edit filter
    When clear filter
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    When filter Shipment Status is Pending
    When filter End Hub is DOJO
    When op click Load All Shipment
    Then get first shipment for shipment inbound scanning
###inbound shipment
    Given op click edit filter
    Given clear filter
    Given op click navigation Inbound Scanning in Inter-Hub
    When choose inbound hub DOJO
    When click button Into Hub on Inbound Scanning
    When click button Start Inbound on Inbound Scanning
    When scan shipment to inbound
###check status shipment
    Given op click navigation Shipment Management in Inter-Hub
    When filter Shipment Status is Completed
    When filter Last Inbound Hub is DOJO
    When op click Load All Shipment
    Then inbounded shipment exist
    When shipment Scans action button clicked
    Then shipment scan with source HUB_INBOUND in hub DOJO
    When shipment Delete action button clicked
    Then shipment deleted

  @closeBrowser
  Scenario: close browser