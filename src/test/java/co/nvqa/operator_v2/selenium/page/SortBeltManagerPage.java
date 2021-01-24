package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ArmCombination;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.md.MdSwitch;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
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

  @FindBy(xpath = "//div[./label/span[.='Active Configuration']]")
  public PageElement activeConfiguration;

  @FindBy(xpath = "//div[./label/span[.='Previous Configuration']]")
  public PageElement previousConfiguration;

  @FindBy(xpath = "//div[./label/span[.='Last changed at']]")
  public PageElement lastChangedAt;

  @FindBy(xpath = "//button[.//span[.='Change']]")
  public Button change;

  @FindBy(xpath = "//button[.//span[contains(., 'Create Configuration')]]")
  public Button create;

  @FindBy(xpath = "//button[.//span[contains(., 'Edit Configuration')]]")
  public Button editConfiguration;

  @FindBy(css = "a[class*='EditButton']")
  public Button editUnassignedParcelsArm;

  @FindBy(xpath = "//button/span[contains(text(), 'Confirm')]")
  public Button confirm;

  @FindBy(xpath = "(//input[@class='ant-input'])[1]")
  public TextBox nameInput;

  @FindBy(xpath = "(//input[@class='ant-input'])[2]")
  public TextBox descriptionInput;

  @FindBy(xpath = "//div[contains(@class,'NoResult')]/span")
  public PageElement noResult;

  @FindBy(xpath = "//label[.='Unassigned Parcel Arm']/following-sibling::span")
  public PageElement unassignedParcelArm;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(className = "ant-modal-wrap")
  public CreateConfigurationModal createConfigurationModal;

  @FindBy(className = "ant-modal-wrap")
  public ChangeUnassignedParcelArmModal changeUnassignedParcelArmModal;

  @FindBy(className = "ant-modal-wrap")
  public ChangeActiveConfigurationModal changeActiveConfigurationModal;

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

  public String getActiveConfiguration() {
    return StringUtils
        .normalizeSpace(activeConfiguration.getText().replace("Active Configuration", ""));
  }

  public String getPreviousConfiguration() {
    return StringUtils
        .normalizeSpace(previousConfiguration.getText().replace("Previous Configuration", ""));
  }

  public String getLastChangedAt() {
    return StringUtils
        .normalizeSpace(lastChangedAt.getText().replace("Last changed at", ""));
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

    public Button getRemoveButton(int index) {
      String xpath = f("(.//button[contains(@class,'RemoveFilterButton')])[%d]", index);
      return new Button(getWebDriver(), getWebElement(), xpath);
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

  public static class CreateConfigurationModal extends AntModal {

    public CreateConfigurationModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[1]")
    public AntSelect firstFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[2]")
    public AntSelect secondFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[3]")
    public AntSelect thirdFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[4]")
    public AntSelect unassignedParcelArm;

    @FindBy(xpath = ".//button[.//span[contains(., 'Confirm')]]")
    public AntButton confirm;
  }

  public static class ChangeUnassignedParcelArmModal extends AntModal {

    public ChangeUnassignedParcelArmModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[1]")
    public AntSelect unassignedParcelArm;

    @FindBy(xpath = ".//button[.//span[contains(., 'Confirm')]]")
    public AntButton confirm;

    @FindBy(css = "div.note")
    public PageElement note;

    public String getFilterValue(String filterName) {
      return findElement(By.xpath(f("//tr[.//td[contains(.,'%s')]]//td[2]", filterName))).getText();
    }
  }

  public static class ChangeActiveConfigurationModal extends AntModal {

    public ChangeActiveConfigurationModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[1]")
    public AntSelect configuration;

    @FindBy(xpath = ".//button[.//span[contains(., 'Confirm')]]")
    public AntButton confirm;
  }
}