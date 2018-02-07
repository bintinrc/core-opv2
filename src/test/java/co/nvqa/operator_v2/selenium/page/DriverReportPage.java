package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DriverReportPage extends OperatorV2SimplePage
{
    private static final String GENERATED_CSV_FILENAME = "driversalaries.zip";
    private static final String GENERATED_EXCEL_FILENAME_PATTERN = "DriverRouteXLReport";

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
        waitUntilInvisibilityOfToast("Attempting to download");
        waitUntilInvisibilityOfToast("Downloading");
    }

    public void verifyTheGeneratedCsvIsCorrect(String driverName, long expectedRouteId)
    {
        verifyFileDownloadedSuccessfully(GENERATED_CSV_FILENAME);

        boolean expectedRouteIdFound = false;
        String driverReportFilename = driverName+".csv";
        String generatedCsvReportFilename = TestConstants.TEMP_DIR + GENERATED_CSV_FILENAME;

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
                            String routeId = temp[1]; // Route ID is at column index 1.

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

    public void clickButtonGenerateDriverRouteExcelReport()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("container.driver-reports.generate-excel");
        waitUntilInvisibilityOfToast("Attempting to download");
        waitUntilInvisibilityOfToast("Downloading");
    }

    public void verifyTheGeneratedExcelIsCorrect(String driverName, long expectedRouteId)
    {
        String latestExcelFilename = getLatestDownloadedFilename(GENERATED_EXCEL_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(latestExcelFilename);

        boolean expectedRouteIdFound = false;
        String generatedExcelReportFilename = TestConstants.TEMP_DIR + latestExcelFilename;

        try
        {
            Workbook workbook = new HSSFWorkbook(new FileInputStream(generatedExcelReportFilename));
            Optional<Sheet> optionalSheet = StreamSupport.stream(workbook.spliterator(), false).filter((sheet->sheet.getSheetName().equals(driverName))).findFirst();

            if(optionalSheet.isPresent())
            {
                Sheet sheet = optionalSheet.get();
                int physicalNumberOfRows = sheet.getPhysicalNumberOfRows();

                /**
                 * Sheet that contains Route ID is start from row index 5.
                 */
                for(int i=5; i<physicalNumberOfRows; i++)
                {
                    Row row = sheet.getRow(i);
                    Cell cell = row.getCell(1); // Route ID is at column index 1.
                    String actualRouteId = String.valueOf((int) cell.getNumericCellValue());

                    if(String.valueOf(expectedRouteId).equals(actualRouteId))
                    {
                        expectedRouteIdFound = true;
                        break;
                    }
                }
            }
            else
            {
                String listOfSheetName = StreamSupport.stream(workbook.spliterator(), false).map(entry->entry.getSheetName()).collect(Collectors.joining("\n- ", "- ", ""));
                throw new NvTestRuntimeException(String.format("There is no Sheet with name = '%s' is found on file '%s'.\nList of Sheet name on file '%s':\n%s", driverName, generatedExcelReportFilename, generatedExcelReportFilename, listOfSheetName));
            }
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }

        String assertionErrorInfo = String.format("Sheet with name = '%s' on file = '%s' does not contain Route with ID = '%d'.", driverName, generatedExcelReportFilename, expectedRouteId);
        Assert.assertTrue(assertionErrorInfo, expectedRouteIdFound);
    }
}
