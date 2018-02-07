package co.nvqa.operator_v2.util;

import co.nvqa.common_selenium.util.CommonSeleniumTestConstants;

/**
 *
 * @author Soewandi Wirjawan
 */
public final class TestConstants extends CommonSeleniumTestConstants
{
    public static final String OPERATOR_PORTAL_URL;
    public static final String OPERATOR_PORTAL_UID;
    public static final String OPERATOR_PORTAL_PWD;
    public static final boolean OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES;
    public static final String OPERATOR_PORTAL_USER_COOKIE;

    public static final long SHIPPER_V2_ID;
    public static final String SHIPPER_V2_NAME;
    public static final String SHIPPER_V2_CLIENT_ID;
    public static final String SHIPPER_V2_CLIENT_SECRET;

    public static final long SHIPPER_V3_ID;
    public static final String SHIPPER_V3_NAME;
    public static final String SHIPPER_V3_CLIENT_ID;
    public static final String SHIPPER_V3_CLIENT_SECRET;

    public static final long NINJA_DRIVER_ID;
    public static final String NINJA_DRIVER_NAME;
    public static final String NINJA_DRIVER_USERNAME;
    public static final String NINJA_DRIVER_PASSWORD;

    public static final Long DP_ID;

    public static final int VERY_LONG_WAIT_FOR_TOAST = 90;

    static
    {
        OPERATOR_PORTAL_URL = getPropertyValueAsString("operator-portal-url");
        OPERATOR_PORTAL_UID = getPropertyValueAsString("operator-portal-uid");
        OPERATOR_PORTAL_PWD = getPropertyValueAsString("operator-portal-pwd");

        OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES = getPropertyValueAsBoolean("operator-portal-force-login-by-injecting-cookies");
        OPERATOR_PORTAL_USER_COOKIE = getPropertyValueAsString("operator-portal-user-cookie");

        API_BASE_URL = getPropertyValueAsString("api-base-url");

        SHIPPER_V2_ID = getPropertyValueAsLong("shipper-v2-id");
        SHIPPER_V2_NAME = getPropertyValueAsString("shipper-v2-name");
        SHIPPER_V2_CLIENT_ID = getPropertyValueAsString("shipper-v2-client-id");
        SHIPPER_V2_CLIENT_SECRET = getPropertyValueAsString("shipper-v2-client-secret");

        SHIPPER_V3_ID = getPropertyValueAsLong("shipper-v3-id");
        SHIPPER_V3_NAME = getPropertyValueAsString("shipper-v3-name");
        SHIPPER_V3_CLIENT_ID = getPropertyValueAsString("shipper-v3-client-id");
        SHIPPER_V3_CLIENT_SECRET = getPropertyValueAsString("shipper-v3-client-secret");

        NINJA_DRIVER_ID = getPropertyValueAsLong("ninja-driver-id");
        NINJA_DRIVER_NAME = getPropertyValueAsString("ninja-driver-name");
        NINJA_DRIVER_USERNAME = getPropertyValueAsString("ninja-driver-username");
        NINJA_DRIVER_PASSWORD = getPropertyValueAsString("ninja-driver-password");

        DP_ID = getPropertyValueAsLong("dp-id");
    }

    private TestConstants()
    {
    }
}
