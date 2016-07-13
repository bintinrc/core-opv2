package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.LoadableComponent;
import org.testng.Assert;

/**
 * Created by sw on 6/30/16.
 */
public class LogoutPage extends LoadableComponent<LogoutPage> {

    private final WebDriver driver;

    public LogoutPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    @Override
    protected void load() {

    }

    @Override
    protected void isLoaded() throws Error {

    }

    public void logout() throws InterruptedException {
        WebElement elm = driver.findElement(By.xpath("//span[@class='nv-text-ellipsis nv-p-med name ng-binding']"));

        Actions acts = new Actions(driver);
        acts.moveToElement(elm).click().perform();
        CommonUtil.pause1s();

        elm = driver.findElement(By.xpath("//button[@class='nv-button md-button md-ink-ripple'][@ng-click='logout()']"));
        acts.moveToElement(elm).click().perform();
    }

}
