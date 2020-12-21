package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class SortBeltManagerPage extends OperatorV2SimplePage {

  private static final String IFRAME_XPATH = "//iframe[contains(@src,'sort-belt-manager')]";
  private static final String TOGGLE_XPATH = "//span[text() = '%s']/ancestor::div/button[@role='switch']";
  private static final String FILTER_XPATH = "//span[text() = '%s']/ancestor::div[contains(@class, 'styles__Arm')]//div[@class='ant-select-selection__rendered']//span[contains(text(), '%s')]/ancestor::div[@class='ant-select-selection__rendered']";
  private static final String FILTER_INPUT_XPATH = "//span[text() = '%s']/ancestor::div[contains(@class, 'styles__Arm')]//div[@class='ant-select-selection__rendered']//span[contains(text(), '%s')]/ancestor::div[@class='ant-select-selection__rendered']//input[@class='ant-select-search__field']";
  private static final String ADD_COMBINATION_XPATH = "//span[text() = '%s']/ancestor::div[contains(@class, 'styles__Arm')]//button//span[text() = 'Add Combination']";

  @FindBy(xpath = "(//div[@class='ant-select-selection__rendered'])[1]")
  public AntSelect selectHub;

  @FindBy(xpath = "(//div[@class='ant-select-selection__rendered'])[2]")
  public AntSelect selectDeviceId;

  @FindBy(xpath = "//button/span[contains(text(), 'Proceed')]")
  public Button proceed;

  @FindBy(xpath = "//button/span[contains(text(), 'Create Configuration')]")
  public Button create;

  @FindBy(xpath = "(//div[@class='ant-select-selection__rendered'])[2]")
  public AntSelect selectFirstFilter;

  @FindBy(xpath = "(//div[@class='ant-select-selection__rendered'])[3]")
  public AntSelect selectSecondFilter;

  @FindBy(xpath = "(//div[@class='ant-select-selection__rendered'])[4]")
  public AntSelect SelectThirdFilter;

  @FindBy(xpath = "//button/span[contains(text(), 'Confirm')]")
  public Button confirm;

  @FindBy(xpath = "(//input[@class='ant-input'])[1]")
  public PageElement nameInput;

  @FindBy(xpath = "(//input[@class='ant-input'])[2]")
  public PageElement descriptionInput;

  @FindBy(xpath = "//div[contains(@class,'NoResult')]/span")
  public PageElement noResult;

  @FindBy(xpath = "//div[contains(@class,'duplicate')]//th[contains(@class,'armOutput')]//input[@placeholder='Find...']")
  public PageElement find;

  @FindBy(xpath = "//div[contains(@class,'duplicate')]//span/mark[@class='highlight ']")
  public PageElement actualDuplicateArmOutput;

  @FindBy(xpath = "//div[contains(@class,'duplicate')]//td[@class='destinationHubDisplay']/span/span")
  public PageElement actualDuplicateDestinationHub;

  @FindBy(xpath = "//div[contains(@class,'duplicate')]//td[@class='orderTagDisplay']/span/span")
  public PageElement actualDuplicateOrderTag;

  public SortBeltManagerPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectHub(String hubName) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

    selectHub.waitUntilClickable();
    selectHub.jsClick();
    pause3s();

    selectHub.searchInput.sendKeys(hubName);
    selectHub.searchInput.sendKeys(Keys.RETURN);
  }


  public void selectDeviceId(String deviceId) {
    selectDeviceId.waitUntilClickable();
    selectDeviceId.jsClick();
    pause1s();

    selectDeviceId.searchInput.sendKeys(deviceId);
    selectDeviceId.searchInput.sendKeys(Keys.RETURN);
    proceed.waitUntilClickable();
    proceed.click();
  }

  public void clickCreateConfig() {
    create.click();
  }

  public void clickConfirm() {
    confirm.click();
  }

  public void selectFilters(String firstFilter, String secondFilter, String thirdFilter) {
    if (firstFilter != null) {
      selectFirstFilter.waitUntilClickable();
      selectFirstFilter.jsClick();
      pause1s();

      selectFirstFilter.searchInput.sendKeys(firstFilter);
      selectFirstFilter.searchInput.sendKeys(Keys.RETURN);
    }

    if (secondFilter != null) {
      selectSecondFilter.waitUntilClickable();
      selectSecondFilter.jsClick();
      pause1s();

      selectSecondFilter.searchInput.sendKeys(secondFilter);
      selectSecondFilter.searchInput.sendKeys(Keys.RETURN);
    }

    if (thirdFilter != null) {
      SelectThirdFilter.waitUntilClickable();
      SelectThirdFilter.jsClick();
      pause1s();

      SelectThirdFilter.searchInput.sendKeys(thirdFilter);
      SelectThirdFilter.searchInput.sendKeys(Keys.RETURN);
    }

    confirm.click();
  }

  public void inputName(String name, String description) {
    nameInput.sendKeys(name);
    descriptionInput.sendKeys(description);
    confirm.click();
  }

  public void verifyConfigNotCreated(String configName) {
    create.waitUntilClickable();
    selectHub.waitUntilClickable();
    selectHub.jsClick();
    pause1s();

    selectHub.searchInput.sendKeys(configName);
    assertThat("Result", noResult.getText(), equalToIgnoringCase("No Results Found"));
  }

  public void setFilter(String armNumber, String status, String destinationHubs, String orderTags) {
    if ("Disabled".equals(status)) {
      click(f(TOGGLE_XPATH, armNumber));
      pause1s();
    } else {
      if (destinationHubs != null) {
        selectFilter("Destination Hub", destinationHubs, armNumber);
      }
      if (orderTags != null) {
        selectFilter("Order Tag", orderTags, armNumber);
      }
    }
  }

  public void addCombination(String armNumber, String destinationHubs, String orderTags) {
    waitUntilElementIsClickable(f(ADD_COMBINATION_XPATH, armNumber));
    click(f(ADD_COMBINATION_XPATH, armNumber));

    if (destinationHubs != null) {
      addFilter("Destination Hub", destinationHubs, armNumber);
    }
    if (orderTags != null) {
      addFilter("Order Tag", orderTags, armNumber);
    }
  }

  public void selectFilter(String filterName, String value, String armNumber) {
    waitUntilElementIsClickable(f(FILTER_XPATH, armNumber, filterName));
    click(f(FILTER_XPATH, armNumber, filterName));
    pause1s();

    sendKeys(f(FILTER_INPUT_XPATH, armNumber, filterName), value + "\n");
  }

  public void addFilter(String filterName, String value, String armNumber) {
    waitUntilElementIsClickable(f(FILTER_XPATH, armNumber, filterName));
    click(f("(" + FILTER_XPATH, armNumber, filterName) + ")[2]");
    pause1s();

    sendKeys(f("(" + FILTER_INPUT_XPATH, armNumber, filterName) + ")[2]", value + "\n");
  }

  public void verifyDuplicateConfigIsExistAndDataIsCorrect(String armOutput, String destinationHubs,
      String orderTags) {
    find.sendKeys(armOutput);
    assertThat("Arm Output", actualDuplicateArmOutput.getText(), equalToIgnoringCase(armOutput));
    assertThat("Destination Hub", actualDuplicateDestinationHub.getText(),
        equalToIgnoringCase(destinationHubs));
    assertThat("Order Tag", actualDuplicateOrderTag.getText(), equalToIgnoringCase(orderTags));
  }
}