package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.other.LatLong;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.BulkAddressVerificationPage;
import com.google.inject.Inject;
import cucumber.api.java.en.When;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author Sergey Mishanin
 */
public class BulkAddressVerificationSteps extends AbstractSteps
{
    private BulkAddressVerificationPage bulkAddressVerificationPage;

    @Inject
    public BulkAddressVerificationSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        bulkAddressVerificationPage = new BulkAddressVerificationPage(getWebDriver());
    }

    @When("^Operator upload bulk address CSV using data below:$")
    public void operatorUploadBulkAddressCSV(Map<String, String> data)
    {
        String waypoint = data.getOrDefault("waypoint", "");
        List<JaroScore> jaroScores = new ArrayList<>();

        switch(waypoint.toUpperCase())
        {
            case "FROM_CREATED_ORDER_DETAILS":
                List<Order> ordersDetails = get(KEY_LIST_OF_ORDER_DETAILS);
                ordersDetails.forEach(od ->
                {
                    List<Transaction> deliveryTransactions =
                            od.getTransactions().stream()
                                    .filter(transaction -> "delivery".equalsIgnoreCase(transaction.getType()))
                                    .collect(Collectors.toList());
                    Transaction transaction = deliveryTransactions.get(deliveryTransactions.size()-1);
                    JaroScore jaroScore = new JaroScore();
                    jaroScore.setWaypointId(transaction.getWaypointId());
                    jaroScore.setVerifiedAddressId("BULK_VERIFY");
                    jaroScore.setAddress1(od.getToAddress1());
                    jaroScores.add(jaroScore);
                });
                break;
            default:
                JaroScore jaroScore = new JaroScore();
                jaroScore.setWaypointId(Long.parseLong(waypoint));
                jaroScores.add(jaroScore);
        }

        String latitude = data.getOrDefault("latitude", "");
        LatLong randomLatLong = generateRandomLatLong();

        switch(latitude.toUpperCase())
        {
            case "GENERATED":
                jaroScores.forEach(jaroScore -> jaroScore.setLatitude(randomLatLong.getLatitude()));
                break;
            default:
                jaroScores.forEach(jaroScore -> jaroScore.setLatitude(Double.parseDouble(latitude)));
        }

        String longitude = data.getOrDefault("longitude", "");

        switch(longitude.toUpperCase())
        {
            case "GENERATED":
                jaroScores.forEach(jaroScore -> jaroScore.setLongitude(randomLatLong.getLongitude()));
                break;
            default:
                jaroScores.forEach(jaroScore -> jaroScore.setLongitude(Double.parseDouble(longitude)));
        }

        put(KEY_LIST_OF_CREATED_JARO_SCORES, jaroScores);
        bulkAddressVerificationPage.uploadWaypointsData(jaroScores);
    }
}
