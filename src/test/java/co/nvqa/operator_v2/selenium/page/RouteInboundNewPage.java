package co.nvqa.operator_v2.selenium.page;


import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;


/**
 * @author Sathishkumar
 */
public class RouteInboundNewPage extends OperatorV2SimplePage {


  @FindBy(css = "iframe")
  private List<PageElement> pageFrame;

  @FindBy(xpath = "//h3[text()='Select hub for inbounding']//parent::div//following::div[@class='ant-select-selector']")
  public List<PageElement> modalHubSelection;

  @FindBy(xpath = "//h3[text()='Select hub for inbounding']//parent::div//following::div[@class='ant-select-selector']")
  public AntSelect2 hubs;

  @FindBy(xpath = "//div[contains(@class,'BaseTable__row-cell-text')]")
  public PageElement hubDropdownValue;

  @FindBy(id = "route-inbound_routeId-continue-button")
  public PageElement routeIdContinueButton;

  @FindBy(id = "route-inbound_scan-trackingId-continue-button")
  public PageElement trackingIdContinueButton;

  @FindAll(@FindBy(xpath = "//div[text()='Choose a route']"))
  public List<PageElement> chooseRouteModal;

  @FindBy(id = "round-inbound_search-driver-continue-button")
  public PageElement driverContinueButton;

  @FindBy(id = "round-inbound_routeId-input")
  public TextBox routeIdInput;

  @FindBy(id = "round-inbound_scan-trackingId-input")
  public TextBox trackingIdInput;

  @FindBy(xpath = "//h4[text()='Search by driver']//parent::div//following::div[@class='ant-select-selector']")
  public List<PageElement> modalDriverSelection;

  @FindBy(xpath = "//h4[text()='Search by driver']//parent::div//following::div[@class='ant-select-selector']")
  public AntSelect2 drivers;

  @FindBy(xpath = "//div[contains(@class,'BaseTable__row select-row')]")
  public PageElement driverDropdownValue;

  @FindBy(id = "route-inbound.confirmation-driver-has-arrived")
  public PageElement driverAttendanceYes;

  @FindBy(xpath = "//div[@class='ant-modal-title' and text()='Driver Attendance']")
  public PageElement driverAttendancePopupTitle;

  @FindBy(xpath = "//div[@class='ant-modal-body']//span[text()=\"Please click 'Yes' to confirm that the Driver has arrived\"]")
  public PageElement driverAttendancePopupMessage;

  @FindBy(xpath = "//label[text()='Route Id']//parent::div//span[2]")
  public PageElement routeIdInRouteSummary;

  @FindBy(xpath = "//label[text()='Driver']//parent::div//span[2]")
  public PageElement driverInRouteSummary;

  @FindBy(xpath = "//label[text()='Hub']//parent::div//span[2]")
  public PageElement hubInRouteSummary;

  @FindBy(xpath = "//label[text()='Date']//parent::div//span[2]")
  public PageElement dateInRouteSummary;

  @FindBy(xpath = "//p[@data-testid='route-inbound-result_pending-details']")
  public PageElement pendingWaypointPerformance;

  @FindBy(xpath = "//p[@data-testid='route-inbound-result_partial-details']")
  public PageElement partialWaypointPerformance;

  @FindBy(xpath = "//p[@data-testid='route-inbound-result_failed-details']")
  public PageElement failedWaypointPerformance;

  @FindBy(xpath = "//p[@data-testid='route-inbound-result_success-details']")
  public PageElement completedWaypointPerformance;

  @FindBy(xpath = "//div[@data-testid='route-inbound-result_waypoint-performance-total-details']//p")
  public PageElement totalWaypointPerformance;

  @FindBy(xpath = "//div[text()='Success Rate']//parent::a//p")
  public PageElement successRateWaypointPerformance;

  @FindBy(xpath = "//div[@data-testid='route-inbound-result_collection-summary-cash-inbound-details']//p")
  public PageElement cashCollectionSummary;

  @FindBy(xpath = "//div[@data-testid='route-inbound-result_collection-summary-failed-parcels-details']//p")
  public PageElement failedparcelsCollectionSummary;

  @FindBy(xpath = "//div[@data-testid='route-inbound-result_collection-summary-c2c-returns-details']//p")
  public PageElement C2CPlusReturnCollectionSummary;

  @FindBy(xpath = "//div[@data-testid='route-inbound-result_collection-summary-reservations-details']//p")
  public PageElement reservationCollectionSummary;

  @FindBy(id = "station-route-inbound-result_continue-to-inbound-button")
  public PageElement continueToInbound;

  @FindBy(xpath = "//div[text()='Choose a route']")
  public List<PageElement> chooseRouteWindow;

  @FindBy(xpath = "//h2[text()='Route Summary']")
  public PageElement routeSummaryHeadingText;


  public RouteInboundNewPage(WebDriver webDriver) {
    super(webDriver);

  }

  public void switchToFrame() {
    pause5s();
    if (pageFrame.size() > 0) {
      waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
      getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }
  }

  public void selectHub(String hubName) {
    switchToFrame();
    if (modalHubSelection.size() == 0) {
      refreshPage_v1();
      pause9s();
    }
    hubs.enterSearchTerm(hubName);
    pause3s();
    hubDropdownValue.click();
    webDriver.findElement(
            By.cssSelector("input.ant-select-search__field,input.ant-select-selection-search-input"))
        .sendKeys(Keys.TAB);
  }

  public void selectDriver(String hubName) {
    switchToFrame();
    if (modalDriverSelection.size() == 0) {
      refreshPage_v1();
      pause9s();
    }
    drivers.enterSearchTerm(hubName);
    pause3s();
    driverDropdownValue.click();
    webDriver.findElement(
            By.cssSelector("input.ant-select-search__field,input.ant-select-selection-search-input"))
        .sendKeys(Keys.TAB);
  }

  public void fetchRouteByRouteId(String hubName, String routeId) {
    waitUntilInvisibilityOfToast(false);
    waitWhilePageIsLoading(120);
    selectHub(hubName);
    routeIdInput.setValue(routeId);
    routeIdContinueButton.click();
  }

  public void fetchRouteByTrackingId(String hubName, String trackingId) {
    waitUntilInvisibilityOfToast(false);
    waitWhilePageIsLoading(120);
    selectHub(hubName);
    trackingIdInput.setValue(trackingId);
    trackingIdContinueButton.click();
  }

  public void chooseRoute(String routeId) {
    String xpath = f("//td[text()='%s']//parent::tr//button", routeId);
    waitUntilVisibilityOfElementLocated(xpath);
    getWebDriver().findElement(By.xpath(xpath)).click();
  }

  public void fetchRouteByDriver(String hubName, String routeId) {
    waitUntilInvisibilityOfToast(false);
    waitWhilePageIsLoading(120);
    selectHub(hubName);
    selectDriver(routeId);
    driverContinueButton.click();
  }

  public void validateDriverAttendanceDialogMessage() {
    pause5s();
    Assertions.assertThat(driverAttendancePopupTitle.isDisplayed())
        .as("Validation for Driver Attendance popup window title")
        .isTrue();
    Assertions.assertThat(driverAttendancePopupMessage.isDisplayed())
        .as("Validation for Driver Attendance popup window message")
        .isTrue();
  }

  public void confirmDriverAttendance() {
    if (driverAttendanceYes.waitUntilVisible(5)) {
      pause500ms();
      driverAttendanceYes.click();
    }
  }

  public void validateRouteSummaryText() {
    switchToFrame();
    routeSummaryHeadingText.waitUntilVisible(5);
    pause5s();
    Assertions.assertThat(routeSummaryHeadingText.isDisplayed())
        .as("Validation for route Id in the route summary")
        .isTrue();
  }

  public void validateDriverRouteSummary(String routeId, String driverName, String hubName,
      String date) {
    switchToFrame();
    Assertions.assertThat(routeIdInRouteSummary.getText())
        .as("Validation for route Id in the route summary")
        .isEqualTo(routeId);
    Assertions.assertThat(driverInRouteSummary.getText())
        .as("Validation for driver name in the route summary")
        .isEqualTo(driverName);
    Assertions.assertThat(hubInRouteSummary.getText())
        .as("Validation for hub name in the route summary")
        .isEqualTo(hubName);
    Assertions.assertThat(dateInRouteSummary.getText())
        .as("Validation for route date in the route summary")
        .isEqualTo(date);
  }

  public void validateWaypointPeformance(String pending, String partial, String failed
      , String completed, String total, String successRate) {
    switchToFrame();
    Assertions.assertThat(pendingWaypointPerformance.getText())
        .as("Validation for pending in the Waypoint Peformance")
        .isEqualTo(pending);
    Assertions.assertThat(partialWaypointPerformance.getText())
        .as("Validation for partial in the Waypoint Peformance")
        .isEqualTo(partial);
    Assertions.assertThat(failedWaypointPerformance.getText())
        .as("Validation for failed in the Waypoint Peformance")
        .isEqualTo(failed);
    Assertions.assertThat(completedWaypointPerformance.getText())
        .as("Validation for completed in the Waypoint Peformance")
        .isEqualTo(completed);
    Assertions.assertThat(totalWaypointPerformance.getText())
        .as("Validation for total in the Waypoint Peformance")
        .isEqualTo(total);
    Assertions.assertThat(successRateWaypointPerformance.getText())
        .as("Validation for successRate in the Waypoint Peformance")
        .isEqualTo(successRate);
  }

  public void validateCollectionSummary(String cash, String failedParcels, String c2cplusReturn,
      String reservations) {
    switchToFrame();
    Assertions.assertThat(cashCollectionSummary.getText())
        .as("Validation for cash in the collection summary")
        .isEqualTo(cash);
    Assertions.assertThat(failedparcelsCollectionSummary.getText())
        .as("Validation for failed parcels in the collection summary")
        .isEqualTo(failedParcels);
    Assertions.assertThat(C2CPlusReturnCollectionSummary.getText())
        .as("Validation for C2CPlusReturn in the collection summary")
        .isEqualTo(c2cplusReturn);
    Assertions.assertThat(reservationCollectionSummary.getText())
        .as("Validation for reservation in the collection summary")
        .isEqualTo(reservations);
  }

  public void validateProblematicParcelDetails(String rowNumber, String trackingId,
      String shipperName, String location,
      String type, String issue) {
    switchToFrame();
    Assertions.assertThat(
            getWebDriver().findElement(
                By.xpath("//div[@data-testid='route-inbound-result_problematic-table']"
                    + "//tbody/tr[" + rowNumber + "]//td[2]")).getText())
        .as("Validation for Tracking ID in the problematic parcel details")
        .isEqualTo(trackingId);
    Assertions.assertThat(
            getWebDriver().findElement(
                By.xpath("//div[@data-testid='route-inbound-result_problematic-table']"
                    + "//tbody/tr[" + rowNumber + "]//td[3]")).getText())
        .as("Validation for Shipper Name in the problematic parcel details")
        .isEqualTo(shipperName);
    Assertions.assertThat(
            getWebDriver().findElement(
                By.xpath("//div[@data-testid='route-inbound-result_problematic-table']"
                    + "//tbody/tr[" + rowNumber + "]//td[4]")).getText())
        .as("Validation for Location in the problematic parcel details")
        .isEqualTo(location);
    Assertions.assertThat(
            getWebDriver().findElement(
                By.xpath("//div[@data-testid='route-inbound-result_problematic-table']"
                    + "//tbody/tr[" + rowNumber + "]//td[5]")).getText())
        .as("Validation for Type in the problematic parcel details")
        .isEqualTo(type);
    Assertions.assertThat(
            getWebDriver().findElement(
                By.xpath("//div[@data-testid='route-inbound-result_problematic-table']"
                    + "//tbody/tr[" + rowNumber + "]//td[6]")).getText())
        .as("Validation for issue in the problematic parcel details")
        .isEqualTo(issue);
  }

  public void clickContinueToInboundButton() {
    switchToFrame();
    waitUntilVisibilityOfElementLocated(continueToInbound.getWebElement());
    continueToInbound.click();
  }

  public void validationOfErrorToastMessage(String message) {
    pause2s();
    String Xpath = "//div[text()='" + message + "']";
    WebElement errorToastMessage = getWebDriver().findElement(By.xpath(Xpath));
    Assertions.assertThat(errorToastMessage.isDisplayed())
        .as("Validation for Toast Message is displayed").isTrue();
  }

  public void openRoute(String routeId) {
    pause5s();
    if (chooseRouteWindow.size() > 0) {
      List<WebElement> routeIds = drivers.findElementsByXpath(
          "//div[@class='ant-modal-body']//tr//td[1]");
      for (WebElement route : routeIds) {
        if (route.getText().equalsIgnoreCase(routeId)) {
          route.click();
          break;
        }
      }
    }
  }


}




