package com.nv.qa.support;

import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Properties;

/**
 *
 * @author Soewandi Wirjawan
 */
public final class APIEndpoint
{
    private static final SimpleDateFormat TEMP_FOLDER_DATE_FORMAT = new SimpleDateFormat("dd-MMM-yyyy_hhmmss_SSS");

    private static final String CONFIGURATION_FILE = "config.properties";
    private static final String ENVIRONMENT_SYSTEM_PROPERTY = "environment";

    public static final int STEP_DELAY_MILLISECONDS;

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
    public static final int SELENIUM_WINDOW_WIDTH;
    public static final int SELENIUM_WINDOW_HEIGHT;
    public static final String SELENIUM_WRITE_PATH;

    public static final String OPERATOR_PORTAL_URL;
    public static final String OPERATOR_PORTAL_UID;
    public static final String OPERATOR_PORTAL_PWD;

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

    static
    {
        try
        {
            Properties props = new Properties();
            String environment = System.getProperty(ENVIRONMENT_SYSTEM_PROPERTY);
            String configurationFileName = StringUtils.isBlank(environment) ? "local-" + CONFIGURATION_FILE : environment + "-" + CONFIGURATION_FILE;
            System.out.println("Config File Used: " + configurationFileName);

            try(InputStream inputStream = APIEndpoint.class.getClassLoader().getResourceAsStream(configurationFileName))
            {
                if(inputStream!=null)
                {
                    props.load(inputStream);
                }
                else
                {
                    throw new FileNotFoundException("Property file '" + configurationFileName + "' not found in the classpath.");
                }

                /**
                 * Read new properties variable below.
                 */
                STEP_DELAY_MILLISECONDS = getPropertyValueAsInteger(props, "step-delay-seconds") * 1000;

                ENABLE_PROXY = getPropertyValueAsBoolean(props, "enable-proxy");
                PROXY_READ_BANDWIDTH_LIMIT_IN_BPS = getPropertyValueAsLong(props, "proxy-read-bandwidth-limit-in-bps");
                PROXY_WRITE_BANDWIDTH_LIMIT_IN_BPS = getPropertyValueAsLong(props, "proxy-write-bandwidth-limit-in-bps");

                SELENIUM_DRIVER = getPropertyValueAsString(props, "selenium-driver");
                SELENIUM_CHROME_DRIVER = getPropertyValueAsString(props, "selenium-chrome-driver-location");

                String seleniumChromeBinaryPathTemp = getPropertyValueAsString(props, "selenium-chrome_binary-path");

                if(seleniumChromeBinaryPathTemp==null || seleniumChromeBinaryPathTemp.isEmpty())
                {
                    seleniumChromeBinaryPathTemp = System.getenv("bamboo_capability_system_builder_command_google_chrome");
                    System.out.println("[INFO] Using SELENIUM_CHROME_BINARY_PATH from \"System Environment\" variable. [bamboo_capability_system_builder_command_google_chrome = '"+seleniumChromeBinaryPathTemp+'\'');
                }

                SELENIUM_CHROME_BINARY_PATH = seleniumChromeBinaryPathTemp;

                System.out.println("===== System Environment Variables =====");
                Map<String,String> mapOfSystemEnvironmentVariable = System.getenv();

                for(Map.Entry<String,String> entry : mapOfSystemEnvironmentVariable.entrySet())
                {
                    System.out.println(entry.getKey()+" = "+entry.getValue());
                }

                System.out.println("========================================");

                SELENIUM_INTERACTION_WAIT_MILLISECONDS = getPropertyValueAsInteger(props, "selenium-interaction-wait-seconds") * 1000;
                SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS = getPropertyValueAsInteger(props, "selenium-implicit-wait-timeout-seconds");
                SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS = getPropertyValueAsInteger(props, "selenium-page-load-timeout-seconds");
                SELENIUM_SCRIPT_TIMEOUT_SECONDS = getPropertyValueAsInteger(props, "selenium-script-timeout-seconds");
                SELENIUM_WINDOW_WIDTH = getPropertyValueAsInteger(props, "selenium-window-width");
                SELENIUM_WINDOW_HEIGHT = getPropertyValueAsInteger(props, "selenium-window-height");
                SELENIUM_WRITE_PATH = getPropertyValueAsString(props, "selenium-write-path") + TEMP_FOLDER_DATE_FORMAT.format(new Date()) + File.separatorChar;

                {
                    // Ensure directory exist.
                    new File(SELENIUM_WRITE_PATH).mkdirs();
                }

                OPERATOR_PORTAL_URL = getPropertyValueAsString(props, "operator-portal-url");
                OPERATOR_PORTAL_UID = getPropertyValueAsString(props, "operator-portal-uid");
                OPERATOR_PORTAL_PWD = getPropertyValueAsString(props, "operator-portal-pwd");

                API_BASE_URL = getPropertyValueAsString(props, "api-server-base-url");
                ORDER_CREATE_BASE_URL = getPropertyValueAsString(props, "order-create-server-base-url");
                SHIPPER_ID = getPropertyValueAsInteger(props, "shipper-v3-id");
                SHIPPER_CLIENT_ID = getPropertyValueAsString(props, "shipper-client-id");
                SHIPPER_CLIENT_SECRET = getPropertyValueAsString(props, "shipper-client-secret");

                SHIPPER_V2_ID = getPropertyValueAsInteger(props, "shipper-v2-id");
                SHIPPER_V2_NAME = getPropertyValueAsString(props, "shipper-v2-name");
                SHIPPER_V2_CLIENT_ID = getPropertyValueAsString(props, "shipper-v2-client-id");
                SHIPPER_V2_CLIENT_SECRET = getPropertyValueAsString(props, "shipper-v2-client-secret");

                OPERATOR_V1_CLIENT_ID = getPropertyValueAsString(props, "operator-v1-client-id");
                OPERATOR_V1_CLIENT_SECRET = getPropertyValueAsString(props, "operator-v1-client-secret");
            }
        }
        catch(IOException ex)
        {
            throw new RuntimeException(ex);
        }
    }

    private APIEndpoint()
    {
    }

    private static String getPropertyValueAsString(Properties props, String key)
    {
        return props.getProperty(key, "");
    }

    private static boolean getPropertyValueAsBoolean(Properties props, String key)
    {
        return Boolean.parseBoolean(props.getProperty(key, "false"));
    }

    private static int getPropertyValueAsInteger(Properties props, String key)
    {
        return Integer.parseInt(props.getProperty(key, "0"));
    }

    private static long getPropertyValueAsLong(Properties props, String key)
    {
        return Long.parseLong(props.getProperty(key, "0"));
    }
}
