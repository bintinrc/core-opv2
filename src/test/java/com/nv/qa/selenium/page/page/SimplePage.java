package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.*;
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

    public void click(String xpathExpression)
    {
        WebElement we = findElementByXpath(xpathExpression);
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
        WebElement we = findElementByXpath(xpathExpression);
        we.clear();
        pause500ms();
        we.sendKeys(keysToSend);
        pause500ms();
    }

    public WebElement findElementByXpath(String xpathExpression)
    {
        return driver.findElement(By.xpath(xpathExpression));
    }

    public List<WebElement> findElementsByXpath(String xpathExpression)
    {
        return driver.findElements(By.xpath(xpathExpression));
    }

    public void closeModal()
    {
        WebElement we = findElementByXpath("//div[(contains(@class, 'nv-text-ellipsis nv-h4'))]");

        Actions actions = new Actions(driver);
        actions.moveToElement(we, 5, 5)
                .click()
                .build()
                .perform();
        CommonUtil.pause100ms();
    }

    public String getTextOnTable(int rowNumber, String columnDataClass, String mdVirtualRepeat)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat);
    }

    public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass, String mdVirtualRepeat)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat, false);
    }

    public String getTextOnTableWithMdVirtualRepeat(int rowNumber, String columnDataClass, String mdVirtualRepeat, boolean classMustExact)
    {
        String text = null;

        try
        {
            WebElement we;

            if(classMustExact)
            {
                we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[normalize-space(@class)='%s']", mdVirtualRepeat, rowNumber, columnDataClass));
            }
            else
            {
                we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, '%s')]", mdVirtualRepeat, rowNumber, columnDataClass));
            }

            text = we.getText().trim();
        }
        catch(NoSuchElementException ex)
        {
        }

        return text;
    }

    public void clickActionButtonOnTableWithMdVirtualRepeat(int rowNumber, String actionButtonName, String ngRepeat)
    {
        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'actions')]//nv-icon-button[@name='%s']", ngRepeat, rowNumber, actionButtonName));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button on table.", ex);
        }
    }

    public String getTextOnTableWithNgRepeat(int rowNumber, String columnDataClass, String ngRepeat)
    {
        String text = null;

        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[contains(@class, '%s')]", ngRepeat, rowNumber, columnDataClass));
            text = we.getText().trim();
        }
        catch(NoSuchElementException ex)
        {
        }

        return text;
    }

    public void clickActionButtonOnTableWithNgRepeat(int rowNumber, String actionButtonName, String ngRepeat)
    {
        try
        {
            WebElement we = findElementByXpath(String.format("//tr[@ng-repeat='%s'][%d]/td[contains(@class, 'actions')]//nv-icon-button[@name='%s']", ngRepeat, rowNumber, actionButtonName));
            moveAndClick(we);
        }
        catch(NoSuchElementException ex)
        {
            throw new RuntimeException("Cannot find action button on table.", ex);
        }
    }

    public void inputListBox(String placeHolder, String searchValue) throws InterruptedException
    {
        WebElement we = findElementByXpath("//input[@placeholder='" + placeHolder + "']");
        we.clear();
        we.sendKeys(searchValue);
        pause1s();
        we.sendKeys(Keys.RETURN);
        pause100ms();
        closeModal();
    }

    public void selectValueFromMdSelectMenu(String xpathMdSelectMenu, String xpathMdSelectOption)
    {
        WebElement mdSelectMenu = findElementByXpath(xpathMdSelectMenu);
        mdSelectMenu.click();
        pause500ms();
        WebElement mdSelectOption = CommonUtil.getElementByXpath(driver, xpathMdSelectOption);
        mdSelectOption.click();
        pause500ms();
    }

    public boolean isElementExist(String xpathExpression)
    {
        WebElement we = null;

        try
        {
            we = findElementByXpath(xpathExpression);
        }
        catch(NoSuchElementException ex)
        {
        }

        return we!=null;
    }

    public void pause50ms()
    {
        pause(50);
    }

    public void pause100ms()
    {
        pause(100);
    }

    public void pause200ms()
    {
        pause(200);
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

    public void pause5s()
    {
        pause(5000);
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
