package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestConstants;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"ResultOfMethodCallIgnored", "unused"})
public class SamedayRouteEnginePage extends OperatorV2SimplePage
{
    public SamedayRouteEnginePage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectRouteGroup(String routeGroupName)
    {
        selectValueFromMdSelectById("select-route-group", routeGroupName);
    }

    public void selectRoutingAlgorithm(String routingAlgorithm)
    {
        selectValueFromMdSelectById("routing-algorithm", routingAlgorithm);
    }

    public void selectHub(String hubName)
    {
        selectValueFromMdSelectById("hub", hubName);
    }

    public void clickRunRouteEngineButton()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Run Route Engine");
    }

    public void selectFleetType1OperatingHoursStart(String operatingHoursStart)
    {
        click("//md-select[contains(@aria-label,'Operating Start')]");
        pause100ms();
        clickf("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", operatingHoursStart);
    }

    public void selectFleetType1OperatingHoursEnd(String operatingHoursTo)
    {
        click("//md-select[contains(@aria-label,'Operating End')]");
        pause100ms();
        clickf("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", operatingHoursTo);
    }

    public void selectFleetType1BreakDurationStart(String breakDurationStart)
    {
        click("//md-select[contains(@aria-label,'Break Start')]");
        pause100ms();
        clickf("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", breakDurationStart);
    }

    public void selectFleetType1BreakDurationEnd(String breakDurationEnd)
    {
        click("//md-select[contains(@aria-label,'Break End')]");
        pause100ms();
        clickf("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", breakDurationEnd);
    }

    public void selectDriverOnRouteSettingsPage(String driverName)
    {
        sendKeysByAriaLabel("Search Driver", driverName);
        pause500ms();
        clickf("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", driverName);
        pause100ms();
    }

    public void clickCreate1RoutesButton()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Create 1 Route(s)");
    }

    public void setFleetType1Capacity(String capacity)
    {
        sendKeysByAriaLabel("Capacity", capacity);
    }

    public void openWaypointDetail()
    {
        clickButtonOnTableWithNgRepeat(1, "wps", "wps", "route in ctrl.routeResponse.solution.routes");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'nv-route-detail-dialog')]");
        waitUntilVisibilityOfElementLocated("//tr[@md-virtual-repeat='wp in getTableData()']");
    }

    public void verifyWaypointDetailContent(String trackingId, String routeGroupName)
    {
        // Check the waypoint have correct tracking ID.
        String trackingIdData =  getTextOnTableWithMdVirtualRepeat(1,"tracking_id","route in ctrl.routeResponse.solution.routes" );
        Assert.assertEquals(trackingId, trackingIdData);

        String trackingIdData2= getTextOnTableWithMdVirtualRepeat(2,"tracking_id","route in ctrl.routeResponse.solution.routes" );
        Assert.assertEquals(trackingId, trackingIdData2);

        // Check the number of waypoint.
        String waypointTotal= getText("//md-dialog[contains(@class, 'nv-route-detail-dialog')]/md-dialog-content/div[1]/div[2]/p");
        Assert.assertEquals(String.valueOf(2), waypointTotal);

        // Check waypoint is pickup and delivery.
        Assert.assertEquals("PICKUP", getTextOnTableWithMdVirtualRepeat(1, "type", "route in ctrl.routeResponse.solution.routes"));
        Assert.assertEquals("DELIVERY", getTextOnTableWithMdVirtualRepeat(2, "type", "route in ctrl.routeResponse.solution.routes" ));
    }

    public void downloadCsvOnWaypointDetails(String trackingId) throws IOException
    {
        String routeName = "route-detail-"+getText("//md-dialog[contains(@class, 'nv-route-detail-dialog')]/md-dialog-content/div[1]/div[1]/p/b");

        // Clear the downloaded file first.
        File csvFile = new File(TestConstants.TEMP_DIR+"/"+routeName+".csv");

        if(csvFile.exists())
        {
            csvFile.delete();
        }

        click("//button[@aria-label='Download CSV']");

        new WebDriverWait(getWebDriver(), TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS).until((WebDriver driver)->
        {
            File csvFileDownloaded = new File(TestConstants.TEMP_DIR+"/"+routeName+".csv");
            return csvFileDownloaded.exists();
        });

        // Check the downloaded file.
        List<String> lines = Files.readAllLines(Paths.get(TestConstants.TEMP_DIR+"/"+routeName+".csv"), Charset.defaultCharset());

        lines.forEach((String str)->
        {
            String [] columnData = str.split(",");
            Assert.assertFalse("Shouldn't have break in the exported csv",columnData[1].startsWith("break"));
        });
    }

    public void openUnroutedDetailDialog()
    {
        click("//button[@aria-label='View Unrouted Waypoints']");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'nv-unrouted-detail-dialog')]");
        pause3s();
    }

    public void verifyUnroutedDetailDialog()
    {
        String unroutedCount = getText("//md-dialog[contains(@class, 'nv-unrouted-detail-dialog')]/md-dialog-content/div[1]/div[1]/p/b");
        Assert.assertEquals("1", unroutedCount);
    }

    public void changeTheSuggestedDate(String suggestedDate)
    {
        findElementByXpath("//md-datepicker[@ng-model='ctrl.suggested_date']//input").clear();
        sendKeys("//md-datepicker[@ng-model='ctrl.suggested_date']//input", suggestedDate);
    }

    public void clickUpdateTimeslotBtn()
    {
        click("//nv-api-text-button[@on-click='ctrl.onSaveSuggestedRoute()']/button");
        pause50ms();
        waitUntilInvisibilityOfElementLocated("//nv-api-text-button[@on-click='ctrl.onSaveSuggestedRoute()']//md-progress-circular");
    }

    public String getWaypointTrackingIds()
    {
        StringBuilder sb = new StringBuilder();
        int waypointTotal=Integer.valueOf(getText("//md-dialog[contains(@class, 'nv-route-detail-dialog')]/md-dialog-content/div[1]/div[2]/p"));

        for(int i=0; i<waypointTotal; i++)
        {
            String trackingId = getTextOnTableWithMdVirtualRepeat(i+1, "tracking_id","wp in getTableData()");

            if(!trackingId.equalsIgnoreCase("-"))
            {
                sb.append(trackingId);

                if(i!=waypointTotal-1)
                {
                    sb.append(",");
                }
            }
        }

        return sb.toString();
    }
}
