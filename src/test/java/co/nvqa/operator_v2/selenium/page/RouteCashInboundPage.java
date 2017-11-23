package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.model.Zone;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.text.DecimalFormat;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteCashInboundPage extends SimplePage
{
    private static final DecimalFormat DECIMAL_FORMAT = new DecimalFormat("###,###.00");
    private static final String NG_REPEAT = "cod in $data";
    private static final String CSV_FILENAME = "zones.csv";
    private static final String XPATH_OF_TOAST_ERROR_MESSAGE = "//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()=\"Cannot read property 'filter' of null\"]";

    public static final String COLUMN_CLASS_ROUTE_ID = "route-id";
    public static final String COLUMN_CLASS_AMOUNT_COLLECTED = "amountCollected";
    public static final String COLUMN_CLASS_RECEIPT_NO = "receiptNo";

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
        waitUntilInvisibilityOfElementLocated(XPATH_OF_TOAST_ERROR_MESSAGE);
    }

    public void editCod(RouteCashInboundCod routeCashInboundCodOld, RouteCashInboundCod routeCashInboundCodEdited)
    {
        searchAndVerifyTableIsNotEmpty(routeCashInboundCodOld);
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'cod-edit')]");
        fillTheFormAndSubmit(routeCashInboundCodEdited);
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

    public void verifyCodIsUpdatedSuccessfully(RouteCashInboundCod routeCashInboundCod)
    {
        searchAndVerifyTableIsNotEmpty(routeCashInboundCod);
        verifyCodInfoIsCorrect(routeCashInboundCod);
    }

    public void verifyCodInfoIsCorrect(RouteCashInboundCod routeCashInboundCod)
    {
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_ROUTE_ID);
        Assert.assertEquals("Route Cash Inbound - COD - Route ID", String.valueOf(routeCashInboundCod.getRouteId()), actualRouteId);

        String expectedAmountCollected = "S$"+DECIMAL_FORMAT.format(routeCashInboundCod.getAmountCollected());
        String actualAmountCollected = getTextOnTable(1, COLUMN_CLASS_AMOUNT_COLLECTED);
        Assert.assertEquals("Route Cash Inbound - COD - Amount Collected", expectedAmountCollected, actualAmountCollected);

        String actualReceiptNumber = getTextOnTable(1, COLUMN_CLASS_RECEIPT_NO);
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

    public void clickButtonFetchCod()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("container.cod-list.cod-get");
    }

    public void searchAndVerifyTableIsNotEmpty(RouteCashInboundCod routeCashInboundCod)
    {
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

    public boolean isTableEmpty()
    {
        return !isElementExist(String.format("//tr[@ng-repeat='%s']", NG_REPEAT), FAST_WAIT_IN_SECONDS);
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
