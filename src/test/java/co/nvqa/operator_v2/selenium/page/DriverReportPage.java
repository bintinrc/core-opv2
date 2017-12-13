package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DriverReportPage extends SimplePage
{
    private static final String GENERATE_CSV_FILENAME = "driversalaries.zip";

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

    public void clickButtonGenerateCsv()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("container.driver-reports.generate-csv");
        waitUntilInvisibilityOfElementLocated("//div[@id='toast-container']//div[contains(text(), 'Attempting to download')]");
        waitUntilInvisibilityOfElementLocated("//div[@id='toast-container']//div[contains(text(), 'Downloading')]");
    }

    public void verifyTheGeneratedCsvIsCorrect(String driverName, long expectedRouteId)
    {
        verifyFileDownloadedSuccessfully(GENERATE_CSV_FILENAME);

        String driverReportFilename = driverName+".csv";
        boolean expectedRouteIdFound = false;
        String generatedCsvReportFilename = TestConstants.TEMP_DIR + GENERATE_CSV_FILENAME;

        try(ZipFile zipFile = new ZipFile(generatedCsvReportFilename))
        {
            ZipEntry zipEntry = zipFile.getEntry(driverReportFilename);

            if(zipEntry!=null)
            {
                try(BufferedReader br = new BufferedReader(new InputStreamReader(zipFile.getInputStream(zipEntry))))
                {
                    String line;

                    while((line=br.readLine())!=null)
                    {
                        String[] temp = line.split(",");

                        if(temp.length>1)
                        {
                            String routeId = temp[1];

                            if(String.format("\"%d\"", expectedRouteId).equals(routeId))
                            {
                                expectedRouteIdFound = true;
                                break;
                            }
                        }
                    }
                }
            }
            else
            {
                String listOfZipEntry = zipFile.stream().map(entry->entry.getName()).collect(Collectors.joining("\n- ", "- ", ""));
                throw new NvTestRuntimeException(String.format("There is no ZipEntry with name = '%s' is found on file '%s'.\nList of ZipEntry on file '%s':\n%s", driverReportFilename, generatedCsvReportFilename, generatedCsvReportFilename, listOfZipEntry));
            }
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }

        String assertionErrorInfo = String.format("ZipEntry with name = '%s' on file = '%s' does not contain Route with ID = '%d'.", driverReportFilename, generatedCsvReportFilename, expectedRouteId);
        Assert.assertTrue(assertionErrorInfo, expectedRouteIdFound);
    }
}
