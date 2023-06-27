package co.nvqa.operator_v2.cucumber;

import co.nvqa.commons.cucumber.StandardScenarioStorageKeys;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("unused")
public interface
ScenarioStorageKeys extends StandardScenarioStorageKeys {

  String KEY_MAIN_WINDOW_HANDLE = "KEY_MAIN_WINDOW_HANDLE";
  String KEY_PICKUP_INSTRUCTION = "KEY_PICKUP_INSTRUCTION";
  String KEY_DELIVERY_INSTRUCTION = "KEY_DELIVERY_INSTRUCTION";

  String KEY_CREATED_USER_MANAGEMENT = "KEY_CREATED_USER_MANAGEMENT";
  String KEY_UPDATED_USER_MANAGEMENT = "KEY_UPDATED_USER_MANAGEMENT";
  String KEY_SELECTED_GRANT_TYPE = "KEY_SELECTED_GRANT_TYPE";

  String KEY_CREATED_RESERVATION_GROUP = "KEY_CREATED_RESERVATION_GROUP";

  String KEY_PRIORITY_LEVELS_TRANSACTION_TO_PRIORITY_LEVEL = "KEY_PRIORITY_LEVELS_TRANSACTION_TO_PRIORITY_LEVEL";

  String KEY_CREATED_MOVEMENT_SCHEDULE = "KEY_CREATED_MOVEMENT_SCHEDULE";
  String KEY_SUB_SHIPPER_SELLER_LEGACY_ID = "KEY_SUB_SHIPPER_SELLER_LEGACY_ID";
  String KEY_SUB_SHIPPER_SELLER_ID = "KEY_SUB_SHIPPER_SELLER_ID";
  String KEY_LIST_SUB_SHIPPER_SELLER_ID = "KEY_LIST_SUB_SHIPPER_SELLER_ID";
  String KEY_LIST_SUB_SHIPPER_SELLER_NAME = "KEY_LIST_SUB_SHIPPER_SELLER_NAME";
  String KEY_LIST_SUB_SHIPPER_SELLER_EMAIL = "KEY_LIST_SUB_SHIPPER_SELLER_EMAIL";

  String KEY_TRIP_ID = "KEY_TRIP_ID";

  String KEY_NUMBER_OF_PARCELS_IN_HUB = "KEY_NUMBER_OF_PARCELS_IN_HUB";
  String KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP = "KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP";
  String KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP2 = "KEY_NUMBER_OF_ADDRESS_IN_PENDING_PICKUP2";

  String KEY_NUMBER_OF_PARCELS_IN_HUB_TILE_2 = "KEY_NUMBER_OF_PARCELS_IN_HUB_TILE_2";
  String KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE = "KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE";
  String KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB = "KEY_COD_DOLLAR_AMOUNT_NOT_COLLECTED_IN_HUB";
  String KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB = "KEY_COD_DOLLAR_AMOUNT_COLLECTED_IN_HUB";
  String KEY_NUMBER_OF_SFLD_TICKETS_IN_HUB = "KEY_NUMBER_OF_SFLD_TICKETS_IN_HUB";
  String KEY_COMMA_DELIMITED_ORDER_TO_ADDRESS = "KEY_COMMA_DELIMITED_ORDER_TO_ADDRESS";
  String KEY_ATTEMPTS_VALIDATED_TODAY = "KEY_ATTEMPTS_VALIDATED_TODAY";
  String KEY_EVENT_TIME = "KEY_EVENT_TIME";
  String KEY_OLD_ROUTE_ID = "KEY_OLD_ROUTE_ID";
  String KEY_SNS_CHAT_INVITE_LINK = "KEY_SNS_CHAT_INVITE_LINK";
  String KEY_UPDATED_DRIVER_DISPLAY_NAME = "KEY_UPDATED_DRIVER_DISPLAY_NAME";
  String KEY_LIST_DRIVER_ANNOUNCEMENT_SUBJECTS = "KEY_LIST_ANNOUNCEMENT_SUBJECTS";
  String KEY_LIST_DRIVER_PAYROLL_SUBJECTS = "KEY_LIST_PAYROLL_SUBJECTS";
  String KEY_REPORT_SCHEDULE_TEMPLATE = "KEY_REPORT_SCHEDULE_TEMPLATE";
}
