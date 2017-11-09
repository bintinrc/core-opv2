package com.nv.qa.selenium.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

/**
 *
 * @author Soewandi Wirjawan
 */
public class LogoutPage
{
    private final WebDriver driver;

    public LogoutPage(WebDriver driver)
    {
        this.driver = driver;
    }

    public void logout()
    {
        WebElement elm = driver.findElement(By.xpath("//span[(contains(@class, 'nv-text-ellipsis nv-p-med name'))]"));

        Actions acts = new Actions(driver);
        acts.moveToElement(elm).click().perform();
        CommonUtil.pause1s();

        elm = driver.findElement(By.xpath("//button[@class='nv-button flat alternate md-button md-ink-ripple'][@ng-click='logout()']"));
        acts.moveToElement(elm).click().perform();
    }
}
