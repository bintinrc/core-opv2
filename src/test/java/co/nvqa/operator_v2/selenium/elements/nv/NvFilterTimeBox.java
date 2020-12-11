package co.nvqa.operator_v2.selenium.elements.nv;

import co.nvqa.operator_v2.selenium.elements.md.MdDatepicker;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.Date;

public class NvFilterTimeBox extends AbstractFilterBox
{
    public NvFilterTimeBox(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
    }

    @FindBy(xpath = "(.//md-datepicker)[1]")
    public MdDatepicker fromDate;

    @FindBy(xpath = "(.//md-datepicker)[2]")
    public MdDatepicker toDate;

    @FindBy(css = "md-input-container[model='container.fromHour'] md-select")
    public MdSelect fromHours;

    @FindBy(css = "md-input-container[model='container.fromMinute'] md-select")
    public MdSelect fromMinutes;

    @FindBy(css = "md-input-container[model='container.toHour'] md-select")
    public MdSelect toHours;

    @FindBy(css = "md-input-container[model='container.toMinute'] md-select")
    public MdSelect toMinutes;

    public void selectFromDate(String value)
    {
        fromDate.simpleSetValue(value);
    }

    public void selectFromHours(String value)
    {
        fromHours.searchAndSelectValue(value);
    }

    public void selectFromMinutes(String value)
    {
        fromMinutes.searchAndSelectValue(value);
    }

    public void selectToHours(String value)
    {
        toHours.searchAndSelectValue(value);
    }

    public void selectToMinutes(String value)
    {
        toMinutes.searchAndSelectValue(value);
    }

    public void selectFromDate(Date value)
    {
        fromDate.setDate(value);
    }

    public void selectToDate(String value)
    {
        toDate.simpleSetValue(value);
    }

    public void selectToDate(Date value)
    {
        toDate.setDate(value);
    }

    public void selectDates(String fromDate, String toDate)
    {
        selectFromDate(fromDate);
        selectToDate(toDate);
    }

    public void selectDates(Date fromDate, Date toDate)
    {
        selectFromDate(fromDate);
        selectToDate(toDate);
    }

    @Override
    void setValue(String... values)
    {
        selectDates(values[0], values[1]);
    }
}