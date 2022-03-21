package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.commons.model.other.LatLong;
import co.nvqa.operator_v2.selenium.page.BulkAddressVerificationPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class BulkAddressVerificationSteps extends AbstractSteps {

  private BulkAddressVerificationPage bulkAddressVerificationPage;

  public BulkAddressVerificationSteps() {
  }

  @Override
  public void init() {
    bulkAddressVerificationPage = new BulkAddressVerificationPage(getWebDriver());
  }

  @When("^Operator upload bulk address CSV using data below:$")
  public void operatorUploadBulkAddressCSV(Map<String, String> data) {
    String waypoint = data.getOrDefault("waypoint", "");
    List<JaroScore> jaroScores = new ArrayList<>();

    switch (waypoint.toUpperCase()) {
      case "FROM_CREATED_ORDER_DETAILS":
        List<Order> ordersDetails = get(KEY_LIST_OF_ORDER_DETAILS);
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
      case "FROM_CREATED_RESERVATIONS":
        List<Reservation> reservations = get(KEY_LIST_OF_CREATED_RESERVATIONS);
        List<Address> addresses = get(KEY_LIST_OF_CREATED_ADDRESSES);
        for (int i = 0; i < reservations.size(); i++) {
          Reservation r = reservations.get(i);
          Address a = addresses.get(i);
          JaroScore jaroScore = new JaroScore();
          jaroScore.setWaypointId(r.getWaypointId());
          jaroScore.setVerifiedAddressId("BULK_VERIFY");
          jaroScore.setAddress1(a.getAddress1());
          jaroScores.add(jaroScore);
        }
        break;
      default:
        JaroScore jaroScore = new JaroScore();
        jaroScore.setWaypointId(Long.parseLong(waypoint));
        jaroScores.add(jaroScore);
    }

    String latitude = data.getOrDefault("latitude", "");
    LatLong randomLatLong = generateRandomLatLong();

    switch (latitude.toUpperCase()) {
      case "GENERATED":
        jaroScores.forEach(jaroScore -> jaroScore.setLatitude(randomLatLong.getLatitude()));
        break;
      default:
        jaroScores.forEach(jaroScore -> jaroScore.setLatitude(Double.parseDouble(latitude)));
    }

    String longitude = data.getOrDefault("longitude", "");

    switch (longitude.toUpperCase()) {
      case "GENERATED":
        jaroScores.forEach(jaroScore -> jaroScore.setLongitude(randomLatLong.getLongitude()));
        break;
      default:
        jaroScores.forEach(jaroScore -> jaroScore.setLongitude(Double.parseDouble(longitude)));
    }

    put(KEY_LIST_OF_CREATED_JARO_SCORES, jaroScores);
    bulkAddressVerificationPage.inFrame(page ->
        page.uploadWaypointsData(jaroScores)
    );
  }

  @When("^Operator download sample CSV file on Bulk Address Verification page$")
  public void operatorDownloadSampleCsvFile() {
    bulkAddressVerificationPage.downloadSampleCsv.click();
  }

  @Then("^sample CSV file on Bulk Address Verification page is downloaded successfully$")
  public void operatorVerifySampleCsvFileIsDownloadedSuccessfully() {
    retryIfAssertionErrorOccurred(() -> {
      bulkAddressVerificationPage.verifyFileDownloadedSuccessfully("sample_csv.csv",
          "\"waypoint\",\"latitude\",\"longitude\"\n"
              + "5259518,1.32323,103.1212");
    }, "verify csv file downloaded successfully");

  }
}
