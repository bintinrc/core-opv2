package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class SsbTemplatePage extends SimpleReactPage {

  @FindBy(xpath = "//h1[text()='SSB Report Template Editor']")
  public PageElement createTemplateHeader;

  @FindBy(xpath = "//input[@data-testid='name-input']")
  private TextBox templateNameInput;

  @FindBy(xpath = "//input[@data-testid='description-input']")
  private TextBox templateDescriptionInput;

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

  @FindBy(xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div")
  public PageElement toastErrorTopText;

  @FindBy(xpath = "//div[@id='toast-container']/div/div/div/div[@class='toast-bottom']")
  public PageElement toastErrorBottomText;

  @FindBy(xpath = "//li[@title='Next Page']//preceding-sibling::li[1]")
  public PageElement lastPagePaginationBtn;

  @FindBy(css = "li.ant-pagination-prev")
  public Button prevPage;

  @FindBy(css = "li.ant-pagination-next")
  public Button nextPage;

  @FindBy(xpath = "//button//span[text()='OK']")
  public Button okBtn;


  private static String XPATH_HEADER_COLUMN_IN_AVAILABLE_HEADERS = "//div[text()='%s']";
  private static String XPATH_HEADER_COLUMN_IN_SELECTED_HEADERS = "//div[contains(text(),'%s')]";
  private static String XPATH_HEADER_COLUMN_SELECTED_DROP_AREA = "//div[@data-testid='selected-drop-area']";
  private static String XPATH_HEADER_COLUMN_OPTIONS_DROP_AREA = "//div[@data-testid='options-drop-area']";

  private static String XPATH_TEMPLATE_EDIT_BTN = "//td[text()='%s']/..//span[@aria-label='edit']";
  private static String XPATH_TEMPLATE_DELETE_BTN = "//td[text()='%s']/..//span[@aria-label='delete']";

  public SsbTemplatePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickCreateTemplateBtn() {
    createNewTemplateBtn.click();
  }

  public void clickSubmitBtn() {
    submitBtn.waitUntilClickable();
    submitBtn.click();
  }

  public void clickDownloadCsvBtn() {
    downloadExampleCsvBtn.click();
  }

  public void clickGoBackBtn() {
    goBackBtn.click();
  }

  public void setTemplateName(String name) {
    templateNameInput.forceClear();
    templateNameInput.sendKeys(name);
  }

  public void setTemplateDescription(String description) {
    templateDescriptionInput.forceClear();
    templateDescriptionInput.sendKeys(description);
  }

  public void dragAndDropColumnToSelectedHeadersColumn(String headerColumn) {
    WebElement fromColumn = findElementBy(
        By.xpath(f(XPATH_HEADER_COLUMN_IN_AVAILABLE_HEADERS, headerColumn)));
    WebElement to = findElementBy(By.xpath(XPATH_HEADER_COLUMN_SELECTED_DROP_AREA));
    dragAndDrop(fromColumn, to);
    pause100ms();
  }

  public void dragAndDropToAvailableHeadersColumn(String headerColumn) {
    WebElement fromColumn = findElementBy(
        By.xpath(f(XPATH_HEADER_COLUMN_IN_SELECTED_HEADERS, headerColumn)));
    WebElement to = findElementBy(By.xpath(XPATH_HEADER_COLUMN_OPTIONS_DROP_AREA));
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

  public void selectAndEditSsbTemplate(String name) {
    lastPagePaginationBtn.click();
    final String templateEditBtn = f(XPATH_TEMPLATE_EDIT_BTN, name);
    while (!isElementExist(templateEditBtn) && prevPage.isEnabled()) {
      prevPage.click();
    }
    clickAndWaitUntilDone(templateEditBtn);
  }

  public void selectAndDeleteSsbTemplate(String name) {
    lastPagePaginationBtn.click();
    final String templateDeleteBtn = f(XPATH_TEMPLATE_DELETE_BTN, name);
    while (!isElementExist(templateDeleteBtn) && prevPage.isEnabled()) {
      prevPage.click();
    }
    clickAndWaitUntilDone(templateDeleteBtn);
    okBtn.click();
  }

  public boolean isLegacyIdHeaderColumnAvailable() {
    return isElementExist(f(XPATH_HEADER_COLUMN_IN_AVAILABLE_HEADERS, "Legacy Shipper ID"));
  }
}
