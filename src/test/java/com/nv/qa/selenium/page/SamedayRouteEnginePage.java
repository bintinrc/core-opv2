package com.nv.qa.selenium.page;


import com.google.inject.Inject;
import com.nv.qa.support.TestConstants;
import com.nv.qa.support.ScenarioStorage;
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
public class SamedayRouteEnginePage extends SimplePage
{
    private static final int SAVE_BUTTON_LOADING_TIMEOUT_IN_SECONDS = 30;
    private static final int WAIT_TIMEOUT = 30;
    @Inject
    private ScenarioStorage scenarioStorage;


    public SamedayRouteEnginePage(WebDriver driver)
    {
        super(driver);
    }

    public void selectRouteGroup(String routeGroupName)
    {
        click("//md-select[@aria-label='Select Route Group']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routeGroupName));
    }

    public void selectRoutingAlgorithm(String routingAlgorithm)
    {
        click("//md-select[@aria-label='Routing Algorithm']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routingAlgorithm));
    }

    public void selectHub(String hubName)
    {
        click("//md-select[@aria-label='Hub']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", hubName));
    }

    public void clickRunRouteEngineButton()
    {
        click("//button[@aria-label='Run Route Engine']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Run Route Engine']//md-progress-circular", SAVE_BUTTON_LOADING_TIMEOUT_IN_SECONDS);
    }

    public void selectFleetType1OperatingHoursStart(String operatingHoursStart)
    {
        click("//md-select[contains(@aria-label,'Operating Start')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", operatingHoursStart));
    }

    public void selectFleetType1OperatingHoursEnd(String operatingHoursTo)
    {
        click("//md-select[contains(@aria-label,'Operating End')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", operatingHoursTo));
    }

    public void selectFleetType1BreakDurationStart(String breakDurationStart)
    {
        click("//md-select[contains(@aria-label,'Break Start')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", breakDurationStart));
    }

    public void selectFleetType1BreakDurationEnd(String breakDurationEnd)
    {
        click("//md-select[contains(@aria-label,'Break End')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", breakDurationEnd));
    }

    public void selectDriverOnRouteSettingsPage(String driverName)
    {
        sendKeys("//input[@aria-label='Search Driver']", driverName);
        pause500ms();
        click(String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", driverName));
        pause100ms();
    }

    public void clickCreate1RoutesButton()
    {
        click("//button[@aria-label='Create 1 Route(s)']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Create 1 Route(s)']//md-progress-circular", SAVE_BUTTON_LOADING_TIMEOUT_IN_SECONDS);
    }

    public void setFleetType1Capacity(String capacity){
        sendKeys("//input[@aria-label='Capacity']", capacity);

    }

    public void openWaypointDetail(){
        clickButtonOnTableWithNgRepeat(1, "wps", "wps", "route in ctrl.routeResponse.solution.routes");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'nv-route-detail-dialog')]", WAIT_TIMEOUT);
        waitUntilVisibilityOfElementLocated("//tr[@md-virtual-repeat='wp in getTableData()']", WAIT_TIMEOUT);
    }

    public void verifyWaypointDetailContent(String trackingId, String routeGroupName ){
        //check the waypoint have correct tracking id
        String trackingIdData =  getTextOnTableWithMdVirtualRepeat(1,"tracking_id","route in ctrl.routeResponse.solution.routes" );
        Assert.assertEquals(trackingId, trackingIdData);

        String trackingIdData2= getTextOnTableWithMdVirtualRepeat(2,"tracking_id","route in ctrl.routeResponse.solution.routes" );
        Assert.assertEquals(trackingId, trackingIdData2);
        //check the number of waypoint
        String waypointTotal= findElementByXpath("//md-dialog[contains(@class, 'nv-route-detail-dialog')]/md-dialog-content/div[1]/div[2]/p").getText();
        Assert.assertEquals(2, waypointTotal);

        //check waypoint is pickup and delivery
        Assert.assertEquals("PICKUP", getTextOnTableWithMdVirtualRepeat(1, "type", "route in ctrl.routeResponse.solution.routes"));
        Assert.assertEquals("DELIVERY", getTextOnTableWithMdVirtualRepeat(2, "type", "route in ctrl.routeResponse.solution.routes" ));
    }

    public void downloadCsvOnWaypointDetails(String trackingId) throws IOException {
        String routeName = "route-detail-"+findElementByXpath("//md-dialog[contains(@class, 'nv-route-detail-dialog')" +
                "]/md-dialog-content/div[1]/div[1]/p/b")
                .getText();
        //clear the downloaded file first
        File csvFile = new File(TestConstants.SELENIUM_WRITE_PATH+"/"+routeName+".csv");
        if(csvFile.exists()){
            csvFile.delete();
        }
        click("//button[@aria-label='Download CSV']");
        new WebDriverWait(getDriver(), WAIT_TIMEOUT).until((WebDriver driver) -> {
            File csvFileDownloaded = new File(TestConstants.SELENIUM_WRITE_PATH+"/"+routeName+".csv");
            return csvFileDownloaded.exists();
        });

        //check the downloaded file
        List<String> lines = Files.readAllLines(Paths.get(TestConstants.SELENIUM_WRITE_PATH+"/"+routeName+".csv"), Charset.defaultCharset());
        lines.forEach((String str)->{
            String [] columnData = str.split(",");
            Assert.assertFalse("Shouldn't have break in the exported csv",columnData[1].startsWith("break"));
        });

    }

    public void openUnroutedDetailDialog(){
        click("//button[@aria-label='View Unrouted Waypoints']");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'nv-unrouted-detail-dialog')]", WAIT_TIMEOUT);
        pause3s();
    }

    public void verifyUnroutedDetailDialog(){
        String unroutedCount = findElementByXpath("//md-dialog[contains(@class, 'nv-unrouted-detail-dialog')]/md-dialog-content/div[1]/div[1]/p/b")
                .getText();
        Assert.assertEquals("1",unroutedCount);
    }

    public void changeTheSuggestedDate(String suggestedDate){
        findElementByXpath("//md-datepicker[@ng-model='ctrl.suggested_date']//input").clear();
        sendKeys("//md-datepicker[@ng-model='ctrl.suggested_date']//input", suggestedDate);
    }

    public void clickUpdateTimeslotBtn(){
        click("//nv-api-text-button[@on-click='ctrl.onSaveSuggestedRoute()']/button");
        pause50ms();
        waitUntilInvisibilityOfElementLocated("//nv-api-text-button[@on-click='ctrl.onSaveSuggestedRoute()']//md-progress-circular", WAIT_TIMEOUT);
    }

    public String getWaypointTrackingIds(){
        StringBuilder sb = new StringBuilder();
        int waypointTotal=Integer.valueOf(findElementByXpath("//md-dialog[contains(@class, 'nv-route-detail-dialog')]/md-dialog-content/div[1]/div[2]/p")
                .getText());
        for(int i =0; i<waypointTotal; i++){
            String trackingId = getTextOnTableWithMdVirtualRepeat(i+1, "tracking_id","wp in getTableData()");
            if(!trackingId.equalsIgnoreCase("-")){
                sb.append(trackingId);
                if(i!=waypointTotal-1){
                    sb.append(",");
                }
            }
        }
        return sb.toString();
    }
}
