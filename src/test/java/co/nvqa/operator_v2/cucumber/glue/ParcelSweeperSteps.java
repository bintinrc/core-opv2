package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.GlobalInboundResponse;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.core.zone.Zone;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.ParcelSweeperPage;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ParcelSweeperSteps extends AbstractSteps
{
    private ParcelSweeperPage parcelSweeperPage;

    @Inject
    public ParcelSweeperSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        parcelSweeperPage = new ParcelSweeperPage(getWebDriver());
    }

    @Given("^Operator sweep created parcel using hub \"(.+)\"$")
    public void operatorGoToMenu(String hubName)
    {
        parcelSweeperPage.selectHub(hubName);
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        parcelSweeperPage.enterTrackingId(trackingId);
    }

    @Given("^Operator sweep parcel using data below:$")
    public void operatorSweepParcelUsingDataBelow(Map<String, String> mapOfData)
    {
        String hubName = mapOfData.get("hubName");
        parcelSweeperPage.selectHub(hubName);

        String trackingId = mapOfData.get("trackingId");
        if (StringUtils.equalsIgnoreCase(trackingId, "CREATED"))
        {
            trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        }
        parcelSweeperPage.enterTrackingId(trackingId);
    }

    @Then("^Operator verify Route ID on Parcel Sweeper page using data below:$")
    public void operatorVerifyRouteIDOnParcelSweeperPageUsingDataBelow(Map<String, String> mapOfData)
    {
        Long routeId = null;
        String value = mapOfData.get("routeId");
        if (StringUtils.isNotBlank(value))
        {
            routeId = value.equalsIgnoreCase("GENERATED") ?
                    get(KEY_CREATED_ROUTE_ID) :
                    Long.valueOf(value);

        }

        String driverName = mapOfData.get("driverName");
        String color = mapOfData.get("color");
        parcelSweeperPage.verifyRouteInfo(routeId, driverName, color);
    }

    @Then("^Operator verify Zone on Parcel Sweeper page using data below:$")
    public void operatorVerifyZoneOnParcelSweeperPageUsingDataBelow(Map<String, String> mapOfData)
    {
        String zoneName = mapOfData.get("zoneName");
        if (StringUtils.equalsIgnoreCase(zoneName, "FROM CREATED ORDER"))
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
            zoneName = f("%s (%s)", routingZone.getShortName(), routingZone.getName());
        }
        String color = mapOfData.get("color");
        parcelSweeperPage.verifyZoneInfo(zoneName, color);
    }

    @Then("^Operator verify Destination Hub on Parcel Sweeper page using data below:$")
    public void operatorVerifyDestinationHubOnParcelSweeperPageUsingDataBelow(Map<String, String> mapOfData)
    {
        String hubName = mapOfData.get("hubName");
        if (StringUtils.equalsAnyIgnoreCase(hubName, "GLOBAL INBOUND"))
        {
            GlobalInboundResponse globalInboundResponse = get(KEY_GLOBAL_INBOUND_DATA);
            hubName = globalInboundResponse.getResponsibleHubName();
        }
        String color = mapOfData.get("color");
        parcelSweeperPage.verifyDestinationHub(hubName, color);
    }

    @When("^Operator sweep created parcel using prefix and hub \"([^\"]*)\"$")
    public void operatorSweepCreatedParcelUsingPrefixAndHub(String hubName)
    {
        parcelSweeperPage.selectHub(hubName);
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String prefix = trackingId.substring(0, 5);
        trackingId = trackingId.substring(5);
        parcelSweeperPage.addPrefix(prefix);
        parcelSweeperPage.enterTrackingId(trackingId);
    }
}
