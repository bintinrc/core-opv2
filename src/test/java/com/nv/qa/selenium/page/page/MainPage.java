package com.nv.qa.selenium.page.page;

import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.LoadableComponent;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

import java.util.HashMap;
import java.util.Map;


/**
 * Created by sw on 6/30/16.
 */
public class MainPage extends LoadableComponent<MainPage> {

    private final WebDriver driver;
//    private final String MAIN_DASHBOARD = "dp-administration";
//    private final String MAIN_DASHBOARD = "https://operatorv2-qa.ninjavan.co/#/sg/";
//    private final String MAIN_DASHBOARD = "https://operatorv2-qa.ninjavan.co/#/";
    private final Map<String, String> map = new HashMap<String, String>() {{
        put("DP Administration","container.dp-administration.dp-partners");
        put("Driver Strength","container.driver-strength");
        put("Driver Type Management","container.driver-type-management");
        put("Pricing Scripts","container.pricing-scripts");
        put("Hubs Administration","container.hub-list");
        put("Blocked Dates","container.blocked-dates");
        put("Shipment Management","container.shipment-management");
    }};

    public MainPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    @Override
    protected void load() {
    }

    @Override
    protected void isLoaded() throws Error {
    }

    public void clickNavigation(String navTitle) throws InterruptedException {
        String container = map.get(navTitle);
        String name = navTitle.toLowerCase().replaceAll(" ", "-");
        if (navTitle.trim().equalsIgnoreCase("hubs administration")) {
            name = "hub";
        } else if (navTitle.trim().equalsIgnoreCase("shipment management")) {
            name = "shipment-management";
        }

        final String mainDashboard = name;

        driver.findElement(By.xpath("//button[contains(@ng-click,\"ctrl.navigateTo('" + container + "'\")]")).click();
        (new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS)).until(new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                return d.getCurrentUrl().toLowerCase().endsWith(mainDashboard);
            }
        });

        String url = driver.getCurrentUrl().toLowerCase();
        Assert.assertTrue(url.endsWith(mainDashboard));
    }

    public void dpAdm() throws InterruptedException {
        /*(new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS)).until(new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                return d.getCurrentUrl().toLowerCase().endsWith(MAIN_DASHBOARD);
            }
        });

        String url = driver.getCurrentUrl().toLowerCase();
        Assert.assertTrue(url.endsWith(MAIN_DASHBOARD));
        CommonUtil.pause10s();*/

        SeleniumHelper.waitUntilElementVisible(driver, driver.findElement(By.xpath("//md-content[(contains(@class,'nv-container-landing-page md-padding'))]/h2[@class='md-title']")));
        WebElement elm = driver.findElement(By.xpath("//md-content[(contains(@class,'nv-container-landing-page md-padding'))]/h2[@class='md-title']"));
        Assert.assertTrue(elm.getText().contains("Welcome to Operator V2"));
        CommonUtil.pause10s();
    }

}