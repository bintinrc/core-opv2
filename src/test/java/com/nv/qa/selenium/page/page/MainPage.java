package com.nv.qa.selenium.page.page;

import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
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
    private final String MAIN_DASHBOARD = "dp-administration";
    private final Map<String, String> map = new HashMap<String, String>() {{
        put("DP Administration","container.dp-administration.dp-partners");
        put("Driver Strength","container.driver-strength");
        put("Driver Type Management","container.driver-type-management");
        put("Pricing Template","container.pricing-template");
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
        final String mainDashboard = navTitle.toLowerCase().replaceAll(" ", "-");

//        driver.findElement(By.xpath("//button[@ng-click=\"ctrl.navigateTo('" + container + "')\"]")).click();
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
        (new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS)).until(new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                return d.getCurrentUrl().toLowerCase().endsWith(MAIN_DASHBOARD);
            }
        });

        String url = driver.getCurrentUrl().toLowerCase();
        Assert.assertTrue(url.endsWith(MAIN_DASHBOARD));
        CommonUtil.pause10s();
    }

}