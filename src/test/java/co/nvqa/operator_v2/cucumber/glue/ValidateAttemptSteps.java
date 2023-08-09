package co.nvqa.operator_v2.cucumber.glue;


import co.nvqa.operator_v2.selenium.page.ValidateAttemptPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
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
    validateAttemptPage.switchToFrame();
    validateAttemptPage.selectDateTime(starteDate, endDate);
    takesScreenshot();
  }

  @Then("Operator is redirected to Validate Delivery or Pickup Attempt page and URL ends with {string}")
  public void operatorIsRedirectedToValidateDeliveryOrPickupAttemptPageAndURLEndsWith(String url) {
    validateAttemptPage.validatePODPageHeadingText();
    validateAttemptPage.verifyCurrentPageURL(url);
    takesScreenshot();
  }

  @When("Operator click {string} button")
  public void operatorClickButton(String buttonText) {
    validateAttemptPage.switchToFrame();
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
    String failureReason = mapOfData.get("failureReason");
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
      validateAttemptPage.selectDropdownValue("COD", cod);
    }
    if (StringUtils.isNotBlank(rts)) {
      validateAttemptPage.selectDropdownValue("RTS", rts);
    }
    validateAttemptPage.selectDateTime(startDate, endDate);
    if (StringUtils.isNotBlank(hub)) {
      validateAttemptPage.selectHub(hub);
    }
    if (StringUtils.isNotBlank(failureReason)) {
      validateAttemptPage.selectFailureReason(failureReason);
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
    pause2s();
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

  @Then("Operator validate filterByTackingId modal")
  public void operatorvalidateFilterByTackingIdModal() {
    validateAttemptPage.validatetrackingIDtextboxIsEmpty();
    validateAttemptPage.validateDisabledButton();
    validateAttemptPage.clickButton("Cancel");
  }

  @Then("Operator validate Enter Reason for invalid attempt modal {value}")
  public void OperatorValidateEnterReasonForInvalidAttemptModal(String trackingId) {
    validateAttemptPage.validateTrackingIdInInvalidAttemptModal(trackingId);
    validateAttemptPage.validateSaveReasonButtonIsDiabled();
    validateAttemptPage.clickButton("Cancel");
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

  @Then("Operator validate {string} text is displayed")
  public void operatorValidateTextIsDisplayed(String text) {
    validateAttemptPage.validateTextIsDisplayed(text);
    takesScreenshot();
  }


  @When("Operator selects the Invalid Attempt Reason {string}")
  public void operatorSelectsTheInvalidAttemptReason(String invalidAttemptReason) {
    validateAttemptPage.selectInvalidAttemptReasonValue(invalidAttemptReason);
    takesScreenshot();
  }

  @Then("Operator verifies the following details in the POD validate/audit/review details page")
  public void operatorVerifiesTheFollowingDetailsInThePODValidateDetailsPage(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String trackingId = mapOfData.get("trackingId");
    String failureReason = mapOfData.get("failureReason");
    String transactionStatus = mapOfData.get("transactionStatus");
    String attemptDateTime = mapOfData.get("attemptDateTime");
    String cod = mapOfData.get("cod");
    String shipperName = mapOfData.get("shipperName");
    String podPhoto = mapOfData.get("podPhoto");
    String podSignature = mapOfData.get("podSignature");
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
    if (StringUtils.isNotBlank(podPhoto)) {
      validateAttemptPage.validatePODPhoto();
    }
    if (StringUtils.isNotBlank(podSignature)) {
      validateAttemptPage.validatePODSignature();
    }
    if (StringUtils.isNotBlank(longitude)) {
      validateAttemptPage.validateLatitudeLongitude(latitude, longitude);
    }
    if (StringUtils.isNotBlank(address1) && StringUtils.isNotBlank(address2)
        && StringUtils.isNotBlank(postcode)) {
      validateAttemptPage.validateAddress(address1, address2, postcode);
    }
    if (StringUtils.isNotBlank(distanceFromWaypoint)) {
      validateAttemptPage.validateDistanceFromWaypiontIsDisplayed();
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

  @When("Operator get the count from the attempts validated today")
  public void operator_get_the_count_from_the_attempts_validated_today() {
    int beforeCount = validateAttemptPage.getAttemptsValidatedCount();
    put(KEY_ATTEMPTS_VALIDATED_TODAY, beforeCount);
    takesScreenshot();
  }

  @Then("Operator verifies that the count in attempts validated today has increased by {int}")
  public void operator_verifies_that_the_count_in_attempts_validated_today_has_increased_by(
      Integer totOrder) {
    pause3s();
    int beforeOrder = Integer.parseInt(getString(KEY_ATTEMPTS_VALIDATED_TODAY));
    int afterOrder = validateAttemptPage.getAttemptsValidatedCount();
    validateAttemptPage.validateCountValueMatches(beforeOrder, afterOrder, totOrder);
    takesScreenshot();
  }

  @Then("Operator validate the error code and error details")
  public void operatorValidateTheErrorCodeAndErrorMessage(
      Map<String, String> mapOfData) {
    String statusCode = mapOfData.get("statusCode");
    String url = mapOfData.get("url");
    mapOfData = resolveKeyValues(mapOfData);
    String message = mapOfData.get("message");
    String data = mapOfData.get("data");
    pause3s();
    if (StringUtils.isNotBlank(statusCode)) {
      validateAttemptPage.validate404StatusCode(statusCode);
    }
    if (StringUtils.isNotBlank(message)) {
      validateAttemptPage.validateErrorMessage(message);
    }
    if (StringUtils.isNotBlank(url)) {
      validateAttemptPage.validateURL(url);
    }
    if (StringUtils.isNotBlank(data)) {
      validateAttemptPage.validateDataInErrorMessage(data);
    }
    takesScreenshot();
  }

  @When("Operator closes the notification message")
  public void operatorClosesTheNotificationMessage() {
    validateAttemptPage.closeNotification();
    takesScreenshot();
  }

  @When("Operator loads Validate Validate Delivery or Pickup Attempt page")
  public void operatorLoadsValidateDeliveryOrPickupAttemptPage() {
    validateAttemptPage.loadValidateDeliveryOrPickAttemptPage();
  }

  @Then("Operator validate Pending assigned POD modal")
  public void operatorValidatePendingAssignedPODModal() {
    validateAttemptPage.validatePendingAssignedPODModal();
    takesScreenshot();
  }

  @And("Operator goes back on browser")
  public void operatorGoesBackOnBrowser() {
    validateAttemptPage.navigateBackInBrowser();
  }

  @When("Operator click back to task button")
  public void operatorClickbackToTaskButton() {
    validateAttemptPage.clickbackTotask();
  }

  @When("Operator filters the PODs to audit based on below criteria")
  public void operatorFiltersThePODsToAuditBasedOnBelowCriteria(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    String validatorName = mapOfData.get("validatorName");
    String startDate = mapOfData.get("startDate");
    String endDate = mapOfData.get("endDate");
    validateAttemptPage.switchToFrame();

    validateAttemptPage.selectDateTime(startDate, endDate);
    if (StringUtils.isNotBlank(validatorName)) {
      validateAttemptPage.selectValidator(validatorName);
    }

    pause2s();
    validateAttemptPage.clickButton("Start Auditing");
    takesScreenshot();
  }

  @Then("Operator verifies that the following texts are available in the POD validation report file {string}")
  public void operatorverifiesThatTheFollowingTextsAreAvailableInThePODValidationReportFile(
      String filePattern,
      List<String> expected) {
    expected = resolveValues(expected);
    String downloadedCsvFile = validateAttemptPage.getLatestDownloadedFilename(
        filePattern);
    expected.forEach(
        (expectedText) -> validateAttemptPage.verifyFileDownloadedSuccessfully(
            downloadedCsvFile,
            expectedText, true));
  }

}