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


/**
 * Created by sw on 6/30/16.
 */
public class MainPage extends LoadableComponent<MainPage> {

    private final WebDriver driver;

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
        String container = null;
        String mainTitle = null;
        if (navTitle.equals("dp administrator")) {
            container = "container.dp-administration.dp-partners";
            mainTitle = "dp-administration";
        } else if (navTitle.equals("driver strength")) {
            container = "container.driver-strength";
            mainTitle = "driver-strength";
        } else if (navTitle.equals("driver type management")) {
            container = "container.driver-type-management";
            mainTitle = "driver-type-management";
        }

        driver.findElement(By.xpath("//button[@ng-click=\"ctrl.navigateTo('" + container + "')\"]")).click();
        final String mainDashboard = mainTitle;
        (new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS)).until(new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                return d.getCurrentUrl().toLowerCase().endsWith(mainDashboard);
            }
        });

        String url = driver.getCurrentUrl().toLowerCase();
        Assert.assertTrue(url.endsWith(mainDashboard));
    }

    public void dpAdm() throws InterruptedException {
        final String mainDashboard = "dp-administration";
        (new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS)).until(new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                return d.getCurrentUrl().toLowerCase().endsWith(mainDashboard);
            }
        });

        String url = driver.getCurrentUrl().toLowerCase();
        Assert.assertTrue(url.endsWith(mainDashboard));
        CommonUtil.pause10s();
    }

}