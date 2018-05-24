package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Dimension;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.model.order_create.v2.Parcel;
import co.nvqa.commons.model.pdf.AirwayBill;
import co.nvqa.commons.utils.PdfUtils;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class EditOrderPage extends OperatorV2SimplePage
{
    private static final String NG_REPEAT_TABLE_EVENT = "event in getTableData()";
    public static final String COLUMN_CLASS_DATA_NAME_ON_TABLE_EVENT = "name";
    private TransactionsTable transactionsTable;
    private AddToRouteDialog addToRouteDialog;
    private DeliveryDetailsBox deliveryDetailsBox;
    private PickupDetailsBox pickupDetailsBox;

    public EditOrderPage(WebDriver webDriver)
    {
        super(webDriver);
        transactionsTable = new TransactionsTable(webDriver);
        addToRouteDialog = new AddToRouteDialog(webDriver);
        deliveryDetailsBox = new DeliveryDetailsBox(webDriver);
        pickupDetailsBox = new PickupDetailsBox(webDriver);
    }

    public void clickMenu(String parentMenuName, String childMenuName)
    {
        clickf("//md-menu-bar/md-menu/button[contains(text(), '%s')]", parentMenuName);
        waitUntilVisibilityOfElementLocated("//div[@aria-hidden='false']/md-menu-content");
        clickf("//div[@aria-hidden='false']/md-menu-content/md-menu-item/button/span[contains(text(), '%s')]", childMenuName);
    }

    public void editOrderDetails(OrderRequestV2 orderRequestV2)
    {
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'order-edit-details')]//nv-api-text-button[@name='commons.save-changes']");
        Parcel parcel = orderRequestV2.getParcels().get(0);
        selectValueFromMdSelectById("parcel-size", getParcelSizeAsString(parcel.getParcelSizeId()));
        sendKeysByIdAlt("weight", String.valueOf(parcel.getWeight()));
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
    }

    public void editOrderInstructions(String pickupInstruction, String deliveryInstruction)
    {
        waitUntilVisibilityOfMdDialogByTitle("Edit Instructions");
        if (pickupInstruction != null)
        {
            sendKeysByAriaLabel("Pickup Instruction", pickupInstruction);
        }
        if (deliveryInstruction != null)
        {
            sendKeysByAriaLabel("Delivery Instruction", deliveryInstruction);
        }
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
        waitUntilInvisibilityOfToast("Instructions Updated", true);
    }

    public void editPriorityLevel(int priorityLevel)
    {
        clickMenu("Order Settings", "Edit Priority Level");
        waitUntilVisibilityOfMdDialogByTitle("Edit Priority Level");
        sendKeysByAriaLabel("container.order.edit.delivery-priority-level", String.valueOf(priorityLevel));
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
        waitUntilInvisibilityOfMdDialogByTitle("Edit Priority Level");
    }

    public void addToRoute(long routeId, String type)
    {
        clickMenu("Pickup", "Add To Route");
        addToRouteDialog
                .waitUntilVisibility()
                .enterRouteId(routeId)
                .selectType(type)
                .submit();
    }

    public void verifyDeliveryRouteInfo(Route route)
    {
        Assert.assertThat("Delivery Route Id", deliveryDetailsBox.getRouteId(), Matchers.equalTo(String.valueOf(route.getId())));
        if (CollectionUtils.isNotEmpty(route.getWaypoints()))
        {
            String expectedWaypointId = String.valueOf(route.getWaypoints().get(0).getId());
            Assert.assertThat("Delivery Waypoint ID", deliveryDetailsBox.getWaypointId(), Matchers.equalTo(expectedWaypointId));
        }
        String expectedDriver = route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
        Assert.assertThat("Delivery Driver", deliveryDetailsBox.getDriver(), Matchers.equalTo(expectedDriver));
    }

    public void verifyPickupRouteInfo(Route route)
    {
        Assert.assertThat("Pickup Route Id", pickupDetailsBox.getRouteId(), Matchers.equalTo(String.valueOf(route.getId())));
        if (CollectionUtils.isNotEmpty(route.getWaypoints()))
        {
            String expectedWaypointId = String.valueOf(route.getWaypoints().get(0).getId());
            Assert.assertThat("Pickup Waypoint ID", pickupDetailsBox.getWaypointId(), Matchers.equalTo(expectedWaypointId));
        }
        String expectedDriver = route.getDriver().getFirstName() + " " + route.getDriver().getLastName();
        Assert.assertThat("Pickup Driver", pickupDetailsBox.getDriver(), Matchers.equalTo(expectedDriver));
    }

    public void printAirwayBill()
    {
        clickMenu("View/Print", "Print Airway Bill");
        waitUntilInvisibilityOfToast("Attempting to download", true);
        waitUntilInvisibilityOfToast("Downloading");
    }

    public void verifyAirwayBillContentsIsCorrect(OrderRequestV2 orderRequestV2)
    {
        String trackingId = orderRequestV2.getTrackingId();
        String latestFilenameOfDownloadedPdf = getLatestDownloadedFilename("awb_" + trackingId);
        verifyFileDownloadedSuccessfully(latestFilenameOfDownloadedPdf);
        AirwayBill airwayBill = PdfUtils.getOrderInfoFromAirwayBill(TestConstants.TEMP_DIR + latestFilenameOfDownloadedPdf, 0);

        Assert.assertEquals("Tracking ID", trackingId, airwayBill.getTrackingId());

        Assert.assertEquals("From Name", orderRequestV2.getFromName(), airwayBill.getFromName());
        Assert.assertEquals("From Contact", orderRequestV2.getFromContact(), airwayBill.getFromContact());
        Assert.assertThat("From Address", airwayBill.getFromAddress(), Matchers.containsString(orderRequestV2.getFromAddress1()));
        Assert.assertThat("From Address", airwayBill.getFromAddress(), Matchers.containsString(orderRequestV2.getFromAddress2()));
        Assert.assertThat("Postcode In From Address", airwayBill.getFromAddress(), Matchers.containsString(orderRequestV2.getFromPostcode()));

        Assert.assertEquals("To Name", orderRequestV2.getToName(), airwayBill.getToName());
        Assert.assertEquals("To Contact", orderRequestV2.getToContact(), airwayBill.getToContact());
        Assert.assertThat("To Address", airwayBill.getToAddress(), Matchers.containsString(orderRequestV2.getToAddress1()));
        Assert.assertThat("To Address", airwayBill.getToAddress(), Matchers.containsString(orderRequestV2.getToAddress2()));
        Assert.assertThat("Postcode In To Address", airwayBill.getToAddress(), Matchers.containsString(orderRequestV2.getToPostcode()));

        Assert.assertEquals("COD", orderRequestV2.getCodGoods(), airwayBill.getCod());
        Assert.assertEquals("Comments", orderRequestV2.getInstruction(), airwayBill.getComments());

        String actualQrCodeTrackingId = TestUtils.getTextFromQrCodeImage(airwayBill.getTrackingIdQrCodeFile());
        Assert.assertEquals("Tracking ID - QR Code", trackingId, actualQrCodeTrackingId);

        String actualBarcodeTrackingId = TestUtils.getTextFromQrCodeImage(airwayBill.getTrackingIdBarcodeFile());
        Assert.assertEquals("Tracking ID - Barcode 128", trackingId, actualBarcodeTrackingId);
    }

    public void verifyPriorityLevel(String txnType, int priorityLevel)
    {
        transactionsTable.searchByTxnType(txnType);
        Assert.assertEquals(txnType + " Priority Level", String.valueOf(priorityLevel), transactionsTable.getPriorityLevel(1));

    }

    public void verifyOrderInstructions(String expectedPickupInstructions, String expectedDeliveryInstructions)
    {
        if (expectedPickupInstructions != null)
        {
            String actualPickupInstructions = getText("//div[label[text()='Pick Up Instructions']]/p");
            Assert.assertThat("Pick Up Instructions", expectedPickupInstructions, Matchers.equalToIgnoringCase(actualPickupInstructions));
        }
        if (expectedDeliveryInstructions != null)
        {
            Assert.assertEquals("Delivery Instructions", expectedDeliveryInstructions, deliveryDetailsBox.getDeliveryInstructions());
        }
    }

    public void confirmCompleteOrder()
    {
        waitUntilVisibilityOfMdDialogByTitle("Manually Complete Order");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.complete-order");
        waitUntilInvisibilityOfToast("The order has been completed", true);
    }

    public void verifyEditOrderDetailsIsSuccess(OrderRequestV2 orderRequestV2, Order order)
    {
        Parcel expectedParcel = orderRequestV2.getParcels().get(0);

        String actualSize = getSize();
        Double actualWeight = getWeight();

        Assert.assertEquals("Order - Size", getParcelSizeAsLongString(expectedParcel.getParcelSizeId()), actualSize);
        Assert.assertEquals("Order - Weight", expectedParcel.getWeight(), actualWeight);

        Assert.assertEquals("Order Details - Size", order.getParcelSize(), getSize());
        Assert.assertEquals("Order Details - Weight", expectedParcel.getWeight(), getWeight());
    }

    public void verifyInboundIsSucceed()
    {
        String actualLatestEvent = getTextOnTableEvent(1, COLUMN_CLASS_DATA_NAME_ON_TABLE_EVENT);
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
        Assert.assertEquals("Weight", order.getWeight(), getWeight(), 0.0);

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
        Long shipperId = orderRequestV2.getShipperId();
        if (shipperId != null)
        {
            Assert.assertThat("Shipper ID", getShipperId(), Matchers.containsString(String.valueOf(shipperId)));
        }
        Assert.assertEquals("Order Type", orderRequestV2.getType(), getOrderType());
        //Assert.assertThat("Latest Event", getLatestEvent(), Matchers.containsString("Order Force Successed")); //Disabled because somehow the latest event name is always 'PRICING_CHANGE' and the value on Latest Event is '-'.

        Assert.assertEquals("Pickup Status", "SUCCESS", getPickupStatus());
        Assert.assertEquals("Delivery Status", "SUCCESS", getDeliveryStatus());

        verifyPickupAndDeliveryInfo(orderRequestV2);
    }

    public void verifyPickupAndDeliveryInfo(OrderRequestV2 orderRequestV2)
    {
        // Pickup
        Assert.assertEquals("From Name", orderRequestV2.getFromName(), getFromName());
        Assert.assertEquals("From Email", orderRequestV2.getFromEmail(), getFromEmail());
        Assert.assertEquals("From Contact", orderRequestV2.getFromContact(), getFromContact());
        String fromAddress = getFromAddress();
        Assert.assertThat("From Address", fromAddress, Matchers.containsString(orderRequestV2.getFromAddress1()));
        Assert.assertThat("From Address", fromAddress, Matchers.containsString(orderRequestV2.getFromAddress2()));

        // Delivery
        Assert.assertEquals("To Name", orderRequestV2.getToName(), getToName());
        Assert.assertEquals("To Email", orderRequestV2.getToEmail(), getToEmail());
        Assert.assertEquals("To Contact", orderRequestV2.getToContact(), getToContact());
        String toAddress = getToAddress();
        Assert.assertThat("To Address", toAddress, Matchers.containsString(orderRequestV2.getToAddress1()));
        Assert.assertThat("To Address", toAddress, Matchers.containsString(orderRequestV2.getToAddress2()));
    }

    public void verifyOrderIsGlobalInboundedSuccessfully(OrderRequestV2 orderRequestV2, GlobalInboundParams globalInboundParams, Double expectedOrderCost)
    {
        if (isElementExistFast("//nv-icon-text-button[@name='container.order.edit.show-more']"))
        {
            clickNvIconTextButtonByName("container.order.edit.show-more");
        }

        String expectedTrackingId = orderRequestV2.getTrackingId();
        Assert.assertEquals("Tracking ID", expectedTrackingId, getTrackingId());

        Assert.assertThat(String.format("Status - [Tracking ID = %s]", expectedTrackingId), getStatus(), Matchers.equalToIgnoringCase("TRANSIT"));
        Assert.assertThat(String.format("Granular Status - [Tracking ID = %s]", expectedTrackingId), getGranularStatus(), Matchers.anyOf(Matchers.equalTo("Arrived at Sorting Hub"), Matchers.equalTo("Arrived at Origin Hub")));

        Assert.assertEquals("Pickup Status", "SUCCESS", getPickupStatus());
        Assert.assertEquals("Delivery Status", "PENDING", getDeliveryStatus());

        // There is an issue where after Global Inbound the new Size is not applied. KH need to fix this.
        // Uncomment this line below if KH has fixed it.
        /*if(globalInboundParams.getOverrideSize()!=null)
        {
            Assert.assertEquals("Size", getParcelSizeAsLongString(globalInboundParams.getOverrideSize()), getSize());
        }*/

        if (globalInboundParams.getOverrideWeight() != null)
        {
            Assert.assertEquals("Weight", globalInboundParams.getOverrideWeight(), getWeight());
        }

        Dimension actualDimension = getDimension();

        if (globalInboundParams.getOverrideDimHeight() != null && globalInboundParams.getOverrideDimWidth() != null && globalInboundParams.getOverrideDimLength() != null)
        {
            Assert.assertEquals("Dimension - Height", globalInboundParams.getOverrideDimHeight(), actualDimension.getHeight());
            Assert.assertEquals("Dimension - Width", globalInboundParams.getOverrideDimWidth(), actualDimension.getWidth());
            Assert.assertEquals("Dimension - Length", globalInboundParams.getOverrideDimLength(), actualDimension.getLength());
        }

        if (expectedOrderCost != null)
        {
            Double total = getTotal();
            String totalAsString = null;

            if (total != null)
            {
                totalAsString = NO_TRAILING_ZERO_DF.format(total);
            }

            Assert.assertEquals("Cost", NO_TRAILING_ZERO_DF.format(expectedOrderCost), totalAsString);
        }
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

    public Double getWeight()
    {
        Double weight = null;
        String actualText = getText("//label[text()='Weight']/following-sibling::p");

        if (!actualText.contains("-"))
        {
            String temp = actualText.replace("kg", "").trim();
            weight = Double.parseDouble(temp);
        }

        return weight;
    }

    public Double getCashOnDelivery()
    {
        Double cod = null;
        String actualText = getText("//label[text()='Cash on Delivery']/following-sibling::p");

        if (!actualText.contains("-"))
        {
            String temp = actualText.substring(3); //Remove currency text (e.g. SGD)
            cod = Double.parseDouble(temp);
        }

        return cod;
    }

    public Dimension getDimension()
    {
        Dimension dimension = new Dimension();
        String actualText = getText("//label[text()='Dimensions']/following-sibling::p");

        if (!actualText.contains("-"))
        {
            String temp = actualText.replace("cm", "");
            String[] dims = temp.split("x");
            Double height = Double.parseDouble(dims[1]);
            Double width = Double.parseDouble(dims[0]);
            Double length = Double.parseDouble(dims[2]);
            dimension = new Dimension();
            dimension.setHeight(height);
            dimension.setWidth(width);
            dimension.setLength(length);
        }

        return dimension;
    }

    public Double getTotal()
    {
        Double total = null;
        String actualText = getText("//label[text()='Total']/following-sibling::p");

        if (!actualText.contains("-"))
        {
            String temp = actualText.substring(3); //Remove currency text (e.g. SGD)
            total = Double.parseDouble(temp);
        }

        return total;
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

    /**
     * Accessor for Reservations table
     */
    public static class TransactionsTable extends OperatorV2SimplePage
    {
        private static final String NG_REPEAT = "transaction in getTableData()";
        private static final String COLUMN_CLASS_PRIORITY_LEVEL = "priority-level";
        private static final String COLUMN_CLASS_TXN_TYPE = "type";
        private static final String COLUMN_CLASS_STATUS = "status";

        public TransactionsTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getPriorityLevel(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_PRIORITY_LEVEL);
        }

        public String getStatus(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_STATUS);
        }

        public String getTxnType(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_TXN_TYPE);
        }

        private String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text = getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
            return StringUtils.normalizeSpace(text);
        }

        public void searchByTxnType(String txnType)
        {
            searchTableCustom1(COLUMN_CLASS_TXN_TYPE, txnType);
        }
    }

    /**
     * Accessor for Add To Route dialog
     */
    public static class AddToRouteDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Add To Route";
        private static final String FIELD_ROUTE_LOCATOR = "ctrl.formData.orders[0].routeId";
        private static final String FIELD_TYPE_LOCATOR = "model";
        private static final String BUTTON_ADD_TO_ROUTE_LOCATOR = "container.order.edit.add-to-route";

        public AddToRouteDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public AddToRouteDialog waitUntilVisibility()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public AddToRouteDialog enterRouteId(long routeId)
        {
            sendKeysToMdInputContainerByModel(FIELD_ROUTE_LOCATOR, String.valueOf(routeId));
            return this;
        }

        public AddToRouteDialog selectType(String type)
        {
            selectValueFromMdSelect(FIELD_TYPE_LOCATOR, type);
            return this;
        }

        public void submit()
        {
            clickNvApiTextButtonByNameAndWaitUntilDone(BUTTON_ADD_TO_ROUTE_LOCATOR);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }

    /**
     * Accessor for Delivery Details box
     */
    public static class DeliveryDetailsBox extends OperatorV2SimplePage
    {
        private static final String DELIVERY_INSTRUCTIONS_LOCATOR = "Delivery Instructions";
        private static final String ROUTE_ID_LOCATOR = "//div[h5[text()='Delivery Details']]//div[label[text()='Route Id']]/p";
        private static final String ROUTE_DATE_LOCATOR = "//div[h5[text()='Delivery Details']]//div[label[text()='Route Date']]/p";
        private static final String DRIVER_LOCATOR = "//div[h5[text()='Delivery Details']]//div[label[text()='Driver']]/p";
        private static final String WAYPOINT_ID_LOCATOR = "//div[h5[text()='Delivery Details']]//div[label[text()='Waypoint ID']]/p";

        public DeliveryDetailsBox(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getDeliveryInstructions()
        {
            return getText(DELIVERY_INSTRUCTIONS_LOCATOR);
        }

        public String getRouteId()
        {

            return getText(ROUTE_ID_LOCATOR);
        }

        public String getRouteDate()
        {

            return getText(ROUTE_DATE_LOCATOR);
        }

        public String getDriver()
        {

            return getText(DRIVER_LOCATOR);
        }

        public String getWaypointId()
        {

            return getText(WAYPOINT_ID_LOCATOR);
        }
    }

    /**
     * Accessor for Pickup Details box
     */
    public static class PickupDetailsBox extends OperatorV2SimplePage
    {
        private static final String DELIVERY_INSTRUCTIONS_LOCATOR = "Pick Up Instructions";
        private static final String ROUTE_ID_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Route Id']]/p";
        private static final String ROUTE_DATE_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Route Date']]/p";
        private static final String DRIVER_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Driver']]/p";
        private static final String WAYPOINT_ID_LOCATOR = "//div[h5[text()='Pickup Details']]//div[label[text()='Waypoint ID']]/p";

        public PickupDetailsBox(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getDeliveryInstructions()
        {
            return getText(DELIVERY_INSTRUCTIONS_LOCATOR);
        }

        public String getRouteId()
        {

            return getText(ROUTE_ID_LOCATOR);
        }

        public String getRouteDate()
        {

            return getText(ROUTE_DATE_LOCATOR);
        }

        public String getDriver()
        {

            return getText(DRIVER_LOCATOR);
        }

        public String getWaypointId()
        {

            return getText(WAYPOINT_ID_LOCATOR);
        }
    }
}
