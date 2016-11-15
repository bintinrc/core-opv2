package com.nv.qa.selenium.page.page;

import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class SimplePage
{
    private WebDriver driver;

    public SimplePage(WebDriver driver)
    {
        this.driver = driver;
    }

    public void clickButton(String xpathExpression)
    {
        WebElement we = getElementByXpath(xpathExpression);
        moveAndClick(we);
    }

    public void moveAndClick(WebElement we)
    {
        Actions action = new Actions(driver);
        action.moveToElement(we);
        pause500ms();
        action.click();
        action.perform();
        pause500ms();
    }

    public void sendKeys(String xpathExpression, CharSequence... keysToSend)
    {
        WebElement we = getElementByXpath(xpathExpression);
        we.clear();
        pause500ms();
        we.sendKeys(keysToSend);
        pause500ms();
    }

    public WebElement getElementByXpath(String xpathExpression)
    {
        return driver.findElement(By.xpath(xpathExpression));
    }

    public List<WebElement> getElementsByXpath(String xpathExpression)
    {
        return driver.findElements(By.xpath(xpathExpression));
    }


    public void pause100ms()
    {
        pause(100);
    }

    public void pause500ms()
    {
        pause(500);
    }

    public void pause1s()
    {
        pause(1000);
    }

    public void pause3s()
    {
        pause(3000);
    }

    public void pause10s()
    {
        pause(10000);
    }

    public void pause(long millis)
    {
        try
        {
            Thread.sleep(1000);
        }
        catch(InterruptedException ex)
        {
            ex.printStackTrace();
        }
    }

    public WebDriver getDriver()
    {
        return driver;
    }
}
