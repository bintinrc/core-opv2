package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.NonInboundedOrder;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.NonInboundedOrdersPage.ApplyActionsMenu.AllOrdersAction.CANCEL_ORDER;
import static co.nvqa.operator_v2.selenium.page.NonInboundedOrdersPage.ApplyActionsMenu.AllOrdersAction.DOWNLOAD_CSV_FILE;
import static co.nvqa.operator_v2.selenium.page.NonInboundedOrdersPage.OrdersTable.COLUMN_TRACKING_ID;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class NonInboundedOrdersPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_BUTTON_LOAD_SELECTION = "Load Selection";
    public static final String CSV_FILENAME_PATTERN = "non-inbounded-list";

    private OrdersTable ordersTable;
    private ApplyActionsMenu applyActionsMenu;

    public NonInboundedOrdersPage(WebDriver webDriver)
    {
        super(webDriver);
        ordersTable = new OrdersTable(webDriver);
        applyActionsMenu = new ApplyActionsMenu(webDriver);
    }

    public OrdersTable ordersTable(){
        return ordersTable;
    }

    public void filterAndLoadSelection(Date fromDate, String shipper)
    {
        waitUntilPageLoaded();
        if (fromDate != null)
        {
            setMdDatepicker("fromModel", fromDate);
        }

        if (StringUtils.isNotBlank(shipper))
        {
            selectValueFromNvAutocompleteByItemTypes("Shipper Select", shipper);
        }

        clickLoadSelectionButtonAndWaitUntilDone();
    }

    public void clickLoadSelectionButtonAndWaitUntilDone()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone(LOCATOR_BUTTON_LOAD_SELECTION);
    }

    public void filterBy(String columnName, String value){
        if (isElementExist(String.format("//*[@name='%s']", LOCATOR_BUTTON_LOAD_SELECTION), 0)){
            clickLoadSelectionButtonAndWaitUntilDone();
        }
        ordersTable.filterByColumn(columnName, value);
    }

    public void cancelOrders(List<String> trackingIds){
        ordersTable.selectEntities(COLUMN_TRACKING_ID, trackingIds);
        applyActionsMenu.chooseItem(CANCEL_ORDER);

        List<WebElement> listOfWe = findElementsByXpath("//tr[@ng-repeat='order in ctrl.orders']/td[1]");
        List<String> listOfActualTrackingIds = listOfWe.stream().map(WebElement::getText).collect(Collectors.toList());
        Assert.assertThat("Expected Tracking ID not found.", listOfActualTrackingIds, Matchers.hasItems(trackingIds.toArray(new String[]{})));

        sendKeysById("container.order.edit.cancellation-reason", String.format("This order is canceled by automation to test 'Cancel Order' feature on Non Inbounded Orders page. Canceled at %s.", CREATED_DATE_SDF.format(new Date())));

        if(listOfActualTrackingIds.size()==1)
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.cancel-order");
        }
        else
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.order.edit.cancel-orders");
        }

        waitUntilInvisibilityOfToast("updated");
    }

    public void dowloadCsvFile(List<String> trackingIds){
        ordersTable.selectEntities(COLUMN_TRACKING_ID, trackingIds);
        applyActionsMenu.chooseItem(DOWNLOAD_CSV_FILE);
    }

    public void verifyOrderDetails(String trackingId, NonInboundedOrder expectedOrderDetails){
        filterBy(COLUMN_TRACKING_ID, trackingId);
        NonInboundedOrder actualOrderDetails = ordersTable.readEntity(1);
        expectedOrderDetails.compareWithActual(actualOrderDetails);
    }

    public void verifyDownloadedCsvFileContent(List<String> trackingIds)
    {
        String fileName = getLatestDownloadedFilename(CSV_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<NonInboundedOrder> actualOrdersDetails = NonInboundedOrder.fromCsvFile(NonInboundedOrder.class, pathName, true);

        Assert.assertThat("Unexpected number of lines in CSV file", actualOrdersDetails.size(), greaterThanOrEqualTo(trackingIds.size()));

        Map<String, NonInboundedOrder> actualMap = actualOrdersDetails.stream().collect(Collectors.toMap(
                NonInboundedOrder::getTrackingId,
                params -> params
        ));

        trackingIds.forEach(trackingId -> {
            filterBy(COLUMN_TRACKING_ID, trackingId);
            NonInboundedOrder expectedOrderDetails = ordersTable.readEntity(1);
            NonInboundedOrder actualOrderDetails = actualMap.get(trackingId);
            expectedOrderDetails.compareWithActual(actualOrderDetails);
        });
    }

    /**
     * Accessor for Non Inbounded Orders table
     */
    public static class OrdersTable extends MdVirtualRepeatTable<NonInboundedOrder>
    {
        public static final String COLUMN_SHIPPER = "shipper";
        public static final String COLUMN_TRACKING_ID = "trackingId";
        public static final String COLUMN_GRANULAR_STATUS = "granularStatus";

        public OrdersTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_SHIPPER, "shipper")
                    .put(COLUMN_TRACKING_ID, "tracking-id")
                    .put(COLUMN_GRANULAR_STATUS, "granular-status")
                    .put("orderPickupDate", "order-pickup-date")
                    .put("fromAddress", "from-address")
                    .put("reservationCount", "reservation-count")
                    .put("lastSuccessReservation", "last-success-reservation")
                    .put("nextPendingReservation", "next-pending-reservation")
                    .put("orderCreateDate", "order-created-at")
                    .put("reservationAddress", "reservation-address")
                    .put("lastReservationDatetime", "last-rsvn-datetime")
                    .put("lastReservationStatus", "last-rsvn-status")
                    .put("lastReservationFailureDescription", "last-rsvn-failure-desc")
                    .put("lastReservationFailureCategory", "last-rsvn-failure-category")
                    .build()
            );
            setEntityClass(NonInboundedOrder.class);
            setMdVirtualRepeat("nonInbounded in getTableData()");
        }
    }

    /**
     * Accessor for Apply Action menu
     */
    public static class ApplyActionsMenu extends OperatorV2SimplePage
    {
        public enum AllOrdersAction
        {
            CANCEL_ORDER("Cancel Order"),
            SEND_WEBHOOK("Send Webhook"),
            DOWNLOAD_CSV_FILE("Download CSV File");

            private String name;

            public String getName()
            {
                return name;
            }

            AllOrdersAction(String name)
            {
                this.name = name;
            }
        }

        private static final String PARENT_MENU_NAME = "Apply Action";

        public ApplyActionsMenu(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void chooseItem(AllOrdersAction action)
        {
            clickMdMenuItem(PARENT_MENU_NAME, action.getName());
        }
    }

}
