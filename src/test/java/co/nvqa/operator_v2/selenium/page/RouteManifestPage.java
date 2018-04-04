package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.route.Route;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteManifestPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "waypoint in getTableData()";
    public static final String COLUMN_STATUS = "status";
    public static final String COLUMN_COUNT_DELIVERY = "count-d";
    public static final String COLUMN_COMMENTS = "comments";

    public RouteManifestPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/following-sibling::div[text()='Loading...']");
    }

    public void verify1DeliveryIsSuccess(Route route, Order order)
    {
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
        Assert.assertEquals("Comments", "Package is defective - Damaged", actualComments);
    }

    public void searchTableByTrackingId(String trackingId)
    {
        searchTableCustom1("tracking-ids", trackingId);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }
}
