package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.operator_v2.selenium.page.ParcelSweeperLivePage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.util.List;
import java.util.Map;
import java.util.Objects;

@ScenarioScoped
public class ParcelSweeperLiveSteps extends AbstractSteps {

    private ParcelSweeperLivePage parcelSweeperLivePage;

    public ParcelSweeperLiveSteps()
    {
    }

    @Override
    public void init()
    {
        parcelSweeperLivePage = new ParcelSweeperLivePage(getWebDriver());
    }


    @Then("^Operator verifies data on Parcel Sweeper Live page using data below:$")
    public void operatorVerifiesWithInvalidTrackingIdProvidedErrorsDisplayed(Map<String, String> mapOfData) {
        String routeId = mapOfData.get("routeId");
        String routeIdColor = mapOfData.get("routeId_color");
        String zoneName = mapOfData.get("zoneName");
        String zoneNameColor = mapOfData.get("zoneName_color");
        String destinationHub = mapOfData.get("destinationHub");
        if (StringUtils.equalsIgnoreCase(destinationHub, "CREATED"))
        {
            Order order = get(KEY_CREATED_ORDER);
            destinationHub = order.getDestinationHub();
        }
        String destinationHubColor = mapOfData.get("destinationHub_color");

        if (Objects.nonNull(routeId) && Objects.nonNull(routeIdColor)){
            parcelSweeperLivePage.verifyRoute(routeId, routeIdColor);
        }
        if (Objects.nonNull(zoneName) && Objects.nonNull(zoneNameColor)){
            parcelSweeperLivePage.verifyZone(getExpectedZoneName(zoneName), zoneNameColor);
        }
        if (Objects.nonNull(destinationHub) && Objects.nonNull(destinationHubColor)){
            parcelSweeperLivePage.verifyDestinationHub(destinationHub, destinationHubColor);
        }
    }

    @Then("^Operator provides data on Parcel Sweeper Live page:$")
    public void operatorProvidesDataOnParcelSweeperLivePage(Map<String, String> mapOfData) {
        mapOfData = resolveKeyValues(mapOfData);
        parcelSweeperLivePage.selectHubToBegin(mapOfData.get("hubName"));

        String trackingId = mapOfData.get("trackingId");
        if (StringUtils.equalsIgnoreCase(trackingId, "CREATED"))
        {
            trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        }
        parcelSweeperLivePage.scanTrackingId(trackingId);
    }

    private String getExpectedZoneName(String zoneNameFromDataTable){
        if (StringUtils.equalsIgnoreCase(zoneNameFromDataTable, "FROM CREATED ORDER"))
        {
            Order order = get(KEY_CREATED_ORDER);
            Transaction deliveryTransaction = order.getTransactions().stream()
                    .filter(transaction -> "DELIVERY".equalsIgnoreCase(transaction.getType()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Could not find DELIVERY transaction for order [" + order.getId() + "]"));
            List<Zone> zones = get(KEY_LIST_OF_ZONE_PREFERENCES);
            Zone routingZone = zones.stream().filter(zone -> Objects.equals(zone.getLegacyZoneId(), deliveryTransaction.getRoutingZoneId()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Could not find zone with ID = " + deliveryTransaction.getRoutingZoneId()));
            String zoneNameExpected = f("%s (%s)", routingZone.getShortName(), routingZone.getName());
            return zoneNameExpected;
        }
        else return zoneNameFromDataTable;
    }

    @When("^Operator verifies priority level dialog box shows correct priority level info using data below:$")
    public void operatorVerifiesPriorityLevel(Map<String, String> mapOfData)
    {
        int expectedPriorityLevel = Integer.parseInt(mapOfData.get("priorityLevel"));
        String expectedPriorityLevelColorAsHex = mapOfData.get("priorityLevelColorAsHex");
        parcelSweeperLivePage.verifiesPriorityLevel(expectedPriorityLevel, expectedPriorityLevelColorAsHex);
    }

    @Then("^Operator verify RTS label on Parcel Sweeper Live page$")
    public void operatorVerifyRtsLabelOnParcelSweeperByHubPage()
    {
        parcelSweeperLivePage.verifyRTSInfo(true);
    }

}
