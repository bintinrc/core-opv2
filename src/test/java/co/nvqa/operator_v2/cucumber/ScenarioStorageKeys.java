package co.nvqa.operator_v2.cucumber;

import co.nvqa.commons.cucumber.StandardScenarioStorageKeys;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("unused")
public interface ScenarioStorageKeys extends StandardScenarioStorageKeys
{
    String KEY_ROUTE_GROUP_NAME = "KEY_ROUTE_GROUP_NAME";
    String KEY_MAIN_WINDOW_HANDLE = "KEY_MAIN_WINDOW_HANDLE";
    String KEY_PICKUP_INSTRUCTION = "KEY_PICKUP_INSTRUCTION";
    String KEY_DELIVERY_INSTRUCTION = "KEY_DELIVERY_INSTRUCTION";

    String KEY_ROUTE_CASH_INBOUND_COD = "KEY_ROUTE_CASH_INBOUND_COD";
    String KEY_ROUTE_CASH_INBOUND_COD_EDITED = "KEY_ROUTE_CASH_INBOUND_COD_EDITED";

    String KEY_CREATED_USER_MANAGEMENT = "KEY_CREATED_USER_MANAGEMENT";
    String KEY_UPDATED_USER_MANAGEMENT = "KEY_UPDATED_USER_MANAGEMENT";

    String KEY_CREATED_RESERVATION_GROUP = "KEY_CREATED_RESERVATION_GROUP";
}
