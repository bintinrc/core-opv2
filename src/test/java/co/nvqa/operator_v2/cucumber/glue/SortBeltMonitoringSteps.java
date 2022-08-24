package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.sort.sort_vendor.ParcelDownloadConfig;
import co.nvqa.operator_v2.selenium.page.SortBeltMonitoringPage;
import co.nvqa.operator_v2.selenium.page.SortBeltMonitoringPage.SessionItem;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.assertj.core.api.Assertions;
import java.util.List;
import org.hamcrest.Matchers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@ScenarioScoped
public class SortBeltMonitoringSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(SortBeltMonitoringPage.class);

  private SortBeltMonitoringPage sortBeltMonitoringPage;

  private static final String END_TIME_FILTER = "end time";
  private static final String START_TIME_FILTER = "start time";
  private static final String DEVICE_FILTER = "device";
  private static final String HUB_FILTER = "hub";
  private static final String TRACKING_ID_FILTER = "tracking id";
  private static final String ARM_ID_FILTER = "arm id";

  @Override
  public void init() {
    sortBeltMonitoringPage = new SortBeltMonitoringPage(getWebDriver());
  }

  @And("Operator waits until sort belt monitoring page loaded")
  public void operatorWaitUntilSortBeltMonitoringPageLoaded() {
    sortBeltMonitoringPage.switchTo();
    sortBeltMonitoringPage.waitUntilLoaded();
  }

  @And("Operator clears all search fields")
  public void operatorClearAllFields() {
    sortBeltMonitoringPage.clearAllFields();
  }

  @When("Operator searches {string} with {string}")
  public void operatorSearchWithValue(String searchType, String searchValue) {
    switch (searchType) {
      case HUB_FILTER:
        sortBeltMonitoringPage.enterHubIDOrName(searchValue);
        break;
      case DEVICE_FILTER:
        sortBeltMonitoringPage.enterDeviceIDOrName(searchValue);
        break;
      case TRACKING_ID_FILTER:
        sortBeltMonitoringPage.enterTrackingID(searchValue);
        break;
      case ARM_ID_FILTER:
        sortBeltMonitoringPage.enterArmID(searchValue);
        break;
      default:
        LOGGER.warn("Search type is not found");
    }
  }

  @When("Operator searches with created TID")
    public void operatorSearchCreatedTID(){
      operatorSearchWithValue(TRACKING_ID_FILTER, get(KEY_CREATED_ORDER_TRACKING_ID));
  }

  @When("Operator searches with {string} created TIDs")
  public void operatorSearchCreatedTIDs(String numberOfTIDs){
    Integer numberTIDs = Integer.parseInt(numberOfTIDs);
    List<ParcelDownloadConfig> parcelDownloadConfigs = get(KEY_LIST_OF_SORT_BELT_DOWNLOADED_PARCEL_CONFIGS);
    List<String> createdTrackingIDs = new ArrayList<String>();

    for(int i = 0; i < numberTIDs; i++) {
      operatorSearchWithValue(TRACKING_ID_FILTER, parcelDownloadConfigs.get(i).getTrackingId());
      createdTrackingIDs.add(parcelDownloadConfigs.get(i).getTrackingId());
    }

    put(KEY_LIST_OF_SORT_BELT_PARCEL_TRACKING_ID, createdTrackingIDs);
  }

  @When("Operator searches with created ArmID")
  public void operatorSearchCreatedArmID(){
    List<Integer> createdArmTargets = get(KEY_LIST_OF_CREATED_SORT_BELT_PARCEL_ARM_ID);
    operatorSearchWithValue(ARM_ID_FILTER, String.valueOf(createdArmTargets.get(0)));
    put(KEY_CREATED_SORT_BELT_PARCEL_ARM_ID, createdArmTargets.get(0).toString());
  }

  @When("Operator selects {string} as {string}")
  public void operatorSelectDate(String typeOfDate, String value) {
    switch (typeOfDate) {
      case START_TIME_FILTER:
        sortBeltMonitoringPage.setFromDate(value);
        break;
      case END_TIME_FILTER:
        sortBeltMonitoringPage.setToDate(value);
        break;
      default:
        LOGGER.warn("Cannot select date picker");
    }
  }

  @When("Operator selects created session")
  public void selectCreatedSession(){
    sortBeltMonitoringPage.selectSessionItemByName(get(KEY_CREATED_SESSION_ID));
  }

  @When("Operator selects first session")
  public void selectFirstSession() {
    sortBeltMonitoringPage.selectSessionItemByIndex(0);
  }

  @When("Operator selects session name {string}")
  public void selectSessionByName(String sessionName) {
    sortBeltMonitoringPage.selectSessionItemByName(sessionName);
  }

  @Then("Operator verifies sort belt monitoring result has {string} matched search term {string}")
  public void verifySortBeltMonitoringSearchResult(String searchType, String searchValue) {
    List<SessionItem> listSessions = sortBeltMonitoringPage.listSessionItems;
    Assertions.assertThat(listSessions.size())
        .as("Sort Belt Monitoring contains the search result")
        .isNotEqualTo(0);

    listSessions.forEach(
        session -> {
          String searchText = "";
          switch (searchType) {
            case HUB_FILTER:
              searchText = session.hubText.getText();
              break;
            case DEVICE_FILTER:
              searchText = session.deviceText.getText();
              break;
            default:
              LOGGER.warn("Search type is not found");
          }
          Assertions.assertThat(searchText)
              .as(String.format("Sort Belt Session of: \"%s\" - [%s] is displayed.", searchType,
                  searchValue))
              .contains(searchValue);
        });
  }

  @Then("Operator verifies Start time after {string}")
  public void operatorVerifiesStartTime(String from) {
    List<SessionItem> listSessions = sortBeltMonitoringPage.listSessionItems;
    Assertions.assertThat(listSessions.size())
        .as("Sort Belt Monitoring contains the search result")
        .isNotEqualTo(0);

    listSessions.forEach(
        session -> {
          try {
            Date actualStartTime = session.getStartTime();
            Date expectedStartTime = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(from);
            Assertions.assertThat(actualStartTime).isAfterOrEqualTo(expectedStartTime)
                .as("Sort Belt Session is after: " + from);
          } catch (ParseException e) {
            e.printStackTrace();
          }
        });
  }

  @Then("Operator verifies Completed time before {string}")
  public void operatorVerifiesCompletedTime(String to) {
    List<SessionItem> listSessions = sortBeltMonitoringPage.listSessionItems;
    listSessions.forEach(
        session -> {
          try {
            Date actualCompletedTime = session.getCompletedTime();
            Date expectedCompletedTime = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(to);
            Assertions.assertThat(actualCompletedTime).isBeforeOrEqualTo(expectedCompletedTime)
                .as("Sort Belt Session is before: " + to);
          } catch (ParseException e) {
            e.printStackTrace();
          }
        });
  }

  @Then("Operator verifies sort belt monitoring result has tracking ids displayed as below:")
  public void operatorVerifyTrackingIDs(List<String> expectedTIDs) {
    expectedTIDs = resolveValues(expectedTIDs);
    List<String> actualTIDs = sortBeltMonitoringPage.getListOfTrackingIDs();
    this.assertThat("List of Tracking IDs", actualTIDs,
        Matchers.hasItems(expectedTIDs.toArray(new String[0])));
  }

  @Then("Operator verifies sort belt monitoring result has tracking ids displayed correctly")
  public void operatorVerifyCreatedTrackingIDs() {
    List<String> expectedTIDs = get(KEY_LIST_OF_SORT_BELT_PARCEL_TRACKING_ID);
    List<String> actualTIDs = sortBeltMonitoringPage.getListOfTrackingIDs();
    this.assertThat("Verify List of Tracking IDs displayed", actualTIDs,
        Matchers.hasItems(expectedTIDs.toArray(new String[0])));
  }

  @Then("Operator verifies sort belt monitoring result has tracking id displayed")
  public void operatorVerifyTrackingID() {
    String actualTID = sortBeltMonitoringPage.getListOfTrackingIDs().get(0);
    this.assertEquals("Verify Tracking ID displayed", get(KEY_CREATED_ORDER_TRACKING_ID), actualTID);
  }

  @Then("Operator verifies sort belt monitoring result has expected arm id displayed")
  public void operatorVerifyArmID() {
    operatorVerifyArmID(get(KEY_CREATED_SORT_BELT_PARCEL_ARM_ID));
  }

  @Then("Operator verifies sort belt monitoring result has arm ids matched {string}")
  public void operatorVerifyArmID(String expectedArmID) {
    List<String> actualArmIDs = sortBeltMonitoringPage.getListOfArmIDs();
    actualArmIDs.forEach(armID -> Assertions.assertThat(
            armID.contains(expectedArmID))
        .as("Verify list of ArmID contains: " + expectedArmID)
        .isTrue());
  }

  @Then("Operator verifies there is no results displayed in session list")
  public void verifyNoResultInSessionList() {
    Assertions.assertThat(sortBeltMonitoringPage.emptySessionListText.isDisplayed())
        .as("Sort Belt Monitoring has no data in session list")
        .isTrue();
  }

  @Then("Operator verifies sessions displayed in session list")
  public void verifyResultsInSessionList() {
    List<SessionItem> listSessions = sortBeltMonitoringPage.listSessionItems;
    Assertions.assertThat(listSessions.size())
        .as("Sort Belt Monitoring contains the session list")
        .isNotEqualTo(0);
  }

  @Then("Operator verifies there is no results displayed in tracking list")
  public void verifyNoResultInTrackingList() {
    Assertions.assertThat(sortBeltMonitoringPage.emptyTrackingListText.isDisplayed())
        .as("Sort Belt Monitoring has no data in tracking list")
        .isTrue();
  }
}
