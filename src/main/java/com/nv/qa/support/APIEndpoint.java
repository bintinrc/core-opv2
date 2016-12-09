package com.nv.qa.support;

import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 *
 * @author Soewandi Wirjawan
 */
public final class APIEndpoint
{
    private static final String CONFIGURATION_FILE = "config.properties";
    private static final String ENVIRONMENT_SYSTEM_PROPERTY = "environment";

    public static final int STEP_DELAY_MILLISECONDS;
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
    public static final int SHIPPER_ID;
    public static final String SHIPPER_CLIENT_ID;
    public static final String SHIPPER_CLIENT_SECRET;

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
                STEP_DELAY_MILLISECONDS = Integer.valueOf(props.getProperty("step-delay-seconds")) * 1000;

                SELENIUM_DRIVER = props.getProperty("selenium-driver");
                SELENIUM_CHROME_DRIVER = props.getProperty("selenium-chrome-driver-location");
                SELENIUM_CHROME_BINARY_PATH = props.getProperty("selenium-chrome_binary-path");
                SELENIUM_INTERACTION_WAIT_MILLISECONDS = getPropertyValueAsInteger(props, "selenium-interaction-wait-seconds") * 1000;
                SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS = getPropertyValueAsInteger(props, "selenium-implicit-wait-timeout-seconds");
                SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS = getPropertyValueAsInteger(props, "selenium-page-load-timeout-seconds");
                SELENIUM_SCRIPT_TIMEOUT_SECONDS = getPropertyValueAsInteger(props, "selenium-script-timeout-seconds");
                SELENIUM_WINDOW_WIDTH = getPropertyValueAsInteger(props, "selenium-window-width");
                SELENIUM_WINDOW_HEIGHT = getPropertyValueAsInteger(props, "selenium-window-height");
                SELENIUM_WRITE_PATH = props.getProperty("selenium-write-path");
                {
                    new File(SELENIUM_WRITE_PATH).mkdirs();
                }

                OPERATOR_PORTAL_URL = props.getProperty("operator-portal-url");
                OPERATOR_PORTAL_UID = props.getProperty("operator-portal-uid");
                OPERATOR_PORTAL_PWD = props.getProperty("operator-portal-pwd");

                API_BASE_URL = props.getProperty("api-server-base-url");
                SHIPPER_ID = Integer.valueOf(props.getProperty("shipper-v3-id"));
                SHIPPER_CLIENT_ID = props.getProperty("shipper-client-id");
                SHIPPER_CLIENT_SECRET = props.getProperty("shipper-client-secret");

                OPERATOR_V1_CLIENT_ID = props.getProperty("operator-v1-client-id");
                OPERATOR_V1_CLIENT_SECRET = props.getProperty("operator-v1-client-secret");
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

    private static int getPropertyValueAsInteger(Properties props, String key)
    {
        int value = 0;

        try
        {
            value = Integer.parseInt(props.getProperty(key, "0"));
        }
        catch(NumberFormatException ex)
        {
            ex.printStackTrace();
        }

        return value;
    }
}
