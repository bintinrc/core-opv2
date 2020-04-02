package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Transaction;
import org.openqa.selenium.WebDriver;

/**
 * @author Latika Jamnal
 */

public class AddOrderToRoutePage extends OperatorV2SimplePage
{
    private static final String XPATH_ROUTE_ID = "//input[@aria-label='Route ID']";
    private static final String XPATH_TRANSACTION_TYPE = "//input[@aria-label='Select transaction type']";
    private static final String XPATH_TRANSACTION_TYPE_DELIVERY = "//span[text()='Delivery']/ancestor::li";
    private static final String XPATH_ADD_PREFIX = "//button[@aria-label='Add Prefix']";
    private static final String XPATH_PREFIX = "//input[@aria-label='Prefix']";
    private static final String XPATH_SAVE_BUTTON = "//button[@aria-label='Save']";
    private static final String XPATH_ENTER_TRACKING_ID = "//input[@aria-label='Tracking ID']";
    private static final String XPATH_REMOVE_PREFIX = "//button[@aria-label='Remove Prefix']";
    private static final String XPATH_LAST_SCANNED = "//p[contains(text(),'Last Scanned')]/following-sibling::h5";
    private static final String XPATH_MESSAGE = "(//div[@class='toast-message'])[1]//button/preceding-sibling::div";

    public AddOrderToRoutePage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void setRouteIdAndTransactionType(String routeId)
    {
        setRouteId(routeId);
        setTransactionType();
    }

    public void setRouteId(String routeId)
    {
        moveToElementWithXpath(XPATH_ROUTE_ID);
        pause1s();
        sendKeys(XPATH_ROUTE_ID,routeId);
    }

    public void setTransactionType()
    {
        moveToElementWithXpath(XPATH_TRANSACTION_TYPE);
        pause1s();
        click(XPATH_TRANSACTION_TYPE);
        click(XPATH_TRANSACTION_TYPE_DELIVERY);
    }

    public void addPrefix()
    {
        clickAddPrefix();
        enterPrefix();
        assertTrue("Remove Prefix button in present", isElementVisible(XPATH_REMOVE_PREFIX));
    }

    public void clickAddPrefix()
    {
        moveToElementWithXpath(XPATH_ADD_PREFIX);
        click(XPATH_ADD_PREFIX);
    }

    public void enterPrefix()
    {
        moveToElementWithXpath(XPATH_PREFIX);
        click(XPATH_PREFIX);
        sendKeys(XPATH_PREFIX,"DD");
        click(XPATH_SAVE_BUTTON);
        pause1s();
    }

    public void enterTrackingId(String trackingId)
    {
        moveToElementWithXpath(XPATH_ENTER_TRACKING_ID);
        click(XPATH_ENTER_TRACKING_ID);
        sendKeysAndEnter(XPATH_ENTER_TRACKING_ID, trackingId);
    }

    public void verifyLastScannedWithPrefix(String trackingId)
    {
        String lastScannedTrackingId = getText(XPATH_LAST_SCANNED);
        assertEquals("Last scanned tracking id is not correct: ", lastScannedTrackingId, "DD"+trackingId);
    }

    public void verifyLastScannedWithoutPrefix(String trackingId)
    {
        String lastScannedTrackingId = getText(XPATH_LAST_SCANNED);
        assertEquals("Last scanned tracking id is not correct: ", lastScannedTrackingId, trackingId);
    }

    public void verifyErrorMessage(String errorMessage)
    {
        String errorText = getText(XPATH_MESSAGE);
        assertEquals("Message is displayed: ", errorMessage, errorText);
    }

    public void verifySuccessMessage(String successMessage)
    {
        String successText = getText(XPATH_MESSAGE);
        assertEquals("Message is displayed", successText, successMessage);
    }

    public void verifyTransactionRouteDetails(Transaction transaction, Long orderId, Long routeId)
    {
        assertEquals("Order id is not the same: ", transaction.getOrderId(), orderId);
        assertEquals("Route id is not the same: ", transaction.getRouteId(), routeId);
    }
}
