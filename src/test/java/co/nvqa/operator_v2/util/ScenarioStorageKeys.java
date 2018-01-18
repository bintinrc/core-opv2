package co.nvqa.operator_v2.util;

import co.nvqa.commons.utils.StandardScenarioStorageKeys;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public interface ScenarioStorageKeys extends StandardScenarioStorageKeys
{
    String KEY_DELIVERY_JOB_ID = "key-driver-delivery-job-id";
    String KEY_DELIVERY_WAYPOINT_ID = "key-driver-delivery-waypoint-id";
    String KEY_DRIVER_ROUTES_LIST = "key-driver-routes-list";
    String KEY_DRIVER_JOB_ORDER = "key-driver-job-order";

    String KEY_OPERATOR_AUTH_RESPONSE = "key-operator-auth-response";
    String KEY_DRIVER_LOGIN_RESPONSE = "key-driver-login-response";

    String KEY_ROUTE_GROUP_NAME = "key-route-group-name";
    String KEY_SHIPMENT_ID = "key-shipment-id";
}
