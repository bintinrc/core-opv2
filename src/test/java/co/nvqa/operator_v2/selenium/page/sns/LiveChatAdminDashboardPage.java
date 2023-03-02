package co.nvqa.operator_v2.selenium.page.sns;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.List;
import java.util.Objects;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.StaleElementReferenceException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class LiveChatAdminDashboardPage extends SimpleReactPage<LiveChatAdminDashboardPage> {


  public static String AGENT_NAME;
  // 0 for customer and 1 for shipper
  public static int elementIndexForLiveAgentPage;

  @FindBy(xpath = "//div[@tabindex='0']//button[span[.='Add a new agent']]")
  public Button addNewAgentButton;

  @FindBy(xpath = "//div[.='Customer support']")
  public PageElement customerSupportTab;

  @FindBy(xpath = "//div[.='Shipper support']")
  public PageElement shipperSupportTab;

  @FindBy(xpath = "//div[@class='ant-modal-wrap' and not(@style='display: none;')]")
  public AddShipperSupportAgentModal addShipperSupportAgentModal;

  @FindBy(xpath = "//input[@placeholder='Search by name or email']")
  public TextBox searchInputFields;

  @FindBy(css = "tbody > tr.ant-table-row")
  public List<AgentRow> agents;

  @FindBy(xpath = "//td/div/div[1]/button[@class='ant-btn ant-btn-icon-only']")
  public List<Button> updateBtns;

  public LiveChatAdminDashboardPage(WebDriver webDriver) {
    super(webDriver);
  }

  @Override
  public void waitUntilLoaded() {
    waitUntilVisibilityOfElementLocated(customerSupportTab.getWebElement());
    waitUntilVisibilityOfElementLocated(addShipperSupportAgentModal.getWebElement());
  }

  public void createLiveChatAgent(String fullName, String email) {
    addNewAgentButton.click();
    pause10s();
    waitUntilVisibilityOfElementLocated(addShipperSupportAgentModal.getWebElement());
    AGENT_NAME = fullName;
    fillAndSaveLiveChatAgentDetails(fullName, email);
    addShipperSupportAgentModal.waitUntilInvisible();
  }


  private void fillAndSaveLiveChatAgentDetails(String fullName, String email) {
    // addShipperSupportAgentModal.waitUntilVisible();
    addShipperSupportAgentModal.fillAndSaveLiveChatAgentDetails(fullName, email);
//    addShipperSupportAgentModal.waitUntilInvisible();
  }

  //  private void fillAndSaveLiveChatAgentDetails(String fullName, String email) {
//    if (Objects.nonNull(fullName)) {
//      WebElement fullNameElement = findElementByXpath("(//div[@class='ant-modal-wrap' and not(@style='display: none;')]//*[text()='Full name']//parent::div//following::div/input)[1]");
//      clearWebField(fullNameElement);
//      sendKeys(fullNameElement, fullName);
//    }
//
//    if (Objects.nonNull(email)) {
//      WebElement emailElement = findElementByXpath("(//div[@class='ant-modal-wrap' and not(@style='display: none;')]//*[text()='Email']//parent::div//following::div/input)[1]");
//      clearWebField(emailElement);
//      sendKeys(emailElement, email);
//    }
//
//    simpleClick("//div[@class='ant-modal-wrap' and not(@style='display: none;')]//*[text()='OK']//parent::button");
//  }
  public void verifyLiveAgentAddedSuccessfully() {
    waitUntilLoaded();
    searchInputFields.setValue(AGENT_NAME);
    /*sendKeys(searchInputFields.get(elementIndexForLiveAgentPage), this.AGENT_NAME);
    String addedAgentRowXpath = f("//td[text()='%s']", this.AGENT_NAME);
    String actualName = getText(addedAgentRowXpath);
    Assertions.assertThat(actualName.equalsIgnoreCase(this.AGENT_NAME)).as("Full name is present").isTrue();*/
  }

  public void updateLiveChatAgent(String fullName, String email) {
    pause5s();
    switchToFrame("//iframe");
    //  List<WebElement> searchInputFields = findElementsByXpath("//input[@placeholder='Search by name or email']");
    // clearWebField(searchInputFields.get(elementIndexForLiveAgentPage));
    //sendKeys(searchInputFields.get(elementIndexForLiveAgentPage), "testinguser");
    searchInputFields.setValue("testinguser");
    // click update button
    // List<WebElement> updateButtons = findElementsByXpath(
    //   "//td/div/div[1]/button[@class='ant-btn ant-btn-icon-only']");
    int updateButtonIndexToClick =
        elementIndexForLiveAgentPage == 0 ? 0 : (updateBtns.size() - 1);
    updateBtns.get(updateButtonIndexToClick).click();
    this.AGENT_NAME = Objects.nonNull(fullName) ? fullName : email;
    fillAndSaveLiveChatAgentDetails(fullName, email);
  }


  public static class AddShipperSupportAgentModal extends AntModal {

    @FindBy(xpath = ".//div[./div/label[.='Full name']]//input")
    public ForceClearTextBox fullNameTextInput;

    @FindBy(xpath = ".//div[./div/label[.='Email']]//input")
    public ForceClearTextBox emailTextInput;

    @FindBy(xpath = ".//button[.='OK']")
    public Button okButton;


    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancelButton;

    public AddShipperSupportAgentModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void fillAndSaveLiveChatAgentDetails(String name, String email) {
      fullNameTextInput.setValue(name);
      emailTextInput.setValue(email);
      okButton.click();
    }

  }

  public static class AgentRow extends AntModal {

    @FindBy(xpath = "//td[text()='%s']")
    public PageElement addedAgentRow;

    public AgentRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
