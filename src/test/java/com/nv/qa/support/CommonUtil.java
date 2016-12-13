package com.nv.qa.support;

import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;

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

    public static void chooseValueFromMdContain(WebDriver driver, String xpathContainer, String value) {

        driver.findElement(By.xpath(xpathContainer)).click();
        CommonUtil.pause1s();

        CommonUtil.clickBtn(driver,"//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[div[contains(text(),'" + value + "')]]");
    }

    public static void chooseValuesFromMdContain(WebDriver driver, String xpathContainer, List<String> values) {

        driver.findElement(By.xpath(xpathContainer)).click();
        CommonUtil.pause10ms();

        //clear selected item
        List<WebElement> activeItem = driver.findElements(By.xpath("//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[@aria-selected='true']"));
        for (WebElement item : activeItem) {
            CommonUtil.moveAndClick(driver, item);
        }

        for (String value : values) {
            CommonUtil.clickBtn(driver, "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[div[contains(text(),'" + value + "')]]");
        }
    }

    public static void pause10s() {
        pause(10000);
    }

    public static void pause3s() {
        pause(3000);
    }

    public static void pause1s() {
        pause(1000);
    }

    public static void pause100ms() {
        pause(100);
    }

    public static void pause200ms() {
        pause(200);
    }

    public static void pause500ms() {
        pause(500);
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

    public static WebElement getToast(WebDriver driver) {
        return getElementByXpath(driver, "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
    }

    public static List<WebElement> getToasts(WebDriver driver) {
        return getElementsByXpath(driver, "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
    }

    public static void closeModal(WebDriver driver) {
        Actions builder = new Actions(driver);
        builder.moveToElement(driver.findElement(By.xpath("//div[(contains(@class, 'nv-text-ellipsis nv-h4'))]")), 5, 5).click().build().perform();
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

    public static List<WebElement> getElementsByXpath(WebDriver driver, String xpathExpression)
    {
        List<WebElement> elements = null;

        try
        {
            elements = driver.findElements(By.xpath(xpathExpression));
        }
        catch(NoSuchElementException ex)
        {
        }

        return elements;
    }

    public static boolean isElementExist(WebDriver driver, String xpathExpression)
    {
        return getElementByXpath(driver, xpathExpression)!=null;
    }

    public static void selectValueFromMdSelectMenu(WebDriver driver, String xpathMdSelectMenu, String xpathMdSelectOption)
    {
        WebElement mdSelectMenu = CommonUtil.getElementByXpath(driver, xpathMdSelectMenu);
        mdSelectMenu.click();
        pause(500);
        WebElement mdSelectOption = CommonUtil.getElementByXpath(driver, xpathMdSelectOption);
        mdSelectOption.click();
        pause(500);
    }

    public static void inputListBox(WebDriver driver, String placeHolder, String searchValue) throws InterruptedException {
        WebElement el = driver.findElement(By.xpath("//input[@placeholder='" + placeHolder + "']"));
        el.clear();
        el.sendKeys(searchValue);
        CommonUtil.pause1s();
        el.sendKeys(Keys.RETURN);
        CommonUtil.pause100ms();
        CommonUtil.closeModal(driver);
    }

    /**
     * This method return 9 digit random number.
     *
     * @return
     */
    public static String generateTrackingRefNo()
    {
        long millis = System.currentTimeMillis();
        long secondsSince1970 = millis/1000;
        String result = String.valueOf(secondsSince1970).substring(1); //Remove the first index to remove the most significant value of timestamp.
        return result;
    }

    public static String replaceParam(String data, Map<String,String> mapOfDynamicVariable)
    {
        if(data==null)
        {
            return null;
        }

        String result = data;

        for(Map.Entry<String,String> entry : mapOfDynamicVariable.entrySet())
        {
            result = result.replaceAll("\\{\\{"+entry.getKey()+"\\}\\}", entry.getValue());
        }

        return result;
    }
}
