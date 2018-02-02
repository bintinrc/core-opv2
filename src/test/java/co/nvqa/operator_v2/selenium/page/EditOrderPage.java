package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class EditOrderPage extends SimplePage
{
    private static final String NG_REPEAT_TABLE_EVENT = "event in getTableData()";
    public static final String COLUMN_CLASS_NAME_ON_TABLE_EVENT = "name";

    public EditOrderPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void verifyInboundIsSucceed()
    {
        String actualLatestEvent = getTextOnTableEvent(1, COLUMN_CLASS_NAME_ON_TABLE_EVENT);
        Assert.assertTrue("Different Result Returned", actualLatestEvent.contains("Van Inbound Scan"));
    }

    public void verifyOrderInfoIsCorrect(OrderRequestV2 orderRequestV2, Order order)
    {
        String expectedTrackingId = orderRequestV2.getTrackingId();

        Assert.assertEquals("Tracking ID", expectedTrackingId, getTrackingId());
        Assert.assertThat("Status", getStatus(), Matchers.equalToIgnoringCase(order.getStatus()));
        Assert.assertThat("Granular Status", getGranularStatus(), Matchers.equalToIgnoringCase(order.getGranularStatus().replaceFirst("_", " ")));
        Assert.assertThat("Shipper ID", getShipperId(), Matchers.containsString(String.valueOf(orderRequestV2.getShipperId())));
        Assert.assertEquals("Order Type", orderRequestV2.getType(), getOrderType());
        Assert.assertEquals("Size", order.getParcelSize(), getSize());
        Assert.assertEquals("Weight", order.getWeight()+" kg", getWeight());

        Transaction pickupTransaction = order.getTransactions().get(0);
        Assert.assertEquals("Pickup Status", pickupTransaction.getStatus(), getPickupStatus());

        Transaction deliveryTransaction = order.getTransactions().get(1);
        Assert.assertEquals("Delivery Status", deliveryTransaction.getStatus(), getDeliveryStatus());

        verifyPickupAndDeliveryInfo(orderRequestV2);
    }

    public void verifyOrderIsForceSuccessedSuccessfully(OrderRequestV2 orderRequestV2)
    {
        String expectedTrackingId = orderRequestV2.getTrackingId();

        Assert.assertEquals("Tracking ID", expectedTrackingId, getTrackingId());

        Assert.assertThat("Status", getStatus(), Matchers.equalToIgnoringCase("Completed"));
        Assert.assertThat("Granular Status", getGranularStatus(), Matchers.equalToIgnoringCase("Completed"));
        Assert.assertThat("Shipper ID", getShipperId(), Matchers.containsString(String.valueOf(orderRequestV2.getShipperId())));
        Assert.assertEquals("Order Type", orderRequestV2.getType(), getOrderType());
        Assert.assertThat("Latest Event", getLatestEvent(), Matchers.containsString("Order Force Successed"));

        Assert.assertEquals("Pickup Status", "SUCCESS", getPickupStatus());
        Assert.assertEquals("Delivery Status", "SUCCESS", getDeliveryStatus());

        verifyPickupAndDeliveryInfo(orderRequestV2);
    }

    public void verifyPickupAndDeliveryInfo(OrderRequestV2 orderRequestV2)
    {
        /**
         * Pickup
         */
        Assert.assertEquals("From Name", orderRequestV2.getFromName(), getFromName());
        Assert.assertEquals("From Email", orderRequestV2.getFromEmail(), getFromEmail());
        Assert.assertEquals("From Contact", orderRequestV2.getFromContact(), getFromContact());
        String fromAddress = getFromAddress();
        Assert.assertThat("From Address", fromAddress, Matchers.containsString(orderRequestV2.getFromAddress1()));
        Assert.assertThat("From Address", fromAddress, Matchers.containsString(orderRequestV2.getFromAddress2()));

        /**
         * Delivery
         */
        Assert.assertEquals("To Name", orderRequestV2.getToName(), getToName());
        Assert.assertEquals("To Email", orderRequestV2.getToEmail(), getToEmail());
        Assert.assertEquals("To Contact", orderRequestV2.getToContact(), getToContact());
        String toAddress = getToAddress();
        Assert.assertThat("To Address", toAddress, Matchers.containsString(orderRequestV2.getToAddress1()));
        Assert.assertThat("To Address", toAddress, Matchers.containsString(orderRequestV2.getToAddress2()));
    }

    public String getShipperId()
    {
        return getText("//label[text()='Shipper ID']/following-sibling::p");
    }

    public String getTrackingId()
    {
        return getText("//label[text()='Tracking ID']/following-sibling::h3");
    }

    public String getStatus()
    {
        return getText("//label[text()='Status']/following-sibling::p");
    }

    public String getGranularStatus()
    {
        return getText("//label[text()='Granular']/following-sibling::p");
    }

    public String getLatestEvent()
    {
        return getText("//label[text()='Latest Event']/following-sibling::p");
    }

    public String getOrderType()
    {
        return getText("//label[text()='Order Type']/following-sibling::p");
    }

    public String getSize()
    {
        return getText("//label[text()='Size']/following-sibling::p");
    }

    public String getWeight()
    {
        return getText("//label[text()='Weight']/following-sibling::p");
    }

    public String getPickupStatus()
    {
        return getText("//div[h5[text()='Pickup']]/following-sibling::div/h5[contains(text(), Status)]").split(":")[1].trim();
    }

    public String getFromName()
    {
        return getText("//div[@id='pickup-details']/div[2]/div/div/div/div/div/h5");
    }

    public String getFromEmail()
    {
        return getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div/span");
    }

    public String getFromContact()
    {
        return getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div[2]/span");
    }

    public String getFromAddress()
    {
        return getText("//div[@id='pickup-details']/div[2]/div/div/div[2]/div[3]/span");
    }

    public String getDeliveryStatus()
    {
        return getText("//div[h5[text()='Delivery']]/following-sibling::div/h5[contains(text(), Status)]").split(":")[1].trim();
    }

    public String getToName()
    {
        return getText("//div[@id='delivery-details']/div[2]/div/div/div/div/div/h5");
    }

    public String getToEmail()
    {
        return getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div/span");
    }

    public String getToContact()
    {
        return getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div[2]/span");
    }

    public String getToAddress()
    {
        return getText("//div[@id='delivery-details']/div[2]/div/div/div[2]/div[3]/span");
    }

    public void waitUntilInvisibilityOfLoadingOrder()
    {
        waitUntilInvisibilityOfElementLocated("//md-content[@loading-message='Loading order...']/div[contains(@class, 'loading')]");
        pause100ms();
    }

    public String getTextOnTableEvent(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT_TABLE_EVENT);
    }
}
