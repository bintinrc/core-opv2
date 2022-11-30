package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.common.model.others.LatLong;
import co.nvqa.operator_v2.selenium.page.BulkAddressVerificationPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class BulkAddressVerificationSteps extends AbstractSteps {

  private BulkAddressVerificationPage bulkAddressVerificationPage;

  private static final Logger LOGGER = LoggerFactory.getLogger(
      BulkAddressVerificationSteps.class);

  private final List<String> RTS_COORDINATES = Arrays.asList(
      "-6.181226,106.8495638",
      "-6.2029292,106.8545137",
      "-6.174735,106.780596",
      "-6.1742535,106.77682",
      "-6.151248,106.819445");
  private final List<String> STANDARD_COORDINATES = Arrays.asList(
      "-1.281639,116.81121",
      "-6.9244903,107.6151734",
      "-0.963643,134.8607027",
      "-1.0900375,136.3030889",
      "-1.087063,116.750833");
  private final List<String> OOZ_COORDINATES = Arrays.asList(
      "-6.5950181,106.7218509",
      "-6.7265577,106.6558723",
      "-6.3102167,106.0822391",
      "-6.6228333,106.2747787",
      "-6.7618565,105.8070492");

  public BulkAddressVerificationSteps() {
  }

  @Override
  public void init() {
    bulkAddressVerificationPage = new BulkAddressVerificationPage(getWebDriver());
  }

  private String getCoordinate(int index, String type) {
    int randomConfigIndex = (int) Math.floor(Math.random() * 100) % 5;
    String coordinates;

    switch (type) {
      case "FROM_CONFIG":
        coordinates = STANDARD_COORDINATES.get(randomConfigIndex);
        break;
      case "FROM_CONFIG_RTS":
        coordinates = RTS_COORDINATES.get(randomConfigIndex);
        break;
      default:
        coordinates = OOZ_COORDINATES.get(randomConfigIndex);
        break;
    }

    return coordinates.split(",")[index];
  }

  @When("^Operator upload bulk address CSV using data below:$")
  public void operatorUploadBulkAddressCSV(Map<String, String> data) {
    String waypoint = data.getOrDefault("waypoint", "");
    List<Order> ordersDetails = get(KEY_LIST_OF_ORDER_DETAILS);
    List<JaroScore> jaroScores = new ArrayList<>();

    switch (waypoint.toUpperCase()) {
      case "FROM_CREATED_ORDER_DETAILS":
        ordersDetails.forEach(od ->
        {
          Transaction transaction = od.getLastDeliveryTransaction();
          JaroScore jaroScore = new JaroScore();
          jaroScore.setWaypointId(transaction.getWaypointId());
          jaroScore.setVerifiedAddressId("BULK_VERIFY");
          jaroScore.setAddress1(od.getToAddress1());
          jaroScores.add(jaroScore);
        });
        break;
      case "FROM_CREATED_RESERVATION_DETAILS":
        List<Reservation> reservations = get(KEY_LIST_OF_CREATED_RESERVATIONS);
        reservations.forEach(rsv -> {
          JaroScore jaroScore = new JaroScore();
          jaroScore.setWaypointId(rsv.getWaypointId());
          jaroScores.add(jaroScore);
        });
        break;
      case "EMPTY":
        ordersDetails.forEach(od ->
        {
          JaroScore jaroScore = new JaroScore();
          jaroScores.add(jaroScore);
        });
        break;
      case "MIX":
        ordersDetails.forEach(od ->
        {
          Transaction transaction = od.getLastDeliveryTransaction();
          JaroScore jaroScore = new JaroScore();
          if ((int) Math.floor(Math.random() * 100) % 2 == 1) {
            jaroScore.setWaypointId(transaction.getWaypointId());
          }
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
    LatLong randomLatLong = StandardTestUtils.generateRandomLatLong();

    switch (latitude.toUpperCase()) {
      case "GENERATED":
        jaroScores.forEach(jaroScore -> jaroScore.setLatitude(randomLatLong.getLatitude()));
        break;
      case "FROM_CONFIG":
      case "FROM_CONFIG_RTS":
      case "FROM_CONFIG_OOZ":
        jaroScores.forEach(
            jaroScore -> jaroScore.setLatitude(getCoordinate(0, latitude.toUpperCase())));
        break;
      default:
        jaroScores.forEach(jaroScore -> jaroScore.setLatitude(Double.parseDouble(latitude)));
    }

    String longitude = data.getOrDefault("longitude", "");

    switch (longitude.toUpperCase()) {
      case "GENERATED":
        jaroScores.forEach(jaroScore -> jaroScore.setLongitude(randomLatLong.getLongitude()));
        break;
      case "FROM_CONFIG":
      case "FROM_CONFIG_RTS":
      case "FROM_CONFIG_OOZ":
        jaroScores.forEach(
            jaroScore -> jaroScore.setLongitude(getCoordinate(1, longitude.toUpperCase())));
        break;
      default:
        jaroScores.forEach(jaroScore -> jaroScore.setLongitude(Double.parseDouble(longitude)));
    }

    put(KEY_LIST_OF_CREATED_JARO_SCORES, jaroScores);

    bulkAddressVerificationPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.uploadWaypointsData(jaroScores);
    });
  }

  @When("^Operator download sample CSV file on Bulk Address Verification page$")
  public void operatorDownloadSampleCsvFile() {
    bulkAddressVerificationPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.downloadSampleCsv.click();
    });
  }

  @Then("^sample CSV file on Bulk Address Verification page is downloaded successfully$")
  public void operatorVerifySampleCsvFileIsDownloadedSuccessfully() {
    retryIfAssertionErrorOccurred(() -> {
      bulkAddressVerificationPage.verifyFileDownloadedSuccessfully("sample_csv.csv",
          "waypoint,latitude,longitude\n"
              + "5259518,1.32323,103.1212");
    }, "verify csv file downloaded successfully");

  }

  @And("^Operator verifies waypoints are assigned to \"([^\"]*)\" rack sector upon bulk address verification$")
  public void operatorVerifiesWaypointsAreAssignedToRackSectorUponBulkAddressVerification(
      String sector) {
    bulkAddressVerificationPage.switchTo();
    boolean isRts = sector.equals("RTS");
    List<JaroScore> listOfJaroScore = get(KEY_LIST_OF_CREATED_JARO_SCORES);
    List<JaroScore> listOfValidJaroScore = listOfJaroScore.stream()
        .filter(js -> js.getWaypointId() != null).collect(
            Collectors.toList());
    bulkAddressVerificationPage.verifyWaypointsRackSector(listOfValidJaroScore, isRts);
    put(KEY_LIST_OF_CREATED_JARO_SCORES, listOfValidJaroScore);
  }

  @Then("Operator update successfully matched waypoints upon bulk address verification")
  public void operatorUpdateSuccessfullyMatchedWaypointsUponBulkAddressVerification() {
    List<JaroScore> listOfJaroScore = get(KEY_LIST_OF_CREATED_JARO_SCORES);
    bulkAddressVerificationPage.updateSuccessfulMatches(listOfJaroScore.size());
  }

  @Then("Operator clicks Update successful matched on Bulk Address Verification page")
  public void operatorUpdateSuccessfullyMatched() {
    bulkAddressVerificationPage.inFrame(page ->
        bulkAddressVerificationPage.updateSuccessfulMatches.click());
  }
}
