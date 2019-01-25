package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.util.SingletonStorage;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 *
 * @author Soewandi Wirjawan
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class BlockedDatesSteps extends AbstractSteps
{
    private static final SimpleDateFormat MONTH_SDF = new SimpleDateFormat("MMMM", Locale.ENGLISH);

    public BlockedDatesSteps()
    {
    }

    @Override
    public void init()
    {
    }

    @When("^blocked dates add$")
    public void add()
    {
        /*
          Set default year of "Blocked Dates" on right panel to current year.
         */
        WebElement blockedDatesYearWe = getWebDriver().findElement(By.xpath("//div[contains(@class, 'list')]/md-content[contains(@class, 'list-content')]/div/md-input-container"));
        blockedDatesYearWe.click();

        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        WebElement currentYearOptionWe = getWebDriver().findElement(By.xpath(f("//md-option[@ng-repeat='m in yearList' and @value='%d']", currentYear)));
        currentYearOptionWe.click();

        List<WebElement> elm = getWebDriver().findElements(By.xpath("//div[@ng-repeat='day in week track by $index' and not(contains(@class, 'active')) and not(contains(@class, 'not-same-month'))]"));

        if(!elm.isEmpty())
        {
            WebElement day = elm.get(0);
            day.click();

            WebElement yearElm = getWebDriver().findElement(By.xpath("//md-select[@ng-model='calendar.year']/md-select-value/span/div"));
            SingletonStorage.getInstance().setTmpId(yearElm.getText() + "-" + getMonth() + "-" + getDay(day));
            TestUtils.clickBtn(getWebDriver(), "//button[@type='submit'][@aria-label='Save Button']");
        }
    }

    @Then("^blocked dates verify add$")
    public void verifyAdd()
    {
        if(SingletonStorage.getInstance().getTmpId()!=null)
        {
            retryIfStaleElementReferenceExceptionOccurred(() ->
            {
                boolean isAdded = false;
                List<WebElement> els = getWebDriver().findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]/p/span[1]"));

                for(WebElement el : els)
                {
                    if(el.getText().contains(SingletonStorage.getInstance().getTmpId()))
                    {
                        isAdded = true;
                        break;
                    }
                }

                assertTrue("Blocked Date should be added.", isAdded);
            }, getCurrentMethodName(), getScenarioManager()::writeToCurrentScenarioLog);
        }
    }

    @When("^blocked dates remove$")
    public void remove()
    {
        if (SingletonStorage.getInstance().getTmpId()!=null)
        {
            boolean isRemoved = false;
            List<WebElement> els = getWebDriver().findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]"));

            for(WebElement el : els)
            {
                WebElement inner = el.findElement(By.xpath("p/span[1]"));

                if(inner.getText().contains(SingletonStorage.getInstance().getTmpId()))
                {
                    el.findElement(By.xpath("button[@ng-click=\"removeDate(date, $event)\"]")).click();
                    TestUtils.clickBtn(getWebDriver(), "//button[@type='submit'][@aria-label='Save Button']");
                    isRemoved = true;
                    break;
                }
            }

            assertTrue("Blocked Date should be removed.", isRemoved);
        }
    }

    @Then("^blocked dates verify remove$")
    public void verifyRemove()
    {
        if(SingletonStorage.getInstance().getTmpId()!=null)
        {
            retryIfStaleElementReferenceExceptionOccurred(() ->
            {
                boolean isFound = false;
                List<WebElement> els = getWebDriver().findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]/p/span[1]"));

                for(WebElement el : els)
                {
                    if(el.getText().contains(SingletonStorage.getInstance().getTmpId()))
                    {
                        isFound = true;
                        break;
                    }
                }

                assertFalse(isFound);
            }, getCurrentMethodName(), getScenarioManager()::writeToCurrentScenarioLog);
        }
    }

    private String getDay(WebElement day)
    {
        WebElement dayTxt = day.findElement(By.xpath("div[1]"));
        int dayNumber = Integer.parseInt(dayTxt.getText());
        return dayNumber < 10 ? "0" + dayNumber : "" + dayNumber;
    }

    private String getMonth()
    {
        String monthText = null;

        try
        {
            WebElement monthElm = getWebDriver().findElement(By.xpath("//md-select[@ng-model='calendar.month']/md-select-value/span/div"));
            Date date = MONTH_SDF.parse(monthElm.getText());
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            int month = cal.get(Calendar.MONTH) + 1;
            monthText = month < 10 ? "0" + month : "" + month;
        }
        catch(Exception ex)
        {
            NvLogger.warnf("Failed to get month. Cause: %s", ex.getMessage());
        }

        return monthText;
    }
}
