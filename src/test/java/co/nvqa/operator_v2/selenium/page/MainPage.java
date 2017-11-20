package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.nv.qa.utils.NvLogger;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Soewandi Wirjawan
 */
public class MainPage extends SimplePage
{
    private static final Map<String, String> MAP_OF_END_URL = new HashMap<>();

    static
    {
        MAP_OF_END_URL.put("1. Create Route Groups", "transactions/v2");
        MAP_OF_END_URL.put("2. Route Group Management", "route-group");
        MAP_OF_END_URL.put("3. Route Engine - Zonal Routing", "zonal-routing");
        MAP_OF_END_URL.put("4. Route Engine - Bulk Add to Route", "add-parcel-to-route");
        MAP_OF_END_URL.put("5. Route Engine - Same-Day Route Engine", "same-day-route-engine");
        MAP_OF_END_URL.put("All Orders", "order");
        MAP_OF_END_URL.put("DP Company Management", "dp-company");
        MAP_OF_END_URL.put("DP Vault Management", "dp-station");
        MAP_OF_END_URL.put("Hubs Administration", "hub");
        MAP_OF_END_URL.put("Linehaul Management", "linehaul");
        MAP_OF_END_URL.put("Messaging Module", "sms");
        MAP_OF_END_URL.put("Printer Settings", "printers");
    }

    public MainPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickNavigation(String parentTitle, String navTitle, String urlPart)
    {
        // Ensure no dialog that prevents menu from being clicked.
        getwebDriver().navigate().refresh();
        pause1s();
        TestUtils.waitPageLoad(getwebDriver());

        String navElmXpath = "//nv-section-item/button[div='" + navTitle + "']";
        WebElement navElm = getwebDriver().findElement(By.xpath(navElmXpath));

        if(!navElm.isDisplayed())
        {
            getwebDriver().findElement(By.xpath("//nv-section-header/button[span='" + parentTitle + "']")).click();
        }

        pause1s();
        navElm.click();

        new WebDriverWait(getwebDriver(), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS).until((d)->
        {
            boolean result;
            String currentUrl = d.getCurrentUrl();
            NvLogger.infof("Current URL = [%s] - Expected URL = [%s]", currentUrl, urlPart);

            if(urlPart.equals("linehaul"))
            {
                result = currentUrl.contains(urlPart);
            }
            else
            {
                result = currentUrl.toLowerCase().endsWith(urlPart);
            }

            return result;
        });
    }

    public void clickNavigation(String parentTitle, String navTitle)
    {
        final String mainDashboard = grabEndURL(navTitle);
        clickNavigation(parentTitle, navTitle, mainDashboard);
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

    public void dpAdm()
    {
        String mainDashboard = grabEndURL("All Orders");
        new WebDriverWait(getwebDriver(), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS).until((d)->d.getCurrentUrl().toLowerCase().endsWith(mainDashboard));
        String url = getwebDriver().getCurrentUrl().toLowerCase();
        Assert.assertThat("URL not match.", url, Matchers.endsWith(mainDashboard));
        pause5s();
    }
}
