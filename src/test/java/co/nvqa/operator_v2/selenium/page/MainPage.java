package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.util.TestConstants;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebDriverException;
import org.openqa.selenium.WebElement;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class MainPage extends OperatorV2SimplePage
{
    private static final String XPATH_OF_TOAST_WELCOME_DASHBOARD = "//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-bottom'][text()='Welcome to your operator dashboard.']";
    private static final Map<String, String> MAP_OF_END_URL = new HashMap<>();

    static
    {
        MAP_OF_END_URL.put("1. Create Route Groups", "transactions/v2");
        MAP_OF_END_URL.put("2. Route Group Management", "route-group");
        MAP_OF_END_URL.put("3. Route Engine - Zonal Routing", "zonal-routing");
        MAP_OF_END_URL.put("4. Route Engine - Bulk Add to Route", "add-parcel-to-route");
        MAP_OF_END_URL.put("5. Route Engine - Same-Day Route Engine", "same-day-route-engine");
        MAP_OF_END_URL.put("All Orders", "order");
        MAP_OF_END_URL.put("All Shippers", "shippers");
        MAP_OF_END_URL.put("DP Company Management", "dp-company");
        MAP_OF_END_URL.put("DP Vault Management", "dp-station");
        MAP_OF_END_URL.put("Driver Report", "driver-reports");
        MAP_OF_END_URL.put("Hubs Administration", "hub");
        MAP_OF_END_URL.put("Linehaul Management", "linehaul");
        MAP_OF_END_URL.put("Messaging Module", "sms");
        MAP_OF_END_URL.put("Non Inbounded Orders", "non-inbounded-list");
        MAP_OF_END_URL.put("Order Creation V2", "create-combine");
        MAP_OF_END_URL.put("Order Creation V4", "create-v4");
        MAP_OF_END_URL.put("Pricing Scripts V2", "pricing-scripts-v2/active-scripts");
        MAP_OF_END_URL.put("Printer Settings", "printers");
        MAP_OF_END_URL.put("Recovery Tickets Scanning", "recovery-ticket-scanning");
        MAP_OF_END_URL.put("Route Cash Inbound", "cod");
        MAP_OF_END_URL.put("Third Party Shippers", "third-party-shipper");
        MAP_OF_END_URL.put("Third Party Order Management", "third-party-order");
        MAP_OF_END_URL.put("Lat/Lng Cleanup", "lat-lng-cleanup");
        MAP_OF_END_URL.put("Hubs Group Management", "hub-group");
        MAP_OF_END_URL.put("Outbound/Route Load Monitoring", "outbound-monitoring");
    }

    public MainPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    private String grabEndURL(String navTitle)
    {
        navTitle = navTitle.trim();
        String endUrl;

        if(MAP_OF_END_URL.containsKey(navTitle))
        {
            endUrl = MAP_OF_END_URL.get(navTitle);
        }
        else
        {
            endUrl = navTitle.toLowerCase().replaceAll(" ", "-");
        }

        return endUrl;
    }

    public void verifyTheMainPageIsLoaded()
    {
        if(isElementExistWait2Seconds("//button[@aria-label='login.sign-in-button']"))
        {
            getWebDriver().navigate().refresh();
        }

        String mainDashboardUrl = grabEndURL("All Orders");

        waitUntil(()->
        {
            String currentUrl = getCurrentUrl();
            NvLogger.infof("verifyTheMainPageIsLoaded: Current URL = [%s] - Expected URL Ends With = [%s]", currentUrl, mainDashboardUrl);
            return currentUrl.endsWith(mainDashboardUrl);
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS);

        waitUntilPageLoaded();
        NvLogger.infof("Waiting until Welcome message toast disappear.");
        waitUntilInvisibilityOfElementLocated(XPATH_OF_TOAST_WELCOME_DASHBOARD, TestConstants.VERY_LONG_WAIT_FOR_TOAST);

        String currentUrl = getCurrentUrl();
        String countrySpecificDashboardUrl = TestConstants.COUNTRY_CODE.toLowerCase()+'/'+mainDashboardUrl;

        if(!currentUrl.endsWith(countrySpecificDashboardUrl))
        {
            getWebDriver().navigate().to(TestConstants.OPERATOR_PORTAL_BASE_URL+'/'+countrySpecificDashboardUrl);
        }
    }

    public void clickNavigation(String parentTitle, String navTitle)
    {
        if(isElementVisible("//i[@ng-if='!showLogo()']"))
        {
            openNavigationPanel();
        }
        String mainDashboard = grabEndURL(navTitle);
        clickNavigation(parentTitle, navTitle, mainDashboard);
    }

    public void openNavigationPanel()
    {
        clickButtonByAriaLabel("Open Sidenav");
    }

    public void clickNavigation(String parentTitle, String navTitle, String urlPart)
    {
        String childNavXpath = String.format("//nv-section-item/button[div='%s']", navTitle);
        String parentNavXpath = String.format("//nv-section-header/button[span='%s']", parentTitle);

        for(int i=0; i<2; i++)
        {
            WebElement childNavWe = findElementByXpath(childNavXpath);

            if(!childNavWe.isDisplayed())
            {
                click(parentNavXpath);
                checkLeavingPage();
            }

            pause100ms();
            boolean refreshPage = true;

            if(childNavWe.isDisplayed())
            {
                try
                {
                    childNavWe.click();
                    checkLeavingPage();
                    refreshPage = false;
                }
                catch(WebDriverException ex)
                {
                    NvLogger.warn("Failed to click nav child.", ex);
                }
            }

            if(refreshPage)
            {
                // Ensure no dialog that prevents menu from being clicked.
                getWebDriver().navigate().refresh();
                refreshPage();
            }
            else
            {
                break;
            }
        }

        waitUntil(()->
        {
            boolean result;
            String currentUrl = getCurrentUrl();
            NvLogger.infof("clickNavigation: Current URL = [%s] - Expected URL Ends With = [%s]", currentUrl, urlPart);

            if("linehaul".equals(urlPart))
            {
                result = currentUrl.contains(urlPart);
            }
            else
            {
                result = currentUrl.endsWith(urlPart);
            }

            return result;
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS);

        waitUntilPageLoaded();
    }

    private void checkLeavingPage()
    {
        String xpath = "//md-dialog//h2[text()='Leaving Page']";

        if(isElementExistWait0Second(xpath))
        {
            clickButtonByAriaLabel("Leave");
        }
    }
}
