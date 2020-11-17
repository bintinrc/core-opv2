@OperatorV2 @SalesOps @PriceCalculationTrigger

Feature: Populate Marketplace_id in Priced Orders table

  Scenario: Populate Marketplace_id for Order Created By Normal Shipper (uid:836e660c-b5f6-49a4-a790-b633196a8103)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Then Operator gets price order details from the database
    Then Operator verifies dwh_qa_gl.priced_orders.marketplace_id is "null"

  Scenario: Populate Marketplace_id for Order Created By Marketplace Shipper (uid:67339447-ee65-4eed-8227-57be9e4d44b8)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-mktpl-v4-client-id}                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-sop-mktpl-v4-client-secret}                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Then Operator gets price order details from the database
    Then Operator verifies dwh_qa_gl.priced_orders.marketplace_id is "null"

  Scenario: Populate Marketplace_id for Order Created By Marketplace Subshipper (uid:68177af4-f0cd-4dd2-a5df-09e30733d170)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {sub-shipper-sop-mktpl-v4-client-id}                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {sub-shipper-sop-mktpl-v4-client-secret}                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Then Operator gets price order details from the database
    Then Operator verifies dwh_qa_gl.priced_orders.marketplace_id is "{shipper-sop-mktpl-v4-global-id}"

  Scenario: Populate Marketplace_id for Order Created By Corporate Shipper (uid:9d91a8ea-3280-455c-a2e7-3dd2c79192de)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {shipper-sop-corp-v4-client-id}                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-sop-corp-v4-client-secret}                                                                                                                                                                                                                                                                                             |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Then Operator gets price order details from the database
    Then Operator verifies dwh_qa_gl.priced_orders.marketplace_id is "null"

  Scenario: Populate Marketplace_id for Order Created By Corporate Subshipper (uid:552caacc-2dc7-4729-86ab-a1ea79dd76a0)
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {sub-shipper-sop-corp-v4-client-id}                                                                                                                                                                                                                                                                                             |
      | shipperClientSecret | {sub-shipper-sop-corp-v4-client-secret}                                                                                                                                                                                                                                                                                         |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "requested_tracking_number": "SO-{gradle-current-date-yyyyMMddHHmmsss}" ,"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    Then Operator gets price order details from the database
    Then Operator verifies dwh_qa_gl.priced_orders.marketplace_id is "null"