package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DriverReportPage extends SimplePage
{
    public DriverReportPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void setFromDate(Date date)
    {
        setMdDatepicker("ctrl.fromDate", date);
    }

    public void setToDate(Date date)
    {
        setMdDatepicker("ctrl.toDate", date);
    }
}
