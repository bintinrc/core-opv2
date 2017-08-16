package com.nv.qa.selenium.page;

import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebDriverException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.LoadableComponent;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.util.HashMap;
import java.util.Map;


/**
 * Created by sw on 6/30/16.
 */
public class MainPage extends LoadableComponent<MainPage>
{
    private final WebDriver driver;
    private final Map<String, String> map = new HashMap<String, String>()
    {
        {
            put("DP Administration","container.dp-administration.dp-partners");
            put("Driver Strength","container.driver-strength");
            put("Driver Type Management","container.driver-type-management");
            put("Pricing Scripts","container.pricing-scripts");
            put("Hubs Administration","container.hub-list");
            put("Blocked Dates","container.blocked-dates");
            put("Shipment Management","container.shipment-management");
        }
    };

    public MainPage(WebDriver driver)
    {
        this.driver = driver;
    }

    @Override
    protected void load()
    {
    }

    @Override
    protected void isLoaded() throws Error
    {
    }


    public void clickNavigation(String parentTitle, String navTitle, String urlPart) throws  InterruptedException{
        //-- ensure no dialog that prevents menu from being clicked.
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

        new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS).until(
        new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d)
            {
                return d.getCurrentUrl().toLowerCase().endsWith(urlPart);
            }
        });

        String url = driver.getCurrentUrl().toLowerCase();
        Assert.assertTrue(url.endsWith(urlPart));
    }

    public void clickNavigation(String parentTitle, String navTitle) throws InterruptedException
    {
        final String mainDashboard = grabEndURL(navTitle);
        clickNavigation(parentTitle, navTitle, mainDashboard);
    }

    private String grabEndURL(String navTitle) {
        String endURL = navTitle.toLowerCase().replaceAll(" ", "-");

        if(navTitle.trim().equalsIgnoreCase("hubs administration"))
        {
            endURL = "hub";
        }
        else if(navTitle.trim().equalsIgnoreCase("linehaul management"))
        {
            endURL = "linehaul/entries";
        }
        else if(navTitle.trim().equalsIgnoreCase("route groups"))
        {
            endURL = "route-group";
        }
        else if(navTitle.trim().equalsIgnoreCase("Transactions V2"))
        {
            endURL = "transactions/v2";
        }
        else if (navTitle.trim().equalsIgnoreCase("all orders"))
        {
            endURL = "order";
        }
        return endURL;
    }

    public void dpAdm() throws InterruptedException
    {
        String mainDashboard = grabEndURL("All Orders");

        new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS).until(new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                return d.getCurrentUrl().toLowerCase().endsWith(mainDashboard);
            }
        });

        String url = driver.getCurrentUrl().toLowerCase();
        Assert.assertTrue(url.endsWith(mainDashboard));
        CommonUtil.pause5s();
    }

    public void refreshPage()
    {
        final String currentUrl = driver.getCurrentUrl().toLowerCase();
        driver.navigate().refresh();

        new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS).until(new ExpectedCondition<Boolean>()
        {
            public Boolean apply(WebDriver d)
            {
                return d.getCurrentUrl().equalsIgnoreCase(currentUrl);
            }
        });

        Assert.assertTrue(driver.getCurrentUrl().equalsIgnoreCase(currentUrl));
    }
}