package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

import java.util.List;

public class ParcelSweeperLivePage extends OperatorV2SimplePage {

    private static final String ROUTE_ID_DIV_XPATH = "//div[contains(@class, 'route-info-container')]";
    private static final String ROUTE_ID_DIV_TEXT_XPATH = "/div[contains(@class,'inbound-data-info')]";
    private static final String ZONE_DIV_XPATH = "//div[contains(@class, 'zone-info-container')]";
    private static final String ZONE_DIV_TEXT_XPATH = "//div[contains(@class,'inbound-data-info')]";
    private static final String DESTINATION_HUB_DIV_XPATH = "//div[contains(@class, 'destination-hub-container')]";
    private static final String DESTINATION_HUB_DIV_TEXT_XPATH = "//div[contains(@class,'destination-hub')]";
    private static final String SCAN_ERROR_CLASS_XPATH = "[contains(@ng-class,'scan-error')]";

    private static final String ROUTE_ID_ERROR_TEXT = "NOT FOUND";
    private static final String ROUTE_ID_ERROR_TEXT2 = "NIL";
    private static final String ZONE_ERROR_TEXT = "NIL";
    private static final String DESTINATION_HUB_ERROR_TEXT = "NOT FOUND";

    public ParcelSweeperLivePage(WebDriver webDriver) {
        super(webDriver);
    }

    public void selectHubToBegin(String hubName){
        pause5s();
//        selectValueFromMdSelectByAriaLabel("Hub", hubName);
        selectValueFromMdSelectWithSearch("model", hubName);
        clickButtonByAriaLabelAndWaitUntilDone("Continue");
    }

//    public void scanTrackingId(String trackingId){
//
//
//    }


    public void scanTrackingId(String trackingId)
    {
        sendKeysAndEnterByAriaLabel("Tracking ID", trackingId);
        pause1s();
//        String xpathToTrackingId = "//input[@aria-label='scan_barcode' and contains(@class,'ng-empty')]";
//        waitUntilVisibilityOfElementLocated(xpathToBarCode);
    }

    public void verifyRouteIsIdNotFoundAndNil(){
        waitUntilVisibilityOfElementLocated(ROUTE_ID_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
        String textInRouteId = getText(ROUTE_ID_DIV_XPATH + ROUTE_ID_DIV_TEXT_XPATH);
        assertThat("Expected scan error for Route ID", textInRouteId, containsString(ROUTE_ID_ERROR_TEXT));
        assertThat("Expected scan error for Route ID", textInRouteId, containsString(ROUTE_ID_ERROR_TEXT2));
    }

    public void verifyZoneNameIsNil(){
        waitUntilVisibilityOfElementLocated(ZONE_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
        String textInZone = getText(ZONE_DIV_XPATH + ZONE_DIV_TEXT_XPATH);
        assertThat("Expected scan error for Zone", textInZone, containsString(ZONE_ERROR_TEXT));
    }

    public void verifyDestinationHubIsNotFound(){
        waitUntilVisibilityOfElementLocated(DESTINATION_HUB_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
        String textInZone = getText(DESTINATION_HUB_DIV_XPATH + DESTINATION_HUB_DIV_TEXT_XPATH);
        assertThat("Expected scan error for Destination Hub", textInZone, containsString(DESTINATION_HUB_ERROR_TEXT));
    }


//(@ng-class,'scan-error')]")

//    THEN verify that 'Parcel Sweeper' page is loaded
//#  WHEN scan/enter tracking_id into 'Tracking Id' field
//#  THEN verify that there is a very loud siren sound alert
//#  AND verify Route ID = 'NOT FOUND' and driver name = 'NIL' with red background color
//#  AND verify Zone name = 'NIL' with red backgroud color
//#  AND verify destination hub = 'NOT FOUND' with red background color

}
