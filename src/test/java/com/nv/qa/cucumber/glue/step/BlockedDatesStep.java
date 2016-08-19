package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioHelper;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.text.SimpleDateFormat;
import java.util.List;

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
    public void teardown() {

    }

    @When("^blocked dates add$")
    public void add() {
        List<WebElement> els = driver.findElements(By.xpath("//div[@ng-repeat=\"day in week track by $index\" and @class=\"layout-padding ng-scope layout-row flex\"]/div[@ng-bind-html=\"dataService.getDayContent(day)\"]"));
        if (!els.isEmpty()) {
            WebElement el = els.get(0);
            String tmp = el.getAttribute("id");
            ScenarioHelper.getInstance().setTmpId(convertDate(tmp.substring(0,6) + "20" + tmp.substring(6)));
            el.click();
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

    private String convertDate(String date) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd").format(new SimpleDateFormat("dd-MM-yyyy").parse(date));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}