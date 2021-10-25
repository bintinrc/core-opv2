Feature: COD Collected and Not Collected


  @coverage-operator-manual @coverage-manual @step-done @e2e-dini @station-happy-path
  Scenario: Driver Collects x COD but Not Route Inbound x (uid:009c3453-5bed-446a-a8ba-d684a7f9ab93)
    Given Operator have "Order with x COD" and the status is "Arrived at Sorting Hub"
    When Operator assign "delivery transaction" to "route"
    And Driver success "the delivery"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is increase (+x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x)"
    And Make sure "sum of total cash under COD collected from courier is not updated"

  @coverage-operator-manual @coverage-manual @step-done @e2e-dini @station-happy-path
  Scenario: Driver Collects x COD and Route Inbound y (x > y) (uid:5fb4c4d3-638d-4c28-8138-032d14fe75e6)
    Given Operator have "Order with x COD" and the status is "Arrived at Sorting Hub"
    When Operator assign "delivery transaction" to "route"
    And Driver success "the delivery"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is increase (+x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x)"
    When Operator open "Route Inbound" page in "OPV2"
    And Operator update "cash collected" to "y which x > y "
    Then Make sure "money to collect is NOT fully collected"
    When Operator refresh the "Station Management Homepage" page
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is decrease (-y)"
    When Operator click "hamburger" button
    And Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x-y)"
    And Make sure "sum of total cash under COD collected from courier is increase (+y)"

  @coverage-operator-manual @coverage-manual @step-done @e2e-dini @station-happy-path
  Scenario: Driver Collects x COD and Route Inbound y (y > x) (uid:2ed21c73-2097-4afd-b29f-edb5a7d17514)
    Given Operator have "Order with x COD" and the status is "Arrived at Sorting Hub"
    When Operator assign "delivery transaction" to "route"
    And Driver success "the delivery"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is increase (+x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x)"
    When Operator open "Route Inbound" page in "OPV2"
    And Operator update "cash collected" to "y which x < y"
    Then Make sure "money to collect is fully collected"
    When Operator refresh the "Station Management Homepage" page
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is decrease (-y)"
    When Operator click "hamburger" button
    And Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x-y) and show negative value if total cod < y"
    And Make sure "sum of total cash under COD collected from courier is increase (+y)"

  @coverage-operator-manual @coverage-manual @step-done @e2e-dini @station-happy-path
  Scenario: Driver Collects x COD and Route Inbound x (uid:093c7728-d38e-42d1-9e62-1db53fab1585)
    Given Operator have "Order with x COD" and the status is "Arrived at Sorting Hub"
    When Operator assign "delivery transaction" to "route"
    And Driver success "the delivery"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is increase (+x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x)"
    When Operator open "Route Inbound" page in "OPV2"
    And Operator update "cash collected" to "same as expected total"
    Then Make sure "money to collect is fully collected"
    When Operator refresh the "Station Management Homepage" page
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is decrease (-x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = Completed"
    And Make sure "sum of total cash under COD collected from courier is increase (+x)"

  @coverage-operator-manual @coverage-manual @step-done @e2e-dini
  Scenario: Driver Collects x COP but Not Route Inbound x (uid:aaec869d-7120-4b52-85c8-083a129054d7)
    Given Operator have "Return Order with x COP" and the status is "Pending Pickup"
    When Operator assign "pickup transaction" to "route"
    And Driver success "the pickup"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is increase (+x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x)"
    And Make sure "sum of total cash under COD collected from courier is not updated"

  @coverage-operator-manual @coverage-manual @step-done @e2e-dini
  Scenario: Driver Collects x COP and Route Inbound y (x > y) (uid:b35e0575-c1b3-4238-a9c3-79a298feefb6)
    Given Operator have "Return Order with x COP" and the status is "Pending Pickup"
    When Operator assign "pickup transaction" to "route"
    And Driver success "the pickup"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is increase (+x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x)"
    When Operator open "Route Inbound" page in "OPV2"
    And Operator update "cash collected" to "y which x > y "
    Then Make sure "money to collect is NOT fully collected"
    When Operator refresh the "Station Management Homepage" page
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is decrease (-y)"
    When Operator click "hamburger" button
    And Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x-y)"
    And Make sure "sum of total cash under COD collected from courier is increase (+y)"

  @coverage-operator-manual @coverage-manual @step-done @e2e-dini
  Scenario: Driver Collects x COP and Route Inbound y (y > x) (uid:61f1d829-45f7-469d-ad43-57fe6f1ef392)
    Given Operator have "Return Order with x COP" and the status is "Pending Pickup"
    When Operator assign "pickup transaction" to "route"
    And Driver success "the pickup"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is increase (+x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x)"
    When Operator open "Route Inbound" page in "OPV2"
    And Operator update "cash collected" to "y which x < y"
    Then Make sure "money to collect is fully collected"
    When Operator refresh the "Station Management Homepage" page
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is decrease (-y)"
    When Operator click "hamburger" button
    And Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x-y) and show negative value if total cop < y"
    And Make sure "sum of total cash under COD collected from courier is increase (+y)"

  @coverage-operator-manual @coverage-manual @step-done @e2e-dini
  Scenario: Driver Collects x COP and Route Inbound x (uid:47a4a0db-44b0-4231-abe6-8073d7ed40e2)
    Given Operator have "Return Order with x COP" and the status is "Arrived at Sorting Hub"
    When Operator assign "pickup transaction" to "route"
    And Driver success "the pickup"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is increase (+x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = (x)"
    When Operator open "Route Inbound" page in "OPV2"
    And Operator update "cash collected" to "same as expected total"
    Then Make sure "money to collect is fully collected"
    When Operator refresh the "Station Management Homepage" page
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cash under COD not collected yet from courier is decrease (-x)"
    When Operator click "hamburger" button
    Then Make sure "COD not collected yet from couriers" modal will be displayed
    And Make sure "it show Driver Name, Route ID, and COD Amount to Collect = Completed"
    And Make sure "sum of total cash under COD collected from courier is increase (+x)"

  @coverage-operator-manual @coverage-manual @step-done
  Scenario: View Route Manifest Page (uid:ec35f255-6e77-4eaf-a457-7dedc4366690)
    Given Operator have "Order with x COD" and the status is "Arrived at Sorting Hub"
    When Operator assign "delivery transaction" to "route"
    And Driver success "the delivery"
    When Operator open "Station Management Homepage" page in "OPV2"
    And Operator select "same" hub from "route's hub"
    And Operator click "Proceed" button
    Then Make sure "sum of total cod under COD not collected yet from courier is increase (+x)"
    And Make sure "it show driver name, driver route id, and cod not inbounded yet (x)"
    When Operator click "route id"
    Then Make sure operator is redirected to "Route Manifest" page
