package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class ReportSchedulesPage extends SimpleReactPage<ReportSchedulesPage> {

  public ReportSchedulesPage(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(xpath = "//span[text()='Create New Schedule']//parent::button")
  public Button createNewScheduleBtn;

  @FindBy(xpath = "//h1[text()='Report Scheduling']")
  public PageElement createReportSchedulingHeader;

  @FindBy(xpath = "//button[@label='Generate Success Billings']")
  public Button saveScheduledReportBtn;

  @FindBy(xpath = "//span[text()='Schedule Name']//parent::div//following-sibling::div//input")
  public TextBox nameInput;

  @FindBy(xpath = "//span[text()='Schedule Description']//parent::div//following-sibling::div//input")
  public TextBox descriptionInput;

  @FindBy(xpath = "//input[@value='Monthly']")
  public CheckBox monthlyFrequency;

  @FindBy(css = ".ant-radio-button > input[value='Weekly']")
  public CheckBox weeklyFrequency;

  @FindBy(xpath = "//span[text()='All Shippers']//preceding-sibling::span//input")
  public CheckBox allShippers;

  @FindBy(xpath = "//span[text()='Select One Shipper']//preceding-sibling::span//input")
  public CheckBox selectOneShipper;
  @FindBy(xpath = "//span[text()='Select By Parent Shipper']//preceding-sibling::span//input")
  public CheckBox selectParentShipper;

  @FindBy(xpath = "//span[text()='Select By Script IDs']//preceding-sibling::span//input")
  public CheckBox selectScriptIds;

  @FindBy(xpath = "//input[@value='AGGREGATED']")
  public CheckBox orderAggregation;

  @FindBy(xpath = "//span[text()='Orders consolidated by shipper']//preceding-sibling::span//input")
  public CheckBox fileGroupByShipper;

  @FindBy(xpath = "//span[text()='All orders (1 very big file, takes long time to generate']//preceding-sibling::span//input")
  public CheckBox fileGroupByAllOrders;

  @FindBy(xpath = "//span[text()='Orders consolidated by script (1 file per script), grouped by shipper within the file']//preceding-sibling::span//input")
  public CheckBox fileGroupByScriptIds;

  @FindBy(xpath = "//span[text()='Report Template']//parent::div//following-sibling::div//div[@class='ant-select-selector']")
  public AntSelect3 reportTemplate;

  @FindBy(xpath = "//span[text()='Report Template']//parent::div//following-sibling::div//p")
  public PageElement textBoxForReportTemplateForAggregatedOrders;

  @FindBy(xpath = "//span[text()='And send it to']//parent::div//following::div[@class='ant-select-selector']")
  public AntSelect3 email;

  @FindBy(xpath = "//span[text()='Day of Week']//parent::div//following-sibling::div//div[@class='ant-select-selector']")
  public AntSelect3 dateOfTheWeek;

  @FindBy(xpath = "//span[text()='For']//parent::div//following-sibling::div//div[@class='ant-select-selector']")
  public AntSelect3 forSearch;

  @FindBy(xpath = "//p[text()='Name']//following-sibling::input")
  public TextBox reportSearchInput;

  @FindBy(xpath = "//span[@aria-label='edit']")
  public PageElement editBtn;

  @FindBy(xpath = "//span[text()='Frequency']//parent::div//following::p")
  public PageElement frequencyDescription;

  @FindBy(xpath = "//span[text()='SSB']//parent::div")
  public AntSelect3 reportType;

  public void switchToIframe() {
    switchToFrame("//iframe[@ng-style='iframeStyleObj']");
  }

  public void clickCreateTemplateBtn() {
    createNewScheduleBtn.click();
  }

  public void clickSaveScheduleReportButton() {
    saveScheduledReportBtn.waitUntilClickable();
    saveScheduledReportBtn.click();
  }

  public void setReportName(String name) {
    nameInput.forceClear();
    nameInput.sendKeys(name);
  }

  public void setReportDescription(String description) {
    descriptionInput.forceClear();
    descriptionInput.sendKeys(description);
  }

  public String getReportScheduleToastMessage() {
    return getAntTopTextV2();
  }

  public void searchAndEditByReportScheduleName(String reportName) {
    reportSearchInput.sendKeys(reportName);
    editBtn.click();
  }

  public void scrollAndSelectReportTemplate(String templateName) {
    click("//span[text()='Report Template']//parent::div//following-sibling::div//input");
    pause1s();
    WebElement reportTemplateScrollBar = findElementByXpath(
        "//div[contains(@id,'rc_select')]//following-sibling::div[@class='rc-virtual-list']//div[@class='rc-virtual-list-scrollbar-thumb']");
    scrollToElement(reportTemplateScrollBar,
        f("//div[contains(@id,'rc_select')]//following-sibling::div[@class='rc-virtual-list']//div[text()='%s']",
            templateName), 1500, 2);
    TestUtils.findElementAndClick(
        f("//div[contains(@id,'rc_select')]//following-sibling::div[@class='rc-virtual-list']//div[text()='%s']",
            templateName), "xpath", getWebDriver());
    pause50ms();

  }
}
