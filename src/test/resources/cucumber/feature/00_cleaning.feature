@OperatorV2 @Cleaning
Feature: Cleaning

  Scenario: Clean shipper's address
    Given API Operator clean address of shipper with ID = "{shipper-v2-id}"

  Scenario: Force succeed all orders
    Given API Operator force succeed all orders that created 14 days ago and prior
