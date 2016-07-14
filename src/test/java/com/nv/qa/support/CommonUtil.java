package com.nv.qa.support;

import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Soewandi Wirjawan
 */
public class CommonUtil {

    private CommonUtil()
    {
    }

    public static void clickBtn(WebDriver driver, String xpath) {
        WebElement el = driver.findElement(By.xpath(xpath));
        pause100ms();
        moveAndClick(driver, el);
    }

    public static void moveAndClick(WebDriver driver, WebElement el) {
        Actions action = new Actions(driver);
        action.moveToElement(el);
        action.click();
        action.perform();
        pause1s();
    }

    public static void inputText(WebDriver driver, String xpath, String value) {
        WebElement el = driver.findElement(By.xpath(xpath));
        el.clear();
        pause100ms();
        el.sendKeys(value);
        pause1s();
    }

    public static void pause10s() {
        pause(10000);
    }

    public static void pause1s() {
        pause(1000);
    }

    public static void pause100ms() {
        pause(100);
    }

    public static void pause10ms() {
        pause(10);
    }

    public static void pause(long millis) {
        try
        {
            Thread.sleep(millis);
        }
        catch(InterruptedException ex)
        {
            ex.printStackTrace();
        }
    }

    public static WebElement getResultInTable(WebDriver driver, String tableXpath, String value) {
        List<WebElement> trs = driver.findElements(By.xpath(tableXpath)); //tr
        for (WebElement tr : trs) {
            List<WebElement> tds = tr.findElements(By.tagName("td"));
            for (WebElement td : tds) {
                if (td.getText().trim().equalsIgnoreCase(value)) {
                    return tr;
                }
            }
        }
        return null;
    }

    public static WebElement verifySearchingResults(WebDriver driver, String placeHolder, String ngTable) {
        String txt = driver.findElement(By.xpath("//input[@placeholder='" + placeHolder + "'][@ng-model='searchText']")).getAttribute("value");
        WebElement result = CommonUtil.getResultInTable(driver, "//table[@ng-table='" + ngTable + "']/tbody/tr", txt);
        Assert.assertTrue(result != null);
        return result;
    }

    public static Map.Entry<String, Integer> getMinEntry(Map<String, Integer> map) {
        return Collections.min(map.entrySet(), new Comparator<Map.Entry<String, Integer>>() {
            public int compare(Map.Entry<String, Integer> entry1, Map.Entry<String, Integer> entry2) {
                return entry1.getValue().compareTo(entry2.getValue());
            }
        });
    }

    public static void closeModal(WebDriver driver) {
        Actions builder = new Actions(driver);
        builder.moveToElement(driver.findElement(By.xpath("//div[@class='nv-text-ellipsis nv-navtitle ng-binding']")), 5, 5).click().build().perform();
        CommonUtil.pause100ms();
    }

    public static WebElement getElementByXpath(WebDriver driver, String xpathExpression)
    {
        WebElement element = null;

        try
        {
            element = driver.findElement(By.xpath(xpathExpression));
        }
        catch(NoSuchElementException ex)
        {
        }

        return element;
    }
}
