package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.BulkAddressVerificationPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import cucumber.api.java.en.When;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
    public void operatorUploadBulkAddressCSV(Map<String, String> data) throws Throwable
    {
        String waypoint = data.getOrDefault("waypoint", "");
        List<JaroScore> jaroScores = new ArrayList<>();
        switch (waypoint.toUpperCase())
        {
            case "FROM_CREATED_ORDER_DETAILS":
                List<Order> ordersDetails = get(KEY_LIST_OF_ORDER_DETAILS);
                ordersDetails.stream().map(od -> {
                    List<Long> wptIds =
                            od.getTransactions().stream()
                                    .filter(transaction -> "delivery".equalsIgnoreCase(transaction.getType()))
                                    .map(Transaction::getWaypointId).collect(Collectors.toList());
                    return wptIds.get(wptIds.size() - 1);
                }).forEach(waypointId -> {
                    JaroScore jaroScore = new JaroScore();
                    jaroScore.setWaypointId(waypointId);
                    jaroScores.add(jaroScore);
                });
                break;
            default:
                JaroScore jaroScore = new JaroScore();
                jaroScore.setWaypointId(Long.parseLong(waypoint));
                jaroScores.add(jaroScore);
        }

        String latitude = data.getOrDefault("latitude", "");
        switch (latitude.toUpperCase())
        {
            case "GENERATED":
                jaroScores.forEach(jaroScore -> jaroScore.setLatitude(TestUtils.generateLatitude()));
                break;
            default:
                jaroScores.forEach(jaroScore -> jaroScore.setLatitude(Long.parseLong(latitude)));
        }

        String longitude = data.getOrDefault("longitude", "");
        switch (longitude.toUpperCase())
        {
            case "GENERATED":
                jaroScores.forEach(jaroScore -> jaroScore.setLongitude(TestUtils.generateLongitude()));
                break;
            default:
                jaroScores.forEach(jaroScore -> jaroScore.setLongitude(Long.parseLong(longitude)));
        }

        put(KEY_LIST_OF_CREATED_JARO_SCORES, jaroScores);

        List<String> csvLines = new ArrayList<>();
        csvLines.add("\"waypoint\",\"latitude\",\"longitude\"");
        jaroScores.forEach(jaroScore -> csvLines.add(jaroScore.getWaypointId() + "," + jaroScore.getLatitude() + "," + jaroScore.getLongitude()));
        File file = TestUtils.createFileOnTempFolder(String.format("bulk_address_verification_%s.csv", generateDateUniqueString()));
        FileUtils.writeLines(file, csvLines);

        bulkAddressVerificationPage.uploadCsv(file);
    }
}
