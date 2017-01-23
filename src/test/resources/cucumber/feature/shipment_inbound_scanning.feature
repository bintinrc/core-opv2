@selenium @shipment
Feature: shipment inbound scanning

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page
    Then op click navigation Shipment Management in Inter-Hub

  Scenario: shipment inbound to van (uid:eed4a9d2-45c9-4b77-9b71-f88ff1423f0f)
###create shipment
    Given create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    When filter Shipment Status is Pending
    When filter End Hub is DOJO
    When op click Load All Selection
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
    When op click Load All Selection
    Then inbounded shipment exist
    When shipment Scans action button clicked
    Then shipment scan with source VAN_INBOUND in hub 30JKB
    When shipment Delete action button clicked
    Then shipment deleted
    Then op click edit filter
    Then clear filter


  Scenario: shipment inbound to transit hub (uid:12758688-5e0d-4121-9b27-e11765138648)
###search shipment
    Given create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    When filter Shipment Status is Pending
    When filter End Hub is DOJO
    When op click Load All Selection
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
    When op click Load All Selection
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
    When op click Load All Selection
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
    When op click Load All Selection
    Then inbounded shipment exist
    When shipment Scans action button clicked
    Then shipment scan with source HUB_INBOUND in hub DOJO
    When shipment Delete action button clicked
    Then shipment deleted

  Scenario: change end date when inbound scanning (uid:6efa9d01-49d8-4515-b924-5805d34d587a)
###create order for scan
    Given Create an V3 order with the following attributes:
      | Note                 | hiptest-uid                              | type   | pickup_date | pickup_timewindow_id | delivery_date | delivery_timewindow_id | max_delivery_days | parcel_size | parcel_volume | parcel_weight | from_name        | from_contact  | from_email         | from_address1         | from_address2 | from_city | from_country | from_postcode | to_name      | to_contact    | to_email           | to_address1           | to_address2  | to_city | to_country | to_postcode |
      | C2C Nextday          | uid:f2ed4f50-c6f8-4736-902a-c6033dd53063 | C2C    | TODAY       | 1                    | TOMORROW      | 2                      | 1                 | 2           | 9000          | 3000          | Han Solo Exports | 91234567      | jane.doe@gmail.com | 30 Jalan Kilang Barat | Ninja Van HQ  | SG        | SG           | 159363        | James T Kirk | 98765432      | john.doe@gmail.com | 998 Toa Payoh North   | #01-10       | SG      | SG         | 318993      |
###create shipment
    Given create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    When filter Shipment Status is Pending
    When filter End Hub is DOJO
    When op click Load All Selection
    Then get first shipment for shipment inbound scanning
    Then get first shipment for shipment scanning
###inbound shipment
    Given op click edit filter
    Given clear filter
###scan order to shipment
    Given op click navigation Shipment Scanning in Inter-Hub
    When choose hub 30JKB
    When choose above shipment
    When scan order to shipment
    Then order in shipment
###inbound shipment
    Given op click navigation Inbound Scanning in Inter-Hub
    When choose inbound hub 30JKB
    When click button Into Van on Inbound Scanning
    When click button Start Inbound on Inbound Scanning
    When scan shipment to inbound
    When change end date
###check status shipment
    Given op click navigation Shipment Management in Inter-Hub
    When filter Shipment Status is Transit
    When filter Last Inbound Hub is 30JKB
    When op click Load All Selection
    Then inbounded shipment exist
    When shipment Scans action button clicked
    Then shipment scan with source VAN_INBOUND in hub 30JKB
    When shipment Delete action button clicked
    Then shipment deleted
    Then op click edit filter
    Then clear filter

  @closeBrowser
  Scenario: close browser