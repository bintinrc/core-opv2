package com.nv.qa.support;

import org.apache.commons.lang3.StringUtils;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Created by clydetan on 2/2/16.
 */
public final class APIEndpoint {

    public static final String CONFIGURATION_FILE = "config.properties";

    public static final int STEP_DELAY_MILLISECONDS;
    public static final String SELENIUM_DRIVER;
    public static final String SELENIUM_CHROME_DRIVER;
    public static final int SELENIUM_INTERACTION_WAIT_MILLISECONDS;
    public static final int SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS;
    public static final int SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS;
    public static final int SELENIUM_SCRIPT_TIMEOUT_SECONDS;


    public static final String ENVIRONMENT_SYSTEM_PROPERTY = "environment";

    public static final String OPERATOR_PORTAL_URL;
    public static final String OPERATOR_PORTAL_UID;
    public static final String OPERATOR_PORTAL_PWD;


    private APIEndpoint() {
    }

    static {
        try {
            Properties prop = new Properties();
            String environment = System.getProperty(ENVIRONMENT_SYSTEM_PROPERTY);
            String configurationFileName = StringUtils.isBlank(environment)
                    ? "local-" + CONFIGURATION_FILE
                    : environment + "-" + CONFIGURATION_FILE;

            System.out.println("Config File Used " + configurationFileName);

            try (InputStream inputStream = APIEndpoint.class.getClassLoader().getResourceAsStream(configurationFileName);) {
                if (inputStream != null) {
                    prop.load(inputStream);
                } else {
                    throw new FileNotFoundException("property file '" + configurationFileName + "' not found in the classpath");
                }

                //-- read new properties variable here
                STEP_DELAY_MILLISECONDS = Integer.valueOf(prop.getProperty("step-delay-seconds")) * 1000;

                SELENIUM_DRIVER = prop.getProperty("selenium-driver");
                SELENIUM_CHROME_DRIVER = prop.getProperty("selenium-chrome-driver-location");
                SELENIUM_INTERACTION_WAIT_MILLISECONDS = Integer.valueOf(prop.getProperty("selenium-interaction-wait-seconds")) * 1000;
                SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS = Integer.valueOf(prop.getProperty("selenium-implicit-wait-timeout-seconds"));
                SELENIUM_PAGE_LOAD_TIMEOUT_SECONDS = Integer.valueOf(prop.getProperty("selenium-page-load-timeout-seconds"));
                SELENIUM_SCRIPT_TIMEOUT_SECONDS = Integer.valueOf(prop.getProperty("selenium-script-timeout-seconds"));

                OPERATOR_PORTAL_URL = prop.getProperty("operator-portal-url");
                OPERATOR_PORTAL_UID = prop.getProperty("operator-portal-uid");
                OPERATOR_PORTAL_PWD = prop.getProperty("operator-portal-pwd");
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }
  }
