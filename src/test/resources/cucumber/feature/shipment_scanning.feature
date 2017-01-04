@selenium @shipment
Feature: shipment scanning

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  Scenario: scan order to shipment (uid:b776b582-a395-4a02-962a-9785f6945750)
#    create order for scan
    Given Create an V3 order with the following attributes:
  | Note                 | hiptest-uid                              | type   | pickup_date | pickup_timewindow_id | delivery_date | delivery_timewindow_id | max_delivery_days | parcel_size | parcel_volume | parcel_weight | from_name        | from_contact  | from_email         | from_address1         | from_address2 | from_city | from_country | from_postcode | to_name      | to_contact    | to_email           | to_address1           | to_address2  | to_city | to_country | to_postcode |
  | C2C Nextday          | uid:f2ed4f50-c6f8-4736-902a-c6033dd53063 | C2C    | TODAY       | 1                    | TOMORROW      | 2                      | 1                 | 2           | 9000          | 3000          | Han Solo Exports | 91234567      | jane.doe@gmail.com | 30 Jalan Kilang Barat | Ninja Van HQ  | SG        | SG           | 159363        | James T Kirk | 98765432      | john.doe@gmail.com | 998 Toa Payoh North   | #01-10       | SG      | SG         | 318993      |
#    create shipment
    Given op click navigation Shipment Management in Inter-Hub
    When create shipment button is clicked
    When create Shipment with Start Hub 30JKB, End hub DOJO and comment Auto Comment
    Then shipment created
    When filter Last Inbound Hub is 30JKB
    When op click Load All Selection
    Then get first shipment for shipment scanning
    Then op click edit filter
    Then clear filter
#    scan order to shipment
    Given op click navigation Shipment Scanning in Inter-Hub
    When choose hub 30JKB
    When choose above shipment
    When scan order to shipment
    Then order in shipment

  @closeBrowser
  Scenario: close browser