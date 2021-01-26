package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntCheckbox;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class SortTasksPage extends OperatorV2SimplePage {

  private static final String OUTPUT_XPATH = "//div[@class='ant-col content-holder']/span[text()='%s']";

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(xpath = "//button[.='Change Selected Hub']")
  public AntSelect changeSelectedHub;

  @FindBy(xpath = "(//div[@id='hubId'])[1]")
  public AntSelect selectHub;

  @FindBy(xpath = "(//button[contains(@class,'ant-btn')])[1]")
  public AntButton load;

  @FindBy(xpath = "//button[.='Refresh table']")
  public AntButton refreshTable;

  @FindBy(xpath = "(//span[contains(text(), 'Add/Remove Outputs')])[1]")
  public PageElement sideBar;

  @FindBy(xpath = "//button/span[contains(text(), 'Create new middle tier')]")
  public Button createNewMidTier;

  @FindBy(xpath = "//button[.//span[contains(text(), 'View Sort Structure')]]")
  public Button viewSortStructure;

  @FindBy(id = "name")
  public TextBox midTierName;

  @FindBy(xpath = "//button/span[text()='Create']")
  public Button create;

  @FindBy(xpath = "(//input[@placeholder='Find...'])[1]")
  public PageElement find;

  @FindBy(xpath = "//span/mark[@class='highlight ']")
  public PageElement actualSortName;

  @FindBy(xpath = "//td[@class='hubName']/span/span")
  public PageElement actualHubName;

  @FindBy(xpath = "//td[@class='type.name']/span/span")
  public PageElement actualSortType;

  @FindBy(xpath = "//a[@class='link']/span")
  public AntButton delete;

  @FindBy(xpath = "//button//span[text()='Confirm']")
  public AntButton confirm;

  @FindBy(xpath = "//div[contains(@class,'NoResult')]/span")
  public PageElement noResult;

  @FindBy(css = ".ant-checkbox")
  public List<AntCheckbox> select;

  @FindBy(xpath = "//button/span[text()='Submit']")
  public AntButton submit;

  @FindBy(xpath = "//button[.='Cancel']")
  public AntButton cancel;

  public SortTasksPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void verifyOutput(String sortName) {
    assertTrue(sortName + " node displayed", isElementExistFast(f(OUTPUT_XPATH, sortName)));
  }

  public void verifyOutputDeleted(String sortName) {
    assertFalse(sortName + " node displayed", isElementExistFast(f(OUTPUT_XPATH, sortName)));
  }
}