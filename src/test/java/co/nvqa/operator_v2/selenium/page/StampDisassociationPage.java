package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class StampDisassociationPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_FIELD_STAMP_ID = "stamp-id";
    public static final String LOCATOR_TEXT_ORDER_ID = "//md-card//h5";
    public static final String LOCATOR_TEXT_DELIVERY_ADDRESS = "//md-card-content/div[5]";
    public static final String LOCATOR_TEXT_LABEL = "//md-card//nv-tag/span";

    public StampDisassociationPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void enterStampId(String trackingId){
        sendKeysAndEnterById(LOCATOR_FIELD_STAMP_ID, trackingId);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading...']");
    }

    public void verifyLabelText(String expectedLabelText)
    {
        assertEquals("Label Text", expectedLabelText, getText(LOCATOR_TEXT_LABEL));
    }

    public void verifyOrderDetails(Order order)
    {
        String expectedOrderId = String.format("#%d - %s", order.getId(), order.getTrackingId());
        String actualOrderId = getText(LOCATOR_TEXT_ORDER_ID);
        assertEquals("Order ID", expectedOrderId, actualOrderId);

        String actualDeliveryAddress = StringUtils.normalizeSpace(getText(LOCATOR_TEXT_DELIVERY_ADDRESS));
        assertEquals("Delivery Address", order.buildCompleteToAddress(), actualDeliveryAddress);
    }
}
