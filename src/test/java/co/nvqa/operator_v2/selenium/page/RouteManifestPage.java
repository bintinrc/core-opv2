package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.factory.FailureReason;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import co.nvqa.operator_v2.model.RouteManifestWaypointDetails;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RouteManifestPage extends OperatorV2SimplePage
{
    public static final String COLUMN_STATUS = "status";
    public static final String COLUMN_COUNT_DELIVERY = "count-d";
    public static final String COLUMN_COMMENTS = "comments";
    public static final String ACTION_BUTTON_EDIT = "container.route-manifest.choose-outcome-for-waypoint";
    private static final String MD_VIRTUAL_REPEAT = "waypoint in getTableData()";
    private WaypointDetailsDialog waypointDetailsDialog;
    private WaypointsTable waypointsTable;

    public RouteManifestPage(WebDriver webDriver)
    {
        super(webDriver);
        waypointDetailsDialog = new WaypointDetailsDialog(webDriver);
        waypointsTable = new WaypointsTable(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading...']");
    }

    public void verify1DeliverySuccessAtRouteManifest(Route route, Order order)
    {
        verify1DeliverySuccessOrFailAtRouteManifest(route, order, true);
    }

    public void verify1DeliveryFailAtRouteManifest(Route route, Order order)
    {
        verify1DeliverySuccessOrFailAtRouteManifest(route, order, false);
    }

    private void verify1DeliverySuccessOrFailAtRouteManifest(Route route, Order order, boolean verifyDeliverySuccess)
    {
        if (verifyDeliverySuccess)
        {
            verify1DeliveryIsSuccess(route, order);
        } else
        {
            verify1DeliveryIsFailed(route, order);
        }
    }

    public void verify1DeliveryIsSuccess(Route route, Order order)
    {
        waitUntilPageLoaded();

        String actualRouteId = getText("//div[contains(@class,'route-detail')]/div[text()='Route ID']/following-sibling::div");
        String actualWaypointSuccessCount = getText("//div[text()='Waypoint Type']/following-sibling::table//td[contains(@ng-class, 'column.Success.value')]");
        Assert.assertEquals("Route ID", String.valueOf(route.getId()), actualRouteId);
        Assert.assertEquals("Waypoint Success Count", "1", actualWaypointSuccessCount);

        searchTableByTrackingId(order.getTrackingId());
        Assert.assertFalse(String.format("Order with Tracking ID = '%s' not found on table.", order.getTrackingId()), isTableEmpty());

        String actualStatus = getTextOnTable(1, COLUMN_STATUS);
        String actualCountDelivery = getTextOnTable(1, COLUMN_COUNT_DELIVERY);
        Assert.assertEquals("Status", "Success", actualStatus);
        Assert.assertEquals("Count Delivery", "1", actualCountDelivery);
    }

    public void verify1DeliveryIsFailed(Route route, Order order)
    {
        waitUntilPageLoaded();

        String actualRouteId = getText("//div[contains(@class,'route-detail')]/div[text()='Route ID']/following-sibling::div");
        String actualWaypointSuccessCount = getText("//div[text()='Waypoint Type']/following-sibling::table//td[contains(@ng-class, 'column.Fail.value')]");
        Assert.assertEquals("Route ID", String.valueOf(route.getId()), actualRouteId);
        Assert.assertEquals("Waypoint Failed Count", "1", actualWaypointSuccessCount);

        searchTableByTrackingId(order.getTrackingId());
        Assert.assertFalse(String.format("Order with Tracking ID = '%s' not found on table.", order.getTrackingId()), isTableEmpty());

        String actualStatus = getTextOnTable(1, COLUMN_STATUS);
        String actualCountDelivery = getTextOnTable(1, COLUMN_COUNT_DELIVERY);
        String actualComments = getTextOnTable(1, COLUMN_COMMENTS);
        Assert.assertEquals("Status", "Fail", actualStatus);
        Assert.assertEquals("Count Delivery", "1", actualCountDelivery);
        Assert.assertEquals("Comments", TestConstants.DRIVER_DELIVERY_FAIL_STRING, actualComments);
    }

    public void verifyWaypointDetails(RouteManifestWaypointDetails expectedWaypointDetails)
    {
        RouteManifestWaypointDetails.Reservation expectedReservation = expectedWaypointDetails.getReservation();
        RouteManifestWaypointDetails.Pickup expectedPickup = expectedWaypointDetails.getPickup();
        RouteManifestWaypointDetails.Delivery expectedDelivery = expectedWaypointDetails.getDelivery();
        expectedWaypointDetails.setReservation(null);
        expectedWaypointDetails.setPickup(null);
        expectedWaypointDetails.setDelivery(null);

        waitUntilPageLoaded();
        if (StringUtils.isNotBlank(expectedWaypointDetails.getTrackingIds()))
        {
            waypointsTable.filterByColumn("trackingIds", String.valueOf(expectedWaypointDetails.getTrackingIds()));
        } else if (expectedWaypointDetails.getId() != null)
        {
            waypointsTable.filterByColumn("id", String.valueOf(expectedWaypointDetails.getId()));
        } else if (StringUtils.isNotBlank(expectedWaypointDetails.getAddress()))
        {
            waypointsTable.filterByColumn("address", String.valueOf(expectedWaypointDetails.getAddress()));
        }
        RouteManifestWaypointDetails actualWaypointDetails = waypointsTable.readEntity(1);
        expectedWaypointDetails.compareWithActual(actualWaypointDetails);
        if (expectedReservation != null || expectedPickup != null || expectedDelivery != null)
        {
            waypointsTable.clickActionButton(1, "details");
            waypointDetailsDialog.waitUntilVisible();
            if (expectedReservation != null)
            {
                RouteManifestWaypointDetails.Reservation actualReservation = waypointDetailsDialog.reservationsTable.readEntity(1);
                expectedReservation.compareWithActual(actualReservation);
            }
            if (expectedPickup != null)
            {
                RouteManifestWaypointDetails.Pickup actualPickup = waypointDetailsDialog.pickupsTable.readEntity(1);
                expectedPickup.compareWithActual(actualPickup);
            }
            if (expectedDelivery != null)
            {
                RouteManifestWaypointDetails.Delivery actualDelivery = waypointDetailsDialog.deliveryTable.readEntity(1);
                expectedDelivery.compareWithActual(actualDelivery);
            }
        }
    }

    public void failDeliveryWaypoint(FailureReason failureReason)
    {
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        clickButtonOnMdDialogByAriaLabel("Failure");
        selectValueFromMdSelectById("container.route-manifest.choose-failure-reason", failureReason.getParent().getName());
        selectValueFromMdSelectById("container.route-manifest.failure-reason-detail", failureReason.getName());
        clickButtonOnMdDialogByAriaLabel("Update");
        clickButtonOnMdDialogByAriaLabel("Proceed");
        pause2s();
    }

    public void successDeliveryWaypoint()
    {
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        clickButtonOnMdDialogByAriaLabel("Success");
        clickButtonOnMdDialogByAriaLabel("Update");
        clickButtonOnMdDialogByAriaLabel("Proceed");
        pause2s();
    }

    public void searchTableByTrackingId(String trackingId)
    {
        searchTableCustom1("tracking-ids", trackingId);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }

    /**
     * Accessor for Waypoint Details dialog
     */
    public static class WaypointDetailsDialog extends OperatorV2SimplePage
    {
        public static final String DIALOG_TITLE = "Waypoint Details";
        public ReservationsTable reservationsTable;
        public PickupsTable pickupsTable;
        public DeliveryTable deliveryTable;

        public WaypointDetailsDialog(WebDriver webDriver)
        {
            super(webDriver);
            reservationsTable = new ReservationsTable(webDriver);
            pickupsTable = new PickupsTable(webDriver);
            deliveryTable = new DeliveryTable(webDriver);
        }

        public WaypointDetailsDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public static class ReservationsTable extends NgRepeatTable<RouteManifestWaypointDetails.Reservation>
        {
            public ReservationsTable(WebDriver webDriver)
            {
                super(webDriver);
                setColumnLocators(ImmutableMap.of(
                        "id", "/td[2]",
                        "status", "/td[3]",
                        "failureReason", "/td[6]"
                ));
                setNgRepeat("reservation in fields.reservations track by $index");
                setEntityClass(RouteManifestWaypointDetails.Reservation.class);
            }
        }

        public static class PickupsTable extends NgRepeatTable<RouteManifestWaypointDetails.Pickup>
        {
            public PickupsTable(WebDriver webDriver)
            {
                super(webDriver);
                setColumnLocators(ImmutableMap.of(
                        "trackingId", "/td[2]",
                        "status", "/td[3]",
                        "failureReason", "/td[4]"
                ));
                setNgRepeat("pickup in fields.pickups track by $index");
                setEntityClass(RouteManifestWaypointDetails.Pickup.class);
            }
        }

        public static class DeliveryTable extends NgRepeatTable<RouteManifestWaypointDetails.Delivery>
        {
            public DeliveryTable(WebDriver webDriver)
            {
                super(webDriver);
                setColumnLocators(ImmutableMap.of(
                        "trackingId", "/td[2]",
                        "status", "/td[3]",
                        "failureReason", "/td[5]"
                ));
                setNgRepeat("delivery in fields.deliveries track by $index");
                setEntityClass(RouteManifestWaypointDetails.Delivery.class);
            }
        }
    }

    public static class WaypointsTable extends MdVirtualRepeatTable<RouteManifestWaypointDetails>
    {
        public WaypointsTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("address", "address")
                    .put("status", "status")
                    .put("id", "id")
                    .put("deliveriesCount", "count-d")
                    .put("pickupsCount", "count-p")
                    .put("comments", "comments")
                    .put("trackingIds", "tracking-ids")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of("details", "Waypoint Details", "edit", "container.route-manifest.choose-outcome-for-waypoint"));
            setMdVirtualRepeat("waypoint in getTableData()");
            setEntityClass(RouteManifestWaypointDetails.class);
        }
    }
}
