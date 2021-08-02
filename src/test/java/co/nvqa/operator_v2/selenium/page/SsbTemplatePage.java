package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class SsbTemplatePage extends SimpleReactPage {

  @FindBy(xpath = "//h1[text()='SSB Report Template Editor']")
  public PageElement createTemplateHeader;

  @FindBy(xpath = "//input[@data-testid='name-input']")
  private PageElement templateNameInput;

  @FindBy(xpath = "//input[@data-testid='description-input']")
  private PageElement templateDescriptionInput;

  @FindBy(xpath = "//button[@data-testid='back-btn']")
  private Button goBackBtn;

  @FindBy(xpath = "//button[@data-testid='download-example-btn']")
  private Button downloadExampleCsvBtn;

  @FindBy(xpath = "//button[@data-testid='submit-btn']")
  private Button submitBtn;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement antNotificationMessageDescription;

  @FindBy(xpath = "//button[@label='Create New Template']")
  private Button createNewTemplateBtn;

  private static String XPATH_HEADER_COLUMN = "//div[text()='%s']";
  private static String XPATH_HEADER_COLUMN_DROP_AREA = "//div[@data-testid='selected-drop-area']";


  public SsbTemplatePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickCreateTemplateBtn() {
    createNewTemplateBtn.click();
  }

  public void clickSubmitBtn() {
    submitBtn.click();
  }

  public void clickDownloadCsvBtn() {
    downloadExampleCsvBtn.click();
  }

  public void setTemplateName(String name) {
    templateNameInput.sendKeys(name);
  }

  public void setTemplateDescription(String description) {
    templateDescriptionInput.sendKeys(description);
  }

  public void dragAndDropColumn(String headerColumn) {
    WebElement fromColumn = findElementBy(By.xpath(f(XPATH_HEADER_COLUMN, headerColumn)));
    WebElement to = findElementBy(By.xpath(XPATH_HEADER_COLUMN_DROP_AREA));
    dragAndDrop(fromColumn, to);
    pause100ms();
  }

  public String getNotificationMessageText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessage.getText();
  }

  public String getNotificationMessageDescText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessageDescription.getText();
  }
}