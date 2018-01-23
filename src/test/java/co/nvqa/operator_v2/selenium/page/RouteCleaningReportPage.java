package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteCleaningReportPage extends SimplePage
{
    private static final String EXCEL_FILENAME_PATTERN = "route-cleaning-report";

    public RouteCleaningReportPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickButtonDownloadExcelReport()
    {
        clickNvIconTextButtonByName("container.route-cleaning-report.download-report");
    }

    public void verifyExcelFileIsDownloadedSuccessfully()
    {
        waitUntilInvisibilityOfElementLocated("//div[text()='Attempting to download route-cleaning-report.xls...']");
        waitUntilInvisibilityOfElementLocated("//div[text='Downloading route-cleaning-report.xls...']");
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(EXCEL_FILENAME_PATTERN));
    }
}
