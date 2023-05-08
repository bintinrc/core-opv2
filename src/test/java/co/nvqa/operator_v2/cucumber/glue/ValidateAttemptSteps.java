package co.nvqa.operator_v2.cucumber.glue;


import co.nvqa.operator_v2.selenium.page.ValidateAttemptPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;

/**
 * @author SathishKumar
 */
@ScenarioScoped/**/
public class ValidateAttemptSteps extends AbstractSteps {

  private ValidateAttemptPage validateAttemptPage;

  public ValidateAttemptSteps() {
  }

  @Override
  public void init() {
    validateAttemptPage = new ValidateAttemptPage(getWebDriver());
  }


  @When("Operator selects the date time range based on below data:")
  public void operatorSelectsTheDateTimeRangeBasedOnBelowData(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String starteDate = mapOfData.get("startDate");
    String endDate = mapOfData.get("endDate");
    validateAttemptPage.selectDateTime(starteDate, endDate);
    takesScreenshot();
  }

  @Then("Operator is redirected to Validate Delivery or Pickup Attempt page")
  public void operatorIsRedirectedToValidateDeliveryOrPickupAttemptPage() {
    validateAttemptPage.validatePODPageHeadingText();
    takesScreenshot();
  }

  @When("Operator click {string} button")
  public void operatorClickButton(String buttonText) {
    validateAttemptPage.clickButton(buttonText);
  }

  @When("Operator filters the PODs based on below criteria")
  public void operatorFiltersThePODsBasedOnBelowCriteria(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String job = mapOfData.get("job");
    String status = mapOfData.get("status");
    String cod = mapOfData.get("cod");
    String rts = mapOfData.get("rts");
    String startDate = mapOfData.get("startDate");
    String endDate = mapOfData.get("endDate");
    String hub = mapOfData.get("hub");
    String driverName = mapOfData.get("driverName");
    String masterShipperName = mapOfData.get("masterShipperName");
    String masterShipperIds = mapOfData.get("masterShipperIds");
    String trackingIds = mapOfData.get("trackingIds");

    validateAttemptPage.switchToFrame();
    if (StringUtils.isNotBlank(job)) {
      validateAttemptPage.selectJob(job);
    }
    if (StringUtils.isNotBlank(status)) {
      validateAttemptPage.selectStatus(status);
    }
    if (StringUtils.isNotBlank(cod)) {
      validateAttemptPage.selectCOD(cod);
    }
    if (StringUtils.isNotBlank(rts)) {
      validateAttemptPage.selectRTS(rts);
    }
    validateAttemptPage.selectDateTime(startDate, endDate);
    if (StringUtils.isNotBlank(hub)) {
      validateAttemptPage.selectHub(hub);
    }
    if (StringUtils.isNotBlank(driverName)) {
      validateAttemptPage.selectDriver(driverName);
    }
    if (StringUtils.isNotBlank(masterShipperName)) {
      validateAttemptPage.selectMasterShipper(masterShipperName);
    }
    if (StringUtils.isNotBlank(masterShipperIds)) {
      validateAttemptPage.enterMasterShipperIds(masterShipperIds);
    }
    pause5s();
    validateAttemptPage.clickButton("Start Validating");
    takesScreenshot();
  }

  @When("Operator filters the PODs based on trackingIds")
  public void operatorFiltersThePODsBasedOnTrackingIds(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String trackingIds = mapOfData.get("trackingIds");
    if (StringUtils.isNotBlank(trackingIds)) {
      validateAttemptPage.switchToFrame();
      validateAttemptPage.clickButton("Filter by Tracking IDs");
      validateAttemptPage.enterTrackingIds(trackingIds);
      validateAttemptPage.clickButton("Filter & Validate");
    }
  }


  @Then("Operator validates current URL ends with {string}")
  public void operatorValidatesCurrentURLEndsWith(String expectedURL) {
    validateAttemptPage.verifyCurrentPageURL(expectedURL);
    takesScreenshot();
  }

  @Then("Operator validate {string} Modal is displayed")
  public void operatorValidateModalIsDisplayed(String modalTitle) {
    validateAttemptPage.validateModalTitle(modalTitle);
    takesScreenshot();
  }


  @When("Operator selects the Invalid Attempt Reason {string}")
  public void operatorSelectsTheInvalidAttemptReason(String invalidAttemptReason) {
    validateAttemptPage.selectInvalidAttemptReasonValue(invalidAttemptReason);
    takesScreenshot();
  }

  @Then("Operator verifies the following details in the POD validate details page")
  public void operatorVerifiesTheFollowingDetailsInThePODValidateDetailsPage(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String trackingId = mapOfData.get("trackingId");
    String failureReason = mapOfData.get("failureReason");
    String transactionStatus = mapOfData.get("transactionStatus");
    String attemptDateTime = mapOfData.get("attemptDateTime");
    String cod = mapOfData.get("cod");
    String shipperName = mapOfData.get("shipperName");
    String latitude = mapOfData.get("latitude");
    String longitude = mapOfData.get("longitude");
    String address1 = mapOfData.get("address1");
    String address2 = mapOfData.get("address2");
    String postcode = mapOfData.get("postcode");
    String distanceFromWaypoint = mapOfData.get("distanceFromWaypoint");
    String phone = mapOfData.get("phone");
    String relationship = mapOfData.get("relationship");
    String code = mapOfData.get("code");

    if (StringUtils.isNotBlank(trackingId)) {
      validateAttemptPage.validateTrackingId(trackingId);
    }
    if (StringUtils.isNotBlank(failureReason)) {
      validateAttemptPage.validateFailureReason(failureReason);
    }
    if (StringUtils.isNotBlank(transactionStatus)) {
      validateAttemptPage.validateTransactionStatus(transactionStatus);
    }
    if (StringUtils.isNotBlank(attemptDateTime)) {
      validateAttemptPage.validateAttemptDateTime(attemptDateTime);
    }
    if (StringUtils.isNotBlank(cod)) {
      validateAttemptPage.validateCOD(cod);
    }
    if (StringUtils.isNotBlank(shipperName)) {
      validateAttemptPage.validateShipperName(shipperName);
    }
    if (StringUtils.isNotBlank(longitude)) {
      validateAttemptPage.validateLatitudeLongitude(latitude, longitude);
    }
    if (StringUtils.isNotBlank(address1) && StringUtils.isNotBlank(address2)
        && StringUtils.isNotBlank(postcode)) {
      validateAttemptPage.validateAddress(address1, address2, postcode);
    }
    if (StringUtils.isNotBlank(distanceFromWaypoint)) {
      validateAttemptPage.validateDistance(distanceFromWaypoint);
    }
    if (StringUtils.isNotBlank(phone)) {
      validateAttemptPage.validatePhone(phone);
    }
    if (StringUtils.isNotBlank(relationship)) {
      validateAttemptPage.validateRelationship(relationship);
    }
    if (StringUtils.isNotBlank(code)) {
      validateAttemptPage.validateCode(code);
    }
    takesScreenshot();

  }
}