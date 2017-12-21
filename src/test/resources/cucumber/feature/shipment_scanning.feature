@OperatorV2 @ShipmentScanning @ShouldAlwaysRun
Feature: Shipment Scanning

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: scan order to shipment (uid:b776b582-a395-4a02-962a-9785f6945750)
    Given Create an V3 order with the following attributes:
      | Note                 | hiptest-uid                              | type   | pickup_date | pickup_timewindow_id | delivery_date | delivery_timewindow_id | max_delivery_days | parcel_size | parcel_volume | parcel_weight | from_name        | from_contact  | from_email         | from_address1         | from_address2 | from_city | from_country | from_postcode | to_name      | to_contact    | to_email           | to_address1           | to_address2  | to_city | to_country | to_postcode |
      | C2C Nextday          | uid:f2ed4f50-c6f8-4736-902a-c6033dd53063 | C2C    | TODAY       | 1                    | TOMORROW      | 2                      | 1                 | 2           | 9000          | 3000          | Han Solo Exports | 91234567      | jane.doe@gmail.com | 30 Jalan Kilang Barat | Ninja Van HQ  | SG        | SG           | 159363        | James T Kirk | 98765432      | john.doe@gmail.com | 998 Toa Payoh North   | #01-10       | SG      | SG         | 318993      |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentScanning.
    Given Operator go to menu Inter-Hub -> Shipment Scanning
    When Operator scan the created order to shipment in hub 30JKB

  @KillBrowser
  Scenario: Kill Browser
