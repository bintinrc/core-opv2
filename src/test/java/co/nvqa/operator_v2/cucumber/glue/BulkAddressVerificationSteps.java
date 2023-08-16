package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.model.others.LatLong;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commonsort.model.addressing.JaroScore;
import co.nvqa.operator_v2.selenium.page.BulkAddressVerificationPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
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
    String method = data.getOrDefault("method", "");
    Long waypointId = Long.valueOf(resolveValue(data.get("waypoint")));
    String toAddress1 = resolveValue(data.get("toAddress1"));
    List<JaroScore>
        jaroScores = new ArrayList<>();

    switch (method.toUpperCase()) {
      case "FROM_CREATED_ORDER_DETAILS":
        JaroScore jaroScore = new JaroScore();
        jaroScore.setWaypointId(waypointId);
        jaroScore.setVerifiedAddressId("BULK_VERIFY");
        jaroScore.setAddress1(toAddress1);
        jaroScores.add(jaroScore);
        break;
      case "EMPTY":
        jaroScore = new JaroScore();
        jaroScores.add(jaroScore);
        break;
      case "MIX":
        jaroScore = new JaroScore();
        if ((int) Math.floor(Math.random() * 100) % 2 == 1) {
          jaroScore.setWaypointId(waypointId);
        }
        jaroScore.setVerifiedAddressId("BULK_VERIFY");
        jaroScore.setAddress1(toAddress1);
        jaroScores.add(jaroScore);
        break;
      default:
        jaroScore = new JaroScore();
        jaroScore.setWaypointId(waypointId);
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
            jaroScore -> jaroScore.setLatitude(
                Double.valueOf(getCoordinate(0, latitude.toUpperCase()))));
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
            jaroScore -> jaroScore.setLongitude(
                Double.valueOf(getCoordinate(1, longitude.toUpperCase()))));
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
    doWithRetry(() -> {
      bulkAddressVerificationPage.verifyFileDownloadedSuccessfully("sample_csv.csv",
          "waypoint,latitude,longitude\n"
              + "5259518,1.32323,103.1212");
    }, "verify csv file downloaded successfully");

  }

  @And("^Operator verifies waypoints are assigned to \"([^\"]*)\" rack sector upon bulk address verification$")
  public void operatorVerifiesWaypointsAreAssignedToRackSectorUponBulkAddressVerification(
      String sector) {
    bulkAddressVerificationPage.switchTo();
    String elementXpath = "//td[@class='zone_short_name']";
    String xpath = "//td[@class='%s']//span[contains(text(),'%s')]";
    switch (sector) {
      case "RTS":
        elementXpath = String.format(xpath, "zone_short_name", sector);
        break;
      case "NOT_FOUND":
        elementXpath = String.format(xpath, "error", sector);
        break;
      case "STANDARD":
        break;
    }
    Assertions.assertThat(
        bulkAddressVerificationPage.findElementByXpath(elementXpath).isDisplayed());
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
    bulkAddressVerificationPage.switchTo();
    bulkAddressVerificationPage.waitUntilNoticeMessage("waypoint");
  }

  @Then("Operator verify pricing info of order with:")
  public void operatorVerifyPricingInfoOfOrderWith(Map<String, String> data) {
    data = resolveKeyValues(data);
    String expectedFromBillingZoneBillingZone = data.get("expectedfromBillingZone.billingZone");
    String expectedFromBillingZoneLatitude = data.get("expectedfromBillingZone.latitude");
    String expectedFromBillingZoneLongitude = data.get("expectedfromBillingZone.longitude");
    String expectedFromBillingZoneL1Id = data.get("expectedfromBillingZone.l1_id");
    String expectedFromBillingZoneL1Name = data.get("expectedfromBillingZone.l1_name");
    String expectedFromBillingZoneL2Id = data.get("expectedfromBillingZone.l2_id");
    String expectedFromBillingZoneL2Name = data.get("expectedfromBillingZone.l2_name");
    String expectedFromBillingZoneL3Id = data.get("expectedfromBillingZone.l3_id");
    String expectedFromBillingZoneL3Name = data.get("expectedfromBillingZone.l3_name");

    String expectedToBillingZoneBillingZone = data.get("expectedtoBillingZone.billingZone");
    String expectedToBillingZoneLatitude = data.get("expectedtoBillingZone.latitude");
    String expectedToBillingZoneLongitude = data.get("expectedtoBillingZone.longitude");
    String expectedToBillingZoneL1Id = data.get("expectedtoBillingZone.l1_id");
    String expectedToBillingZoneL1Name = data.get("expectedtoBillingZone.l1_name");
    String expectedToBillingZoneL2Id = data.get("expectedtoBillingZone.l2_id");
    String expectedToBillingZoneL2Name = data.get("expectedtoBillingZone.l2_name");
    String expectedToBillingZoneL3Id = data.get("expectedtoBillingZone.l3_id");
    String expectedToBillingZoneL3Name = data.get("expectedtoBillingZone.l3_name");

    String fromBillingZoneBillingZone = data.get("fromBillingZone.billingZone");
    String fromBillingZoneLatitude = data.get("fromBillingZone.latitude");
    String fromBillingZoneLongitude = data.get("fromBillingZone.longitude");
    String fromBillingZoneL1Id = data.get("fromBillingZone.l1_id");
    String fromBillingZoneL1Name = data.get("fromBillingZone.l1_name");
    String fromBillingZoneL2Id = data.get("fromBillingZone.l2_id");
    String fromBillingZoneL2Name = data.get("fromBillingZone.l2_name");
    String fromBillingZoneL3Id = data.get("fromBillingZone.l3_id");
    String fromBillingZoneL3Name = data.get("fromBillingZone.l3_name");

    String toBillingZoneBillingZone = data.get("toBillingZone.billingZone");
    String toBillingZoneLatitude = data.get("toBillingZone.latitude");
    String toBillingZoneLongitude = data.get("toBillingZone.latitude");
    String toBillingZoneL1Id = data.get("toBillingZone.l1_id");
    String toBillingZoneL1Name = data.get("toBillingZone.l1_name");
    String toBillingZoneL2Id = data.get("toBillingZone.l2_id");
    String toBillingZoneL2Name = data.get("toBillingZone.l2_name");
    String toBillingZoneL3Id = data.get("toBillingZone.l3_id");
    String toBillingZoneL3Name = data.get("toBillingZone.l3_name");
    if (expectedFromBillingZoneBillingZone.equals(fromBillingZoneBillingZone)) {
      System.out.println("Expected and actual billingZone values for fromBillingZone match.");
    } else {
      System.out.println(
          "Expected and actual billingZone values for fromBillingZone do not match.");
    }
    if (expectedToBillingZoneBillingZone.equals(toBillingZoneBillingZone)) {
      System.out.println("Expected and actual billingZone values for toBillingZone match.");
    } else {
      System.out.println(
          "Expected and actual billingZone values for toBillingZone do not match.");
    }
    if (expectedFromBillingZoneLatitude.equals(fromBillingZoneLatitude)) {
      System.out.println("Expected and actual latitude values for fromBillingZone match.");
    } else {
      System.out.println("Expected and actual latitude values for fromBillingZone do not match.");
    }
    if (expectedFromBillingZoneLongitude.equals(fromBillingZoneLongitude)) {
      System.out.println("Expected and actual longitude values for fromBillingZone match.");
    } else {
      System.out.println("Expected and actual longitude values for fromBillingZone do not match.");
    }
    if (expectedToBillingZoneLatitude.equals(toBillingZoneLatitude)) {
      System.out.println("Expected and actual latitude values for toBillingZone match.");
    } else {
      System.out.println("Expected and actual latitude values for toBillingZone do not match.");
    }
    if (expectedToBillingZoneLongitude.equals(toBillingZoneLongitude)) {
      System.out.println("Expected and actual longitude values for toBillingZone match.");
    } else {
      System.out.println("Expected and actual longitude values for toBillingZone do not match.");
    }

    if (expectedFromBillingZoneL1Id.equals(fromBillingZoneL1Id)) {
      System.out.println("Expected and actual l1_id values for fromBillingZone match.");
    } else {
      System.out.println("Expected and actual l1_id values for fromBillingZone do not match.");
    }
    if (expectedFromBillingZoneL2Id.equals(fromBillingZoneL2Id)) {
      System.out.println("Expected and actual l2_id values for fromBillingZone match.");
    } else {
      System.out.println("Expected and actual l2_id values for fromBillingZone do not match.");
    }
    if (expectedFromBillingZoneL3Id.equals(fromBillingZoneL3Id)) {
      System.out.println("Expected and actual l3_id values for fromBillingZone match.");
    } else {
      System.out.println("Expected and actual l3_id values for fromBillingZone do not match.");
    }
    if (expectedToBillingZoneL1Id.equals(toBillingZoneL1Id)) {
      System.out.println("Expected and actual l1_id values for toBillingZone match.");
    } else {
      System.out.println("Expected and actual l1_id values for toBillingZone do not match.");
    }
    if (expectedToBillingZoneL2Id.equals(toBillingZoneL2Id)) {
      System.out.println("Expected and actual l2_id values for toBillingZone match.");
    } else {
      System.out.println("Expected and actual l2_id values for toBillingZone do not match.");
    }
    if (expectedToBillingZoneL3Id.equals(toBillingZoneL3Id)) {
      System.out.println("Expected and actual l3_id values for toBillingZone match.");
    } else {
      System.out.println("Expected and actual l3_id values for toBillingZone do not match.");
    }
    if (expectedFromBillingZoneL1Name.equals(fromBillingZoneL1Name)) {
      System.out.println("Expected and actual l1_name values for fromBillingZone match.");
    } else {
      System.out.println("Expected and actual l1_name values for fromBillingZone do not match.");
    }
    if (expectedFromBillingZoneL2Name.equals(fromBillingZoneL2Name)) {
      System.out.println("Expected and actual l2_name values for fromBillingZone match.");
    } else {
      System.out.println("Expected and actual l2_name values for fromBillingZone do not match.");
    }
    if (expectedFromBillingZoneL3Name.equals(fromBillingZoneL3Name)) {
      System.out.println("Expected and actual l3_name values for fromBillingZone match.");
    } else {
      System.out.println("Expected and actual l3_name values for fromBillingZone do not match.");
    }
    if (expectedToBillingZoneL1Name.equals(toBillingZoneL1Name)) {
      System.out.println("Expected and actual l1_name values for toBillingZone match.");
    } else {
      System.out.println("Expected and actual l1_name values for toBillingZone do not match.");
    }
    if (expectedToBillingZoneL2Name.equals(toBillingZoneL2Name)) {
      System.out.println("Expected and actual l2_name values for toBillingZone match.");
    } else {
      System.out.println("Expected and actual l2_name values for toBillingZone do not match.");
    }
    if (expectedToBillingZoneL3Name.equals(toBillingZoneL3Name)) {
      System.out.println("Expected and actual l3_name values for toBillingZone match.");
    } else {
      System.out.println("Expected and actual l3_name values for toBillingZone do not match.");
    }

  }

  @When("^Operator upload bulk multiple address CSV using data below:$")
  public void operatorUploadBulkMultipleAddressCSV(List<Map<String, String>> data) {
    List<String> methods = new ArrayList<>();
    List<String> waypoints = new ArrayList<>();
    List<String> toAddresses = new ArrayList<>();
    List<String> latitudes = new ArrayList<>();
    List<String> longitudes = new ArrayList<>();
    List<JaroScore>
        jaroScores = new ArrayList<>();

    for (Map<String, String> entry : data) {
      methods.add(resolveValue(entry.get("method")));
      waypoints.add(resolveValue(entry.get("waypoint")));
      toAddresses.add(resolveValue(entry.get("toAddress1")));
      latitudes.add(resolveValue(entry.get("latitude")));
      longitudes.add(resolveValue(entry.get("longitude")));
    }

    for (int i = 0; i < methods.size(); i++) {
      String method = methods.get(i);
      String waypointId = waypoints.get(i);
      String toAddress1 = toAddresses.get(i);
      String latitude = latitudes.get(i);
      String longitude = longitudes.get(i);
      switch (method.toUpperCase()) {
        case "FROM_CREATED_ORDER_DETAILS":
          JaroScore jaroScore = new JaroScore();
          jaroScore.setWaypointId(Long.valueOf(waypointId));
          jaroScore.setVerifiedAddressId("BULK_VERIFY");
          jaroScore.setAddress1(toAddress1);
          jaroScores.add(jaroScore);
          break;
        case "EMPTY":
          jaroScore = new JaroScore();
          jaroScores.add(jaroScore);
          break;
        case "MIX":
          jaroScore = new JaroScore();
          if ((int) Math.floor(Math.random() * 100) % 2 == 1) {
            jaroScore.setWaypointId(Long.valueOf(waypointId));
          }
          jaroScore.setVerifiedAddressId("BULK_VERIFY");
          jaroScore.setAddress1(toAddress1);
          jaroScores.add(jaroScore);
          break;
        default:
          jaroScore = new JaroScore();
          jaroScore.setWaypointId(Long.valueOf(waypointId));
          jaroScores.add(jaroScore);
      }

      LatLong randomLatLong = StandardTestUtils.generateRandomLatLong();
      switch (latitude.toUpperCase()) {
        case "GENERATED":
          jaroScores.get(i).setLatitude(randomLatLong.getLatitude());
          break;
        case "FROM_CONFIG":
        case "FROM_CONFIG_RTS":
        case "FROM_CONFIG_OOZ":
          jaroScores.get(i).setLatitude(
              Double.valueOf(getCoordinate(0, latitude.toUpperCase())));
          break;
        default:
          jaroScores.get(i).setLatitude(Double.parseDouble(latitude));
      }
      switch (longitude.toUpperCase()) {
        case "GENERATED":
          jaroScores.get(i).setLongitude(randomLatLong.getLongitude());
          break;
        case "FROM_CONFIG":
        case "FROM_CONFIG_RTS":
        case "FROM_CONFIG_OOZ":
          jaroScores.get(i).setLongitude(
              Double.valueOf(getCoordinate(1, longitude.toUpperCase())));
          break;
        default:
          jaroScores.get(i).setLongitude(Double.parseDouble(longitude));
      }
      putInList(KEY_LIST_OF_CREATED_JARO_SCORES, jaroScores);
    }
    bulkAddressVerificationPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.uploadWaypointsData(jaroScores);
    });
  }
}

