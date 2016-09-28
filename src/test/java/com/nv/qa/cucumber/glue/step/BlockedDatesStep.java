package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioHelper;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Created by sw on 8/19/16.
 */
@ScenarioScoped
public class BlockedDatesStep {

    private WebDriver driver;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
    }

    @After
    public void teardown(Scenario scenario) {
        if (scenario.isFailed()) {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^blocked dates add$")
    public void add() {
        List<WebElement> elm = driver.findElements(By.xpath("//div[@ng-repeat='day in week track by $index' and not(contains(@class, 'active')) and not(contains(@class, 'not-same-month'))]"));
        if (!elm.isEmpty()) {
            WebElement day = elm.get(0);
            day.click();

            WebElement yearElm = driver.findElement(By.xpath("//md-select[@ng-model='calendar.year']/md-select-value/span/div"));
            ScenarioHelper.getInstance().setTmpId(yearElm.getText() + "-" + getMonth() + "-" + getDay(day));
            CommonUtil.clickBtn(driver, "//button[@type='submit'][@aria-label='Save Button']");
        }
    }

    @Then("^blocked dates verify add$")
    public void verifyAdd() {
        if (ScenarioHelper.getInstance().getTmpId() != null) {
            boolean isAdded = false;
            List<WebElement> els = driver.findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]/p/span[1]"));
            for (WebElement el : els) {
                if (el.getText().contains(ScenarioHelper.getInstance().getTmpId())) {
                    isAdded = true;
                    break;
                }
            }
            Assert.assertTrue(isAdded);
        }
    }

    @When("^blocked dates remove$")
    public void remove() {
        if (ScenarioHelper.getInstance().getTmpId() != null) {
            boolean isRemoved = false;
            List<WebElement> els = driver.findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]"));
            for (WebElement el : els) {
                WebElement inner = el.findElement(By.xpath("p/span[1]"));
                if (inner.getText().contains(ScenarioHelper.getInstance().getTmpId())) {
                    el.findElement(By.xpath("button[@ng-click=\"removeDate(date, $event)\"]")).click();
                    CommonUtil.clickBtn(driver, "//button[@type='submit'][@aria-label='Save Button']");
                    isRemoved = true;
                    break;
                }
            }
            Assert.assertTrue(isRemoved);
        }

    }

    @Then("^blocked dates verify remove$")
    public void verifyRemove() {
        if (ScenarioHelper.getInstance().getTmpId() != null) {
            boolean isFound = false;
            List<WebElement> els = driver.findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]/p/span[1]"));
            for (WebElement el : els) {
                if (el.getText().contains(ScenarioHelper.getInstance().getTmpId())) {
                    isFound = true;
                    break;
                }
            }
            Assert.assertFalse(isFound);
        }
    }

    private String getDay(WebElement day) {
        WebElement dayTxt = day.findElement(By.xpath("div[1]"));
        int dayNumber = Integer.parseInt(dayTxt.getText());
        return dayNumber < 10 ? "0" + dayNumber : "" + dayNumber;
    }

    private String getMonth() {
        String monthText = null;
        try {
            WebElement monthElm = driver.findElement(By.xpath("//md-select[@ng-model='calendar.month']/md-select-value/span/div"));
            Date date = new SimpleDateFormat("MMMM", Locale.ENGLISH).parse(monthElm.getText());
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            int month = cal.get(Calendar.MONTH) + 1;
            monthText = month < 10 ? "0" + month : "" + month;
        } catch (Exception e) {
        }
        return monthText;
    }
}