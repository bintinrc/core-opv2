package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.CollectionSummary;
import co.nvqa.operator_v2.model.WaypointPerformance;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteInboundPage extends OperatorV2SimplePage
{
    public RouteInboundPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void fetchRouteByRouteId(String hubName, long routeId)
    {
        selectValueFromNvAutocomplete("ctrl.hubSelection.searchText", hubName);
        sendKeysById("route-id", String.valueOf(routeId));

        String continueBtnXpath = "//md-card-content[./label[text()='Enter the route ID']]/nv-api-text-button[@name='container.route-inbound.continue']/button";
        click(continueBtnXpath);

        if(isElementExistWait5Seconds("//md-dialog/md-dialog-content/h2[text()='Driver Attendance']"))
        {
            click("//md-dialog[./md-dialog-content/h2[text()='Driver Attendance']]//button[@aria-label='Yes']");
        }

        waitUntilInvisibilityOfElementLocated(continueBtnXpath+"//md-progress-circular");
    }

    public void verifyRouteSummaryInfoIsCorrect(long expectedRouteId, String expectedDriverName, String expectedHubName, Date expectedRouteDate, WaypointPerformance expectedWaypointPerformance, CollectionSummary expectedCollectionSummary)
    {
        String actualRouteId = getText("//div[./label[text()='Route Id']]/h3/span");
        String actualDriverName = getText("//div[./label[text()='Driver']]/h3/span");
        String actualHubName = getText("//div[./label[text()='Hub']]/h3/span");
        String actualRouteDate = getText("//div[./label[text()='Date']]/h3/span");

        Assert.assertEquals("Route ID", String.valueOf(expectedRouteId), actualRouteId);
        Assert.assertEquals("Driver Name", actualDriverName.replaceAll(" ", ""), expectedDriverName.replaceAll(" ", ""));
        Assert.assertEquals("Hub Name", expectedHubName, actualHubName);
        Assert.assertEquals("Route Date", YYYY_MM_DD_SDF.format(expectedRouteDate), actualRouteDate);

        String actualWpPending = getText("//p[./parent::div/following-sibling::div[contains(text(),'Pending')]]");
        String actualWpPartial = getText("//p[./parent::div/following-sibling::div[contains(text(),'Partial')]]");
        String actualWpFailed = getText("//p[./parent::div/following-sibling::div[contains(text(),'Failed')]]");
        String actualWpCompleted = getText("//p[./parent::div/following-sibling::div[contains(text(),'Completed')]]");
        String actualWpTotal = getText("//p[./parent::div/following-sibling::div[contains(text(),'Total')]]");

        Assert.assertEquals("Waypoint Performance - Pending", expectedWaypointPerformance.getPending(), actualWpPending);
        Assert.assertEquals("Waypoint Performance - Partial", expectedWaypointPerformance.getPartial(), actualWpPartial);
        Assert.assertEquals("Waypoint Performance - Failed", expectedWaypointPerformance.getFailed(), actualWpFailed);
        Assert.assertEquals("Waypoint Performance - Completed", expectedWaypointPerformance.getCompleted(), actualWpCompleted);
        Assert.assertEquals("Waypoint Performance - Total", expectedWaypointPerformance.getTotal(), actualWpTotal);
    }
}
