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
        pause50ms();
        moveAndClick(driver, el);
    }

    public static void moveAndClick(WebDriver driver, WebElement el) {
        Actions action = new Actions(driver);
        action.moveToElement(el);
        pause300ms();
        action.click();
        action.perform();
        pause300ms();
    }

    public static void inputText(WebDriver driver, String xpath, String value) {
        WebElement el = driver.findElement(By.xpath(xpath));
        el.clear();
        pause300ms();
        el.sendKeys(value);
        pause300ms();
    }

    public static void hoverMouseTo(WebDriver driver, String xpath) {
        WebElement el = driver.findElement(By.xpath(xpath));
        pause100ms();
        moveTo(driver, el);
    }

    public static void moveTo(WebDriver driver, WebElement el) {
        Actions action = new Actions(driver);
        action.moveToElement(el);
        action.perform();
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

        if (driver.findElements(By.xpath("//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[@aria-selected='false']")).size() < 7) {

            //clear selected item
            List<WebElement> activeItem = driver.findElements(By.xpath("//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[@aria-selected='true']"));
            for (WebElement item : activeItem) {
                CommonUtil.moveAndClick(driver, item);
            }
        }

        for (String value : values) {
            CommonUtil.clickBtn(driver, "//div[contains(@class, 'md-active')]/md-select-menu/md-content/md-option[div[contains(text(),'" + value + "')]]");
        }
    }

    public static void pause10s() {
        pause(10_000);
    }

    public static void pause3s() {
        pause(3_000);
    }

    public static void pause1s() {
        pause(1_000);
    }

    public static void pause100ms() {
        pause(100);
    }

    public static void pause200ms() {
        pause(200);
    }

    public static void pause300ms() {
        pause(300);
    }

    public static void pause500ms() {
        pause(500);
    }

    public static void pause50ms() {
        pause(50);
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

    public static int dayToInteger(String day) {
        if (day.equalsIgnoreCase("SUNDAY")) {
            return 1;
        } else if (day.equalsIgnoreCase("MONDAY")) {
            return 2;
        } else if (day.equalsIgnoreCase("TUESDAY")) {
            return 3;
        } else if (day.equalsIgnoreCase("WEDNESDAY")) {
            return 4;
        } else if (day.equalsIgnoreCase("THURSDAY")) {
            return 5;
        } else if (day.equalsIgnoreCase("FRIDAY")) {
            return 6;
        } else if (day.equalsIgnoreCase("SATURDAY")) {
            return 7;
        } else {
            return 0;
        }
    }

    public static String integerToMonth(int month) {
        if (month == 0) {
            return "January";
        } else if (month == 1) {
            return "February";
        } else if (month == 2) {
            return "March";
        } else if (month == 3) {
            return "April";
        } else if (month == 4) {
            return "May";
        } else if (month == 5) {
            return "June";
        } else if (month == 6) {
            return "July";
        } else if (month == 7) {
            return "August";
        } else if (month == 8) {
            return "September";
        } else if (month == 9) {
            return "October";
        } else if (month == 10) {
            return "November";
        } else if (month == 11) {
            return "December";
        } else {
            return null;
        }
    }
}
