@OperatorV2 @OperatorV2Part1 @Cleaning
Feature: Cleaning

  Scenario: Clean shipper's addresses and reservations
    Given API Operator clean shipper's addresses and reservation of shipper with Legacy ID = "{shipper-v2-legacy-id}"
    Given API Operator clean shipper's addresses and reservation of shipper with Legacy ID = "{shipper-v4-legacy-id}"

  Scenario: Force succeed all orders
    Given API Operator force succeed all orders that created 14 days ago and prior
