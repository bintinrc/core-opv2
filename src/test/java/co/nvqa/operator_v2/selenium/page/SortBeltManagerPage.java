package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ArmCombination;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.md.MdSwitch;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class SortBeltManagerPage extends OperatorV2SimplePage {

  @FindBy(xpath = "(//div[contains(@class,'ant-select-enabled')])[1]")
  public AntSelect selectHub;

  @FindBy(xpath = "(//div[contains(@class,'ant-select-enabled')])[2]")
  public AntSelect selectDeviceId;

  @FindBy(xpath = "//button[.//span[contains(., 'Proceed')]]")
  public AntButton proceed;

  @FindBy(xpath = "//button[.//span[contains(., 'Create Configuration')]]")
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
  public TextBox nameInput;

  @FindBy(xpath = "(//input[@class='ant-input'])[2]")
  public TextBox descriptionInput;

  @FindBy(xpath = "//div[contains(@class,'NoResult')]/span")
  public PageElement noResult;

  @FindBy(xpath = "//div[contains(@class,'duplicate')]//th[contains(@class,'armOutput')]//input[@placeholder='Find...']")
  public PageElement find;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  public DuplicatedCombinationsTable duplicatedCombinationsTable;
  public UniqueCombinationsTable uniqueCombinationsTable;

  public SortBeltManagerPage(WebDriver webDriver) {
    super(webDriver);
    duplicatedCombinationsTable = new DuplicatedCombinationsTable(webDriver);
    uniqueCombinationsTable = new UniqueCombinationsTable(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
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

  public void verifyConfigNotCreated(String configName) {
    create.waitUntilClickable();
    selectHub.waitUntilClickable();
    selectHub.jsClick();
    pause1s();

    selectHub.searchInput.sendKeys(configName);
    assertThat("Result", noResult.getText(), equalToIgnoringCase("No Results Found"));
  }

  public ArmCombinationContainer getArmCombinationContainer(String armName) {
    String xpath = f("//div[contains(@class,'ArmCombinationContainer')][.//span[.='%s']]", armName);
    return new ArmCombinationContainer(getWebDriver(), xpath);
  }

  public static class ArmCombinationContainer extends PageElement {

    @FindBy(css = "button[class*='AddCombinationButton']")
    public Button addCombination;

    @FindBy(css = "button[class*='ArmSwitch']")
    public MdSwitch enable;

    public ArmCombinationContainer(WebDriver webDriver, String xpath) {
      super(webDriver, xpath);
    }

    public int getCombinationsCount() {
      return getElementsCountFast(By.cssSelector("div[class*='StyledRow']"));
    }

    public AntSelect getFilterSelect(String filterName, int index) {
      String xpath = f(
          "(.//div[contains(@class,'MultipleSelectFilterContainer')][.//span[.='%s']])[%d]",
          filterName, index);
      return new AntSelect(getWebDriver(), getWebElement(), xpath);
    }
  }

  public static class DuplicatedCombinationsTable extends AntTable<ArmCombination> {

    public DuplicatedCombinationsTable(WebDriver webDriver) {
      super(webDriver);
      setTableLocator("//div[contains(@class,'duplicate-info-holder ')]");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("armOutput", "armOutputDisplay")
          .put("destinationHub", "destinationHubDisplay")
          .put("orderTag", "orderTagDisplay")
          .build()
      );
      setEntityClass(ArmCombination.class);
    }
  }

  public static class UniqueCombinationsTable extends AntTable<ArmCombination> {

    public UniqueCombinationsTable(WebDriver webDriver) {
      super(webDriver);
      setTableLocator("//div[contains(@class,'unique-info-holder')]");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("armOutput", "armOutputDisplay")
          .put("destinationHub", "destinationHubDisplay")
          .put("orderTag", "orderTagDisplay")
          .build()
      );
      setEntityClass(ArmCombination.class);
    }
  }
}