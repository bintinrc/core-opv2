package com.nv.qa.selenium.page;

import com.nv.qa.support.TestConstants;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
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
    }

    public MainPage(WebDriver driver)
    {
        super(driver);
    }

    public void clickNavigation(String parentTitle, String navTitle, String urlPart)
    {
        // Ensure no dialog that prevents menu from being clicked.
        driver.navigate().refresh();
        CommonUtil.pause1s();
        SeleniumHelper.waitPageLoad(driver);

        String navElmXpath = "//nv-section-item/button[div='" + navTitle + "']";
        WebElement navElm = driver.findElement(By.xpath(navElmXpath));

        if(!navElm.isDisplayed())
        {
            driver.findElement(By.xpath("//nv-section-header/button[span='" + parentTitle + "']")).click();
        }

        CommonUtil.pause1s();
        navElm.click();

        new WebDriverWait(driver, TestConstants.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS).until((d)->
        {
            boolean result;
            String currentUrl = d.getCurrentUrl();
            System.out.println(String.format("[INFO] Current URL = [%s] - Expected URL = [%s]", currentUrl, urlPart));

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
        new WebDriverWait(driver, TestConstants.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS).until((d)->d.getCurrentUrl().toLowerCase().endsWith(mainDashboard));
        String url = driver.getCurrentUrl().toLowerCase();
        Assert.assertThat("URL not match.", url, Matchers.endsWith(mainDashboard));
        CommonUtil.pause5s();
    }

    public void refreshPage()
    {
        String previousUrl = driver.getCurrentUrl().toLowerCase();
        driver.navigate().refresh();
        new WebDriverWait(driver, TestConstants.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS).until((d)->d.getCurrentUrl().equalsIgnoreCase(previousUrl));
        String currentUrl = driver.getCurrentUrl().toLowerCase();
        Assert.assertEquals("Page URL is different after page is refreshed.", previousUrl, currentUrl);
    }
}
