package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvLogger;
import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.text.DecimalFormat;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteCashInboundPage extends OperatorV2SimplePage
{
    private static final DecimalFormat DECIMAL_FORMAT = new DecimalFormat("###,###.00");
    private static final String NG_REPEAT = "cod in $data";
    private static final String CSV_FILENAME = "cods.csv";
    private static final String XPATH_OF_TOAST_ERROR_MESSAGE = "//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-bottom']/strong[4]";
    private static final String XPATH_OF_TOAST_ERROR_CANNOT_READ_PROPERTY = "//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()=\"Cannot read property 'filter' of null\"]";

    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "route-id";
    public static final String COLUMN_CLASS_DATA_AMOUNT_COLLECTED = "amountCollected";
    public static final String COLUMN_CLASS_DATA_RECEIPT_NO = "receiptNo";

    public static final String ACTION_BUTTON_EDIT = "Edit";
    public static final String ACTION_BUTTON_DELETE = "Delete";

    public RouteCashInboundPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void addCod(RouteCashInboundCod routeCashInboundCod)
    {
        clickNvIconTextButtonByName("Add COD");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'cod-add')]");
        fillTheFormAndSubmit(routeCashInboundCod);
        closeToastErrorDialog();
    }

    public void editCod(RouteCashInboundCod routeCashInboundCodOld, RouteCashInboundCod routeCashInboundCodEdited)
    {
        TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            searchAndVerifyTableIsNotEmpty(routeCashInboundCodOld);
            clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
            waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'cod-edit')]");
            fillTheFormAndSubmit(routeCashInboundCodEdited);

            try
            {
                WebElement toastErrorMessageWe = waitUntilVisibilityOfElementLocated(XPATH_OF_TOAST_ERROR_MESSAGE, FAST_WAIT_IN_SECONDS);
                String toastErrorMessage = toastErrorMessageWe.getText();
                NvLogger.warnf("Error when submitting COD on Route Cash Inbound page. Cause: %s", toastErrorMessage);
                closeToastErrorDialog();
                closeModal();

                /**
                 * If toast error message found, that's means updated the zone is failed.
                 * Throw runtime exception so the code will retry again until success or max retry is reached.
                 */
                throw new RuntimeException(toastErrorMessage);
            }
            catch(TimeoutException ex)
            {
                /**
                 * If TimeoutException occurred that means the toast error message is not found
                 * and that means zone is updated successfully.
                 */
                NvLogger.infof("Expected exception occurred. Cause: %s", ex.getMessage());
            }
        });
    }

    public void fillTheFormAndSubmit(RouteCashInboundCod routeCashInboundCod)
    {
        sendKeysById("route-id", String.valueOf(routeCashInboundCod.getRouteId()));
        sendKeysById("amount-collected", String.valueOf(routeCashInboundCod.getAmountCollected()));
        sendKeysById("receipt-number", routeCashInboundCod.getReceiptNumber());
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void verifyNewCodIsCreatedSuccessfully(RouteCashInboundCod routeCashInboundCod)
    {
        searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
        verifyCodInfoIsCorrect(routeCashInboundCod);
    }

    public void verifyFilterWorkFine(RouteCashInboundCod routeCashInboundCod)
    {
        searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
        verifyCodInfoIsCorrect(routeCashInboundCod);
    }

    public void verifyCodIsUpdatedSuccessfully(RouteCashInboundCod routeCashInboundCod)
    {
        searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
        verifyCodInfoIsCorrect(routeCashInboundCod);
    }

    public void verifyCodInfoIsCorrect(RouteCashInboundCod routeCashInboundCod)
    {
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_DATA_ROUTE_ID);
        Assert.assertEquals("Route Cash Inbound - COD - Route ID", String.valueOf(routeCashInboundCod.getRouteId()), actualRouteId);

        String expectedAmountCollected = "S$"+DECIMAL_FORMAT.format(routeCashInboundCod.getAmountCollected());
        String actualAmountCollected = getTextOnTable(1, COLUMN_CLASS_DATA_AMOUNT_COLLECTED);
        Assert.assertEquals("Route Cash Inbound - COD - Amount Collected", expectedAmountCollected, actualAmountCollected);

        String actualReceiptNumber = getTextOnTable(1, COLUMN_CLASS_DATA_RECEIPT_NO);
        Assert.assertEquals("Route Cash Inbound - COD - Receipt Number", routeCashInboundCod.getReceiptNumber(), actualReceiptNumber);
    }

    public void deleteCod(RouteCashInboundCod routeCashInboundCod)
    {
        searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause50ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
    }

    public void verifyCodIsDeletedSuccessfully(RouteCashInboundCod routeCashInboundCod)
    {
        clickButtonFetchCod();

        /**
         * First attempt to check after button 'Fetch COD' is clicked.
         */
        boolean isTableEmpty = isTableEmpty();

        if(!isTableEmpty)
        {
            /**
             * If the table is not empty, then filter table by receiptNo
             * and re-verify that the table is empty.
             */
            searchTable(routeCashInboundCod.getReceiptNumber());
            isTableEmpty = isTableEmpty();
        }

        Assert.assertTrue("Table should be empty.", isTableEmpty);
    }

    public void downloadCsvFile()
    {
        clickNvApiTextButtonByName("Download CSV File");
    }

    public void verifyCsvFileDownloadedSuccessfully(RouteCashInboundCod routeCashInboundCod)
    {
        verifyFileDownloadedSuccessfully(CSV_FILENAME, routeCashInboundCod.getReceiptNumber());
    }

    public void clickButtonFetchCod()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("container.cod-list.cod-get");
    }

    public void searchAndVerifyTableIsNotEmpty(RouteCashInboundCod routeCashInboundCod)
    {
        sendKeys("//md-datepicker[@md-placeholder='From Date']/div/input", MD_DATEPICKER_SDF.format(TestUtils.getNextDate(0)));
        sendKeys("//md-datepicker[@md-placeholder='To Date']/div/input", MD_DATEPICKER_SDF.format(TestUtils.getNextDate(1)));
        clickButtonFetchCod();

        /**
         * First attempt to check after button 'Fetch COD' is clicked.
         */
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue("Table should not be empty.", !isTableEmpty);

        /**
         * If the table is not empty, then filter table by receiptNo
         * and re-verify that the table is not empty.
         */
        searchTable(routeCashInboundCod.getReceiptNumber());
        isTableEmpty = isTableEmpty();
        Assert.assertTrue("Table should not be empty.", !isTableEmpty);
    }

    public void closeToastErrorDialog()
    {
        String xpathOfToastCloseButton = "//div[@id='toast-container']//button/i[@class='material-icons'][text()='close']";

        while(isElementExistFast(xpathOfToastCloseButton))
        {
            NvLogger.info("Close toast error dialog.");
            TestUtils.retryIfStaleElementReferenceExceptionOccurred(()->
            {
                try
                {
                    WebElement webElement = findElementByXpathFast(xpathOfToastCloseButton);
                    webElement.click();
                }
                catch(TimeoutException ex)
                {
                    NvLogger.warn("Close button of Toast error message dialog is disappear.");
                }
            }, "closeToastErrorDialog");
            pause30ms();
        }
    }

    public boolean isTableEmpty()
    {
        return isElementExistFast("//div[text()='None available. Add a new COD?']") || !isElementExistFast(String.format("//tr[@ng-repeat='%s']", NG_REPEAT));
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonName, NG_REPEAT);
    }
}
