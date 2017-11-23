package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteCashInboundCod;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteCashInboundPage extends SimplePage
{
    private static final String NG_REPEAT = "zone in getTableData()";
    private static final String CSV_FILENAME = "zones.csv";
    private static final String XPATH_OF_TOAST_ERROR_MESSAGE = "//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-bottom']/strong[4]";

    public static final String COLUMN_CLASS_SHORT_NAME = "short_name";
    public static final String COLUMN_CLASS_NAME = "name";
    public static final String COLUMN_CLASS_HUB_NAME = "hub-name";
    public static final String COLUMN_CLASS_LAT_LONG = "lat-lng";
    public static final String COLUMN_CLASS_DESCRIPTION = "description";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    public RouteCashInboundPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void addCod(RouteCashInboundCod routeCashInboundCod)
    {
        clickNvIconTextButtonByName("Add COD");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'routeCashInboundCod-add')]");
        fillTheForm(routeCashInboundCod);
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void fillTheForm(RouteCashInboundCod routeCashInboundCod)
    {
        sendKeysById("route-id", String.valueOf(routeCashInboundCod.getRouteId()));
        sendKeysById("amount-collected", String.valueOf(routeCashInboundCod.getAmountCollected()));
        sendKeysById("receipt-number", routeCashInboundCod.getReceiptNumber());
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
