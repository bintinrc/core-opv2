package co.nvqa.operator_v2.selenium.page.sns;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import java.util.List;
import java.util.Objects;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

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
    waitUntilVisibilityOfElementLocated(addShipperSupportAgentModal.getWebElement());
    fillAndSaveLiveChatAgentDetails(fullName, email);
    addShipperSupportAgentModal.waitUntilInvisible();
  }


  private void fillAndSaveLiveChatAgentDetails(String fullName, String email) {
    addShipperSupportAgentModal.waitUntilVisible();
    addShipperSupportAgentModal.fillAndSaveLiveChatAgentDetails(fullName, email);
    addShipperSupportAgentModal.waitUntilInvisible();
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

  public static class AddShipperSupportAgentModal extends AntModal {
    @FindBy(xpath = ".//div[./div/label[.='Full name']]//input")
    public TextBox fullNameTextInput;

    @FindBy(xpath = ".//div[./div/label[.='Email']]//input")
    public TextBox emailTextInput;

    @FindBy(xpath = ".//button[.='OK']")
    public Button okButton;


    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancelButton;
    public AddShipperSupportAgentModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void fillAndSaveLiveChatAgentDetails(String name, String  email) {
      fullNameTextInput.setValue(name);
      emailTextInput.setValue(email);
      okButton.click();
    }

  }
}
