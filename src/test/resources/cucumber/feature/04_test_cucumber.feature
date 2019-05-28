@04TestCucumber
Feature: Test Cucumber
  Dedicated feature files that contains scenario to test Cucumber API
  compatibility when we update the Cucumber version.

  Scenario: Test Cucumber API
    Given Test Map parameter:
      | id   | 1      |
      | name | Test 1 |
    Given Test DataTable parameter:
      | id   | 2      |
      | name | Test 2 |
    Given Test int parameter: 1234
    Given Test RegEx decimal to long: 5678
    Given Test combination parameters 1 -> name = "Cucumber", ID = 9012, other parameters:
      | id   | 3      |
      | name | Test 3 |

    @CWF @RT
  Scenario: Dummy scenario for Reject Reservation
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    Given API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Operator add reservation pick-up to the route
    Given API Operator start the route
    Given API Driver collect all his routes
    Given API Driver get Reservation Job
    Given API Driver reject Reservation
    Given DB Operator get Booking ID of Reservation
    Given API Operator fail the reservation using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 7           |
      | failureReasonIndexMode | FIRST       |

#curl 'https://api-qa.ninjavan.co/sg/overwatch/1.1/bookings/353481' -X DELETE -H 'Accept: application/json, text/plain, */*' -H 'Referer: https://operatorv2-qa.ninjavan.co/' -H 'Origin: https://operatorv2-qa.ninjavan.co' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.157 Safari/537.36' -H 'Authorization: Bearer zo9Wp8GfNRw4XF4baOgrbuOZnfYcFEJcCAv1oVRh' -H 'timezone: Asia/Singapore' -H 'Content-Type: application/json; charset=UTF-8' --data-binary '{"failure_reason_id":76,"failure_reason":"Rejected - no AWB"}' --compressed