package co.nvqa.operator_v2.cucumber.glue;

import com.google.inject.Inject;
import co.nvqa.operator_v2.support.CommonUtil;
import co.nvqa.operator_v2.support.ScenarioHelper;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
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

    @Inject
    public BlockedDatesSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
    }

    @When("^blocked dates add$")
    public void add()
    {
        /**
         * Set default year of "Blocked Dates" on right panel to current year.
         */
        WebElement blockedDatesYearWe = getDriver().findElement(By.xpath("//div[contains(@class, 'list')]/md-content[contains(@class, 'list-content')]/div/md-input-container"));
        blockedDatesYearWe.click();

        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        WebElement currentYearOptionWe = getDriver().findElement(By.xpath(String.format("//md-option[@ng-repeat='m in yearList' and @value='%d']", currentYear)));
        currentYearOptionWe.click();

        List<WebElement> elm = getDriver().findElements(By.xpath("//div[@ng-repeat='day in week track by $index' and not(contains(@class, 'active')) and not(contains(@class, 'not-same-month'))]"));

        if(!elm.isEmpty())
        {
            WebElement day = elm.get(0);
            day.click();

            WebElement yearElm = getDriver().findElement(By.xpath("//md-select[@ng-model='calendar.year']/md-select-value/span/div"));
            ScenarioHelper.getInstance().setTmpId(yearElm.getText() + "-" + getMonth() + "-" + getDay(day));
            CommonUtil.clickBtn(getDriver(), "//button[@type='submit'][@aria-label='Save Button']");
        }
    }

    @Then("^blocked dates verify add$")
    public void verifyAdd()
    {
        if(ScenarioHelper.getInstance().getTmpId()!=null)
        {
            CommonUtil.retryIfStaleElementReferenceExceptionOccurred(() ->
            {
                boolean isAdded = false;
                List<WebElement> els = getDriver().findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]/p/span[1]"));

                for(WebElement el : els)
                {
                    if(el.getText().contains(ScenarioHelper.getInstance().getTmpId()))
                    {
                        isAdded = true;
                        break;
                    }
                }

                Assert.assertTrue(isAdded);
            }, "verifyAdd", getScenarioManager()::writeToScenarioLog);
        }
    }

    @When("^blocked dates remove$")
    public void remove()
    {
        if (ScenarioHelper.getInstance().getTmpId()!=null)
        {
            boolean isRemoved = false;
            List<WebElement> els = getDriver().findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]"));

            for(WebElement el : els)
            {
                WebElement inner = el.findElement(By.xpath("p/span[1]"));

                if(inner.getText().contains(ScenarioHelper.getInstance().getTmpId()))
                {
                    el.findElement(By.xpath("button[@ng-click=\"removeDate(date, $event)\"]")).click();
                    CommonUtil.clickBtn(getDriver(), "//button[@type='submit'][@aria-label='Save Button']");
                    isRemoved = true;
                    break;
                }
            }

            Assert.assertTrue(isRemoved);
        }

    }

    @Then("^blocked dates verify remove$")
    public void verifyRemove()
    {
        if(ScenarioHelper.getInstance().getTmpId()!=null)
        {
            CommonUtil.retryIfStaleElementReferenceExceptionOccurred(() ->
            {
                boolean isFound = false;
                List<WebElement> els = getDriver().findElements(By.xpath("//md-list-item[@ng-repeat=\"date in calendarListData.dates | nvFilterByYear:year | orderBy\"]/p/span[1]"));

                for(WebElement el : els)
                {
                    if(el.getText().contains(ScenarioHelper.getInstance().getTmpId()))
                    {
                        isFound = true;
                        break;
                    }
                }

                Assert.assertFalse(isFound);
            }, "verifyRemove", getScenarioManager()::writeToScenarioLog);
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
            WebElement monthElm = getDriver().findElement(By.xpath("//md-select[@ng-model='calendar.month']/md-select-value/span/div"));
            Date date = MONTH_SDF.parse(monthElm.getText());
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            int month = cal.get(Calendar.MONTH) + 1;
            monthText = month < 10 ? "0" + month : "" + month;
        }
        catch(Exception e)
        {
        }

        return monthText;
    }
}
