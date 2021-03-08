package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DriverPerformanceInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSelect2;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSwitch;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class DriverPerformancePage extends OperatorV2SimplePage {

  public DriverPerformancePage(WebDriver webDriver) {
    super(webDriver);
    driverPerformanceTable = new DriverPerformanceTable(webDriver);
  }

  @FindBy(className = "ant-modal-content")
  public SaveAsPresetModal saveAsPresetModal;

  @FindBy(xpath = "//div[@class='ant-modal-content'][.//div[.='Update Preset']]")
  public UpdatePresetModal updatePresetModal;

  @FindBy(xpath = "//div[@class='ant-modal-content'][.//div[.='Delete Preset']]")
  public DeletePresetModal deletePresetModal;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(css = ".ant-collapse-header")
  public PageElement showHideFilters;

  @FindBy(xpath = ".//button[.='Go back to previous page']")
  public Button goToPreviousPage;

  @FindBy(css = ".ant-collapse-content-box")
  public FiltersForm filtersForm;

  public DriverPerformanceTable driverPerformanceTable;

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilLoaded() {
    if (spinner.waitUntilVisible(10)) {
      spinner.waitUntilInvisible();
    }
    filtersForm.clearSelection.waitUntilClickable(60);
    pause5s();
  }

  public static class FiltersForm extends PageElement {

    public FiltersForm(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "input[placeholder='Start date']")
    public TextBox startDate;

    @FindBy(css = "input[placeholder='End date']")
    public TextBox endDate;

    @FindBy(id = "displayIndividualRows")
    public AntSwitch displayIndividualRows;

    @FindBy(xpath = ".//button[contains(.,'Create/Modify Preset')]")
    public Button createModifyPreset;

    @FindBy(xpath = "//li/span[@aria-label='save']")
    public Button saveAsPreset;

    @FindBy(xpath = "//li/span[@aria-label='sync']")
    public Button updateCurrentPreset;

    @FindBy(xpath = "//li/span[@aria-label='delete']")
    public Button deletePreset;

    @FindBy(css = "div[data-testid='driver-performance.preset-select']")
    public AntSelect selectPreset;

    @FindBy(xpath = "//div[./div/div/label[@for='hubs']]")
    public AntFilterSelect2 hubsFilter;

    @FindBy(xpath = "//div[./div/div/label[@for='driverName']]")
    public AntFilterSelect2 driverNameFilter;

    @FindBy(xpath = "//div[./div/div/label[@for='driverTypes']]")
    public AntFilterSelect2 driverTypesFilter;

    @FindBy(css = "[data-testid='driverPerformance.loadSelection']")
    public Button loadSelection;

    @FindBy(xpath = "//button[.='Clear Selection']")
    public Button clearSelection;
  }

  public static class DriverPerformanceTable extends AntTableV3<DriverPerformanceInfo> {

    public static final String COLUMN_DRIVER_NAME = "driverName";
    public static final String COLUMN_HUB = "hub";
    public static final String COLUMN_ROUTE_DATE = "routeDate";

    @FindBy(css = "span[data-testid='driverPerformance.aggregatedButton']")
    public List<Button> aggregatedButton;

    public DriverPerformanceTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(COLUMN_DRIVER_NAME, "1")
          .put(COLUMN_HUB, "2")
          .put(COLUMN_ROUTE_DATE, "3")
          .put("driverType", "4")
          .put("deliverySuccessRate", "5")
          .put("totalNumberOfParcelsDelivered", "6")
          .put("numberOfXsParcelsDelivered", "7")
          .put("numberOfSParcelsDelivered", "8")
          .put("numberOfMParcelsDelivered", "9")
          .put("numberOfLParcelsDelivered", "10")
          .put("numberOfXLParcelsDelivered", "11")
          .put("numberOfXXLParcelsDelivered", "12")
          .put("totalNumberOfParcelsFailed", "13")
          .put("totalNumberOfReservations", "14")
          .put("totalNumberOfSuccessfulPickupScans", "15")
          .build()
      );
      setEntityClass(DriverPerformanceInfo.class);
      setTableLocator("(//div[contains(@class,'ant-table')]//table)[last()]");
    }
  }

  public static class SaveAsPresetModal extends AntModal {

    public SaveAsPresetModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(css = "input[data-testid='driverPerformance.presetNameInput']")
    public TextBox presetName;

    @FindBy(css = "span.ant-typography-danger")
    public PageElement errorMessage;

    @FindBy(xpath = ".//button[.='Save']")
    public Button save;
  }

  public static class UpdatePresetModal extends AntModal {

    public UpdatePresetModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//button[.='Confirm']")
    public Button confirm;
  }

  public static class DeletePresetModal extends AntModal {

    public DeletePresetModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//button[.='Confirm']")
    public Button confirm;
  }
}