package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.SalesPerson;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class SalesPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "data in getTableData()";
    private static final String SAMPLE_CSV_FILENAME = "sample-data-sales-person-upload.csv";

    public static final String COLUMN_CLASS_DATA_SALES_CODE = "code";
    public static final String COLUMN_CLASS_DATA_SALES_NAME = "name";
    public static final String COLUMN_CLASS_FILTER_SALES_CODE = "code";

    public SalesPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadSampleCsvFile()
    {
        clickNvIconTextButtonByName("container.sales-person.create-by-csv-upload");
        waitUntilVisibilityOfElementLocated("//md-dialog//h2[text()='Find Orders with CSV']");
        clickf("//a[@filename='%s']", SAMPLE_CSV_FILENAME);
    }

    public void verifySampleCsvFileDownloadedSuccessfully()
    {
        verifyFileDownloadedSuccessfully(SAMPLE_CSV_FILENAME, "NAME-A,NA\nNAME-B,NB\nNAME-C,NC");
    }

    public void uploadCsvSales(List<SalesPerson> listOfSalesPerson)
    {
        clickNvIconTextButtonByName("container.sales-person.create-by-csv-upload");
        waitUntilVisibilityOfElementLocated("//md-dialog//h2[text()='Find Orders with CSV']");

        String csvContents = listOfSalesPerson.stream().map(it -> it.getName()+","+it.getCode()).collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
        File csvFile = createFile(f("sample-data-sales-person-upload_%s.csv", generateDateUniqueString()), csvContents);

        sendKeysByAriaLabel("Choose", csvFile.getAbsolutePath());
        waitUntilVisibilityOfElementLocated(f("//h5[contains(text(), '%s')]", csvFile.getName()));
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.upload");

        waitUntilInvisibilityOfToast(f("%d of %<d Sales Person created successfully", listOfSalesPerson.size()));
    }

    public void verifySalesPersonCreatedSuccessfully(List<SalesPerson> listOfSalesPerson)
    {
        for(SalesPerson salesPerson : listOfSalesPerson)
        {
            searchTableByCode(salesPerson.getCode());
            boolean isTableEmpty = isTableEmpty();
            assertFalse("Table is empty.", isTableEmpty);
            String actualCode = getTextOnTable(1, COLUMN_CLASS_DATA_SALES_CODE);
            String actualName = getTextOnTable(1, COLUMN_CLASS_DATA_SALES_NAME);
            assertEquals("Sales Code", salesPerson.getCode(), actualCode);
            assertEquals("Sales Name", salesPerson.getName(), actualName);
        }
    }

    public void searchTableByCode(String salesPersonCode)
    {
        searchTableCustom1(COLUMN_CLASS_FILTER_SALES_CODE, salesPersonCode);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
