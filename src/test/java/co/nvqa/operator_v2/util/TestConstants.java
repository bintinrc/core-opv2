package co.nvqa.operator_v2.util;

import com.nv.qa.utils.StandardTestConstants;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Soewandi Wirjawan
 */
public final class TestConstants extends StandardTestConstants
{
    private static final SimpleDateFormat TEMP_FOLDER_DATE_FORMAT = new SimpleDateFormat("dd-MMM-yyyy_hhmmss_SSS");

    private static final String CONFIGURATION_FILE = "config.properties";
    private static final String ENVIRONMENT_SYSTEM_PROPERTY = "environment";

    public static final String REPORT_HTML_OUTPUT_DIR = System.getProperty("REPORT_HTML_OUTPUT_DIR");

    public static final boolean ENABLE_PROXY;
    public static final long PROXY_READ_BANDWIDTH_LIMIT_IN_BPS;
    public static final long PROXY_WRITE_BANDWIDTH_LIMIT_IN_BPS;

    public static final String SELENIUM_DRIVER;
    public static final String SELENIUM_CHROME_DRIVER;
    public static final String SELENIUM_CHROME_BINARY_PATH;
    public static final int SELENIUM_INTERACTION_WAIT_MILLISECONDS;
    public static final int SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS;
    public static final int SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS;
    public static final int SELENIUM_SCRIPT_TIMEOUT_SECONDS;
    public static final long SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS;
    public static final int SELENIUM_WINDOW_WIDTH;
    public static final int SELENIUM_WINDOW_HEIGHT;
    public static final String SELENIUM_WRITE_PATH;

    public static final String OPERATOR_PORTAL_URL;
    public static final String OPERATOR_PORTAL_UID;
    public static final String OPERATOR_PORTAL_PWD;
    public static final boolean OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES;
    public static final String OPERATOR_PORTAL_USER_COOKIE;

    public static final String API_BASE_URL;
    public static final String ORDER_CREATE_BASE_URL;
    public static final int SHIPPER_ID;
    public static final String SHIPPER_CLIENT_ID;
    public static final String SHIPPER_CLIENT_SECRET;

    public static final int SHIPPER_V2_ID;
    public static final String SHIPPER_V2_NAME;
    public static final String SHIPPER_V2_CLIENT_ID;
    public static final String SHIPPER_V2_CLIENT_SECRET;

    public static final String OPERATOR_V1_CLIENT_ID;
    public static final String OPERATOR_V1_CLIENT_SECRET;

    public static final int NINJA_DRIVER_ID;
    public static final String NINJA_DRIVER_USERNAME;
    public static final String NINJA_DRIVER_PASSWORD;

    public static final String DB_DRIVER;
    public static final String DB_URL_CORE;
    public static final String DB_URL_QA_AUTOMATION;
    public static final String DB_USER;
    public static final String DB_PASS;

    static
    {
        try
        {
            loadProperties(ENVIRONMENT_SYSTEM_PROPERTY, CONFIGURATION_FILE);

            ENABLE_PROXY = getPropertyValueAsBoolean("enable-proxy");
            PROXY_READ_BANDWIDTH_LIMIT_IN_BPS = getPropertyValueAsLong("proxy-read-bandwidth-limit-in-bps");
            PROXY_WRITE_BANDWIDTH_LIMIT_IN_BPS = getPropertyValueAsLong("proxy-write-bandwidth-limit-in-bps");

            SELENIUM_DRIVER = getPropertyValueAsString("selenium-driver");
            SELENIUM_CHROME_DRIVER = getPropertyValueAsString("selenium-chrome-driver-location");

            String seleniumChromeBinaryPathTemp = getPropertyValueAsString("selenium-chrome_binary-path");

            if(seleniumChromeBinaryPathTemp==null || seleniumChromeBinaryPathTemp.isEmpty())
            {
                seleniumChromeBinaryPathTemp = System.getenv("bamboo_capability_system_builder_command_google_chrome");
                System.out.println("[INFO] Using SELENIUM_CHROME_BINARY_PATH from \"System Environment\" variable. [bamboo_capability_system_builder_command_google_chrome = '"+seleniumChromeBinaryPathTemp+"']");
            }

            SELENIUM_CHROME_BINARY_PATH = seleniumChromeBinaryPathTemp;
            System.out.println("[INFO] Selenium Chrome Binary Path = "+SELENIUM_CHROME_BINARY_PATH);

            SELENIUM_INTERACTION_WAIT_MILLISECONDS = getPropertyValueAsInteger("selenium-interaction-wait-seconds") * 1000;
            SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS = getPropertyValueAsInteger("selenium-implicit-wait-timeout-seconds");
            SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS = getPropertyValueAsInteger("selenium-page-load-timeout-seconds");
            SELENIUM_SCRIPT_TIMEOUT_SECONDS = getPropertyValueAsInteger("selenium-script-timeout-seconds");
            SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS = getPropertyValueAsLong("selenium-default-web-driver-wait-timeout-in-seconds");
            SELENIUM_WINDOW_WIDTH = getPropertyValueAsInteger("selenium-window-width");
            SELENIUM_WINDOW_HEIGHT = getPropertyValueAsInteger("selenium-window-height");
            SELENIUM_WRITE_PATH = getPropertyValueAsStringAndCreateDirectory("selenium-write-path", TEMP_FOLDER_DATE_FORMAT.format(new Date())+File.separatorChar);

            OPERATOR_PORTAL_URL = getPropertyValueAsString("operator-portal-url");
            OPERATOR_PORTAL_UID = getPropertyValueAsString("operator-portal-uid");
            OPERATOR_PORTAL_PWD = getPropertyValueAsString("operator-portal-pwd");
            OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES = getPropertyValueAsBoolean("operator-portal-force-login-by-injecting-cookies");
            OPERATOR_PORTAL_USER_COOKIE = getPropertyValueAsString("operator-portal-user-cookie");

            API_BASE_URL = getPropertyValueAsString("api-server-base-url");
            ORDER_CREATE_BASE_URL = getPropertyValueAsString("order-create-server-base-url");
            SHIPPER_ID = getPropertyValueAsInteger("shipper-v3-id");
            SHIPPER_CLIENT_ID = getPropertyValueAsString("shipper-client-id");
            SHIPPER_CLIENT_SECRET = getPropertyValueAsString("shipper-client-secret");

            SHIPPER_V2_ID = getPropertyValueAsInteger("shipper-v2-id");
            SHIPPER_V2_NAME = getPropertyValueAsString("shipper-v2-name");
            SHIPPER_V2_CLIENT_ID = getPropertyValueAsString("shipper-v2-client-id");
            SHIPPER_V2_CLIENT_SECRET = getPropertyValueAsString("shipper-v2-client-secret");

            OPERATOR_V1_CLIENT_ID = getPropertyValueAsString("operator-v1-client-id");
            OPERATOR_V1_CLIENT_SECRET = getPropertyValueAsString("operator-v1-client-secret");

            NINJA_DRIVER_ID = getPropertyValueAsInteger("ninja-driver-id");
            NINJA_DRIVER_USERNAME = getPropertyValueAsString("ninja-driver-username");
            NINJA_DRIVER_PASSWORD = getPropertyValueAsString("ninja-driver-password");

            DB_DRIVER = getPropertyValueAsString("db-driver");
            DB_URL_CORE = getPropertyValueAsString("db-url-core");
            DB_URL_QA_AUTOMATION = getPropertyValueAsString("db-url-qa-automation");
            DB_USER = getPropertyValueAsString("db-user");
            DB_PASS = getPropertyValueAsString("db-pass");
        }
        catch(IOException ex)
        {
            throw new RuntimeException("Fail to load file properties.", ex);
        }
    }

    private TestConstants()
    {
    }
}
