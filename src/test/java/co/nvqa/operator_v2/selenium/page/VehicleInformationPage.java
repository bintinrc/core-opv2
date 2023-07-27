package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.mm.model.Vehicle;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.util.TestUtils;
import java.util.List;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VehicleInformationPage extends OperatorV2SimplePage{
  private static final Logger LOGGER = LoggerFactory.getLogger(VehicleInformationPage.class);

  private static final String VEHICLE_NUMBER_TABLE_XPATH = "//td[@class='vehicle_number']";
  private static final String VEHICLE_NUMBER_TABLE_WITH_VALUE_XPATH = "//td[@class='vehicle_number' and text()='%s']";
  private static final String TRUCK_TYPE_RELATIVE_TABLE_XPATH = "%s/following-sibling::td[@class='truck_type']/span/span";
  private static final String ERROR_NOTIFICATION_XPATH = "//div[contains(@class,'ant-notification')]//div[@class='ant-notification-notice-description']//span[contains(normalize-space(), \"%s\")]";
  private static final String MAX_SEARCH_VEHICLE_EXCEEDED_TEXT = "'SearchVehicleRequest.Data' Error:Field validation for 'Data' failed on the 'max' tag";
  private static final String INVALID_VEHICLE_NUMBER_DIALOG_XPATH = "//div[contains(@class,'ant-modal-body') and contains(text(),'No valid vehicle number found. Please recheck your entries.')]";
  private static final String INVALID_VEHICLE_NUMBER_ALERT_XPATH = "//div[contains(@class,'ant-alert-error')]//div[contains(text(),'%d vehicle numbers you searched cannot be found.')]";
  private static final String INVALID_VEHICLE_NUMBER_LIST_XPATH = "//div[contains(@class,'ant-modal-body')]/div/div";
  private static final String INVALID_VEHICLE_NUMBER_MODAL_TITLE_XPATH = "//div[contains(@class,'ant-modal-title') and text()='Not Found']";

  @FindBy(xpath = "//h4[contains(text(), 'Search by Vehicle Number')]")
  private PageElement searchByVehicleNumberText;

  @FindBy(xpath = "//h4[contains(text(), 'Search by Vehicle Type')]")
  private PageElement searchByVehicleTypeText;

  @FindBy(xpath = "//textarea[@data-testid='vehicle-number-textarea']")
  private TextBox searchByVehicleNumberTextarea;

  @FindBy(xpath = "//button[@data-testid='search-by-vehicle-number-button']")
  private Button searchByVehicleNumberButton;

  @FindBy(xpath = "//button[@data-testid='search-by-vehicle-type-button']")
  private Button searchByVehicleTypeButton;

  @FindBy(xpath = "//div[@data-testid='vehicle-result-table-container']")
  private PageElement vehicleResultTableContainer;

  @FindBy(xpath = "//div[@data-testid='vehicle-result-table-container']//div[contains(@class,'use-fixed-scroll')]")
  private PageElement vehicleResultTableScrollable;

  @FindBy(xpath = "//div[text()='End of Table']")
  private PageElement endOfTable;

  @FindBy(xpath = "//div[@data-testid='vehicle-number-counter']")
  private PageElement vehicleNumberCounter;

  @FindBy(xpath = "(//div[contains(@class,'ant-alert-error')]//div[contains(@class,'ant-col')])[2]")
  private Button viewNotFoundVehicleNumber;

  public VehicleInformationPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void verifyPageIsLoaded() {
    switchTo();
    searchByVehicleNumberText.waitUntilVisible();
    searchByVehicleTypeText.waitUntilVisible();

    Assertions.assertThat(searchByVehicleNumberText.isDisplayed() && searchByVehicleTypeText.isDisplayed())
        .as("Vehicle Information page is loaded.")
        .isTrue();
  }

  public void scrollToBottomOfTable() {
    doWithRetry(() -> {
      TestUtils.callJavaScriptExecutor("arguments[0].scrollTop += 1000;", vehicleResultTableScrollable.getWebElement(), getWebDriver());

      Assertions.assertThat(endOfTable.waitUntilVisible(2))
          .as("End of table is reached.")
          .isTrue();
    }, "Scrolling down...", 1000, 20);
  }

  public void searchByVehicleNumbers(List<String> vehicleNumbers) {
    inputVehicleNumbers(vehicleNumbers);
    verifyVehicleCounterIs(vehicleNumbers.size());
    clickSearchVehicleBy("number");
  }

  public void inputVehicleNumbers(List<String> vehicleNumbers) {
    String vehicleNumbersAsSearchStr = String.join("\n", vehicleNumbers);

    searchByVehicleNumberTextarea.waitUntilVisible();
    searchByVehicleNumberTextarea.sendKeys(vehicleNumbersAsSearchStr);
  }

  public void verifyVehicleCounterIs(int vehicleSize) {
    Assertions.assertThat(vehicleNumberCounter.getText())
        .as("Vehicle counter is correct: %s", vehicleSize)
        .contains(f("%d entered", vehicleSize));
  }

  public void verifyVehicleCounterIs(String counterStr) {
    Assertions.assertThat(vehicleNumberCounter.getText())
        .as("Vehicle counter is correct: %s", counterStr)
        .contains(counterStr);
  }

  public void clickSearchVehicleBy(String by) {
    if (by.equalsIgnoreCase("number")) {
      searchByVehicleNumberButton.waitUntilClickable();
      searchByVehicleNumberButton.click();
    } else {
      searchByVehicleTypeButton.waitUntilClickable();
      searchByVehicleTypeButton.click();
    }
  }

  public void verifyVehicleResultTableContainerIsLoaded() {
    vehicleResultTableContainer.waitUntilVisible(60);
    Assertions.assertThat(vehicleResultTableContainer.isDisplayed())
        .as("Vehicle result table is loaded")
        .isTrue();
  }

  private List<Vehicle> mapVehiclesFromResultTable() {
    List<String> vehicleNumbers = findElementsByXpath(VEHICLE_NUMBER_TABLE_XPATH).stream().map(
        WebElement::getText).collect(Collectors.toList());

    return vehicleNumbers.stream().map(number -> {
      String truckType = getText(f(TRUCK_TYPE_RELATIVE_TABLE_XPATH, f(VEHICLE_NUMBER_TABLE_WITH_VALUE_XPATH, number)));
      return new Vehicle(number, truckType);
    }).collect(Collectors.toList());
  }

  public void verifyVehiclesAreOnVehicleResultTable(List<Vehicle> vehicles) {
    scrollToBottomOfTable();

    List<Vehicle> uiVehicles = mapVehiclesFromResultTable();
    vehicles.forEach(vehicle -> {
      boolean isMatch = uiVehicles.stream().anyMatch(uiVehicle -> uiVehicle.getVehicleNumber().equalsIgnoreCase(vehicle.getVehicleNumber()) && uiVehicle.getTruckType().equalsIgnoreCase(vehicle.getTruckType()));

      Assertions.assertThat(isMatch)
          .as("Vehicle number %s appears in table with truck type %s", vehicle.getVehicleNumber(), vehicle.getTruckType())
          .isTrue();
    });
  }

  public void verifyErrorNotificationForExceedingVehicleNumberIsDisplayed() {
    waitUntilVisibilityOfElementLocated(f(ERROR_NOTIFICATION_XPATH, MAX_SEARCH_VEHICLE_EXCEEDED_TEXT));
    Assertions.assertThat(isElementVisible(f(ERROR_NOTIFICATION_XPATH, MAX_SEARCH_VEHICLE_EXCEEDED_TEXT)))
        .as("Error notification contains: %s", MAX_SEARCH_VEHICLE_EXCEEDED_TEXT)
        .isTrue();
  }

  public void verifyInvalidVehicleNumberDialogIsDisplayed() {
    waitUntilVisibilityOfElementLocated(INVALID_VEHICLE_NUMBER_DIALOG_XPATH);
    Assertions.assertThat(isElementVisible(INVALID_VEHICLE_NUMBER_DIALOG_XPATH))
        .as("Invalid vehicle number dialog is displayed")
        .isTrue();
  }

  public void verifyInvalidVehicleNumberAlertIsDisplayed(int numberOfInvalidVehicles) {
    waitUntilVisibilityOfElementLocated(f(INVALID_VEHICLE_NUMBER_ALERT_XPATH, numberOfInvalidVehicles));
    Assertions.assertThat(isElementVisible(f(INVALID_VEHICLE_NUMBER_ALERT_XPATH, numberOfInvalidVehicles)))
        .as("Invalid vehicle number alert is showing: %d invalid vehicle numbers", numberOfInvalidVehicles)
        .isTrue();
  }

  public void verifyListOfInvalidVehicleNumbers(List<String> invalidVehicleNumbers) {
    List<String> uiInvalidVehicleNumbers = findElementsByXpath(INVALID_VEHICLE_NUMBER_LIST_XPATH).stream()
        .map(WebElement::getText)
        .collect(Collectors.toList());

    Assertions.assertThat(uiInvalidVehicleNumbers)
        .as("Correct invalid vehicle numbers is displayed: %s", String.join(", ", uiInvalidVehicleNumbers))
        .containsExactlyElementsOf(invalidVehicleNumbers);
  }

  public void clickViewNotFoundVehicleNumbers() {
    viewNotFoundVehicleNumber.click();
    waitUntilVisibilityOfElementLocated(INVALID_VEHICLE_NUMBER_MODAL_TITLE_XPATH);
  }
}
