package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class CampaignCreateEditPage extends SimpleReactPage<CampaignCreateEditPage> {

  public static final String ITEM_CONTAINS_XPATH = "(//div[contains(@class, 'ant-select-dropdown') and not(contains(@class , 'ant-select-dropdown-hidden'))]//div[contains(normalize-space(text()), '%s')])[2]";
  public static final String ITEM_CONTAINS_XPATH_FOR_DISCOUNT_OPERATOR = "//div[contains(@class, 'ant-select-dropdown') and not(contains(@class , 'ant-select-dropdown-hidden'))]//div[contains(normalize-space(text()), '%s')]";
  public static final String SERVICE_TYPE_XPATH = "//div[contains(@class, ' ant-select')][.//input[@id='services_%s_serviceType']]";
  public static final String SERVICE_LEVEL_XPATH = "//div[contains(@class, ' ant-select')][.//input[@id='services_%s_serviceLevel']]";
  public static final String SERVICE_DISCOUNT_XPATH = "services_%s_discount_value";
  public static final String SERVICE_TYPE_XPATH_LIST = "//input[contains(@id,'serviceType')]//parent::span//following-sibling::span";
  public static final String SERVICE_LEVEL_XPATH_LIST = "//input[contains(@id,'serviceLevel')]//parent::span//following-sibling::span";
  public static final String DISCOUNT_OPERATOR_LIST = "//input[contains(@id,'discount_operator')]//parent::span//following-sibling::span";
  public static final String SERVICE_DISCOUNT_XPATH_LIST = "//input[contains(@id,'discount_value')]";
  private static final String CAMPAIGN_PAGE_NOTIFICATION_CLOSE_ICON_XPATH = "//div[contains(@class,'ant-notification')]//span[@class='ant-notification-notice-close-x']";

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='discount_operator']]")
  public PageElement discountOperator;

  @FindBy(className = "ant-form-item-explain")
  public PageElement generalError;

  @FindBy(xpath = "//div[.//input[contains(@id,'serviceType')] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement campaignServiceTypeError;

  @FindBy(xpath = "//div[.//input[contains(@id,'serviceLevel')] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement campaignServiceLevelError;

  @FindBy(xpath = "(//div[.//input[contains(@id,'discount_value')] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error'])[1]")
  public PageElement campaignDiscountValueError;

  @FindBy(id = "name")
  public PageElement campaignName;

  @FindBy(xpath = "//div[.//input[@id='name'] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement campaignNameError;

  @FindBy(id = "services_0_discount_value")
  public PageElement campaign1stDiscountValue;

  @FindBy(id = "description")
  public PageElement campaignDescription;

  @FindBy(xpath = ".//div[contains(@class,'ant-form-item-row')][.//div[contains(.,'Start date')]]")
  public AntDateRangePicker startDate;

  @FindBy(xpath = ".//div[contains(@class,'ant-form-item-row')][.//div[contains(.,'End date')]]")
  public AntDateRangePicker endDate;

  @FindBy(id = "start_date")
  public PageElement startDateInputBox;

  @FindBy(xpath = "//div[.//input[@id='start_date'] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement startDateError;

  @FindBy(id = "end_date")
  public PageElement endDateInputBox;

  @FindBy(xpath = "//div[.//input[@id='end_date'] and contains(concat(' ',normalize-space(@class),' '),' ant-form-item-control ')]//div[@class='ant-form-item-explain-error']")
  public PageElement endDateError;

  @FindBy(xpath = "(//span[text()='Add']/parent::button)[1]")
  public PageElement addButton;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;

  @FindBy(xpath = "//a[text()='Download']")
  public PageElement downloadButton;

  @FindBy(xpath = "//span[text()='Shippers']//parent::div//following::span[text()='Add']//parent::button")
  public PageElement shippersAddButton;

  @FindBy(xpath = "//span[text()='Add']//parent::button")
  public PageElement campaignRuleAddButton;

  @FindBy(xpath = "//label[@for='services_1_serviceType']/parent::div")
  public PageElement newServiceTypeRow;

  @FindBy(xpath = "//label[@for='services_1_serviceLevel']/parent::div")
  public PageElement newServiceLevelRow;

  @FindBy(xpath = "//label[@for='services_1_discount_value']/parent::div")
  public PageElement newDiscountValueRow;

  @FindBy(xpath = "//span[text()='Search by shipper']//parent::li")
  public PageElement searchByShipperTab;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='rc_select_14']]")
  public AntSelect searchByShipper;

  @FindBy(xpath = "//span[text()='Upload']//parent::button")
  public PageElement uploadButton;

  @FindBy(xpath = "//span[text()='Browse']//input")
  public PageElement browseInput;

  @FindBy(xpath = "//span[text()='Remove']//parent::button")
  public PageElement shippersRemoveButton;

  @FindBy(xpath = "//input[@id='id']")
  public PageElement campaignId;

  @FindBy(xpath = "//span[contains(text(),'Shippers')]")
  public PageElement shipperCount;

  @FindBy(xpath = "//span[text()='Publish']/parent::button")
  public PageElement campaignPublishButton;

  @FindBy(xpath = "//span[text()='Cancel']/parent::button")
  public PageElement campaignCancelButton;

  @FindBy(xpath = "//label[text()='Service type']//ancestor::div[contains(@class,'row-middle')]//button[@disabled]")
  public PageElement campaignRuleRowOne;

  private static final String CAMPAIGN_FIELD_ERROR_MESSAGE = "//label[text()='%s']/ancestor::div[contains(@class,'item-row')]//div[@role='alert']";

  public CampaignCreateEditPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickAddButton(List<String> options) {
    if (options.size() > 1) {
      for (int x = 1; x < options.size(); x++) {
        addButton.click();
      }
    }
  }

  public void selectDiscountOperator(String option) {
    AntSelect discountType = new AntSelect(getWebDriver(), discountOperator.getWebElement());
    discountType.selectValue(option, ITEM_CONTAINS_XPATH_FOR_DISCOUNT_OPERATOR);
  }

  public void selectServiceType(List<String> options, int row) {
    int i = row;
    for (String option : options) {
      AntSelect serviceType = new AntSelect(getWebDriver(),
          findElementBy(By.xpath(f(SERVICE_TYPE_XPATH, Integer.toString(i)))));
      serviceType.selectValue(option, ITEM_CONTAINS_XPATH);
      i++;
    }
  }

  public String getCampaignServiceTypeError() {
    return campaignServiceTypeError.getText();
  }

  public void selectServiceLevel(List<String> options, int row) {
    int i = row;
    for (String option : options) {
      AntSelect serviceLevel = new AntSelect(getWebDriver(),
          findElementBy(By.xpath(f(SERVICE_LEVEL_XPATH, Integer.toString(i)))));
      serviceLevel.selectValue(option);
      i++;
    }
  }

  public String getCampaignServiceLevelError() {
    return campaignServiceLevelError.getText();
  }

  public void enterDiscountValue(List<String> values, int row) {
    int i = row;
    for (String value : values) {
      findElementBy(By.id(f(SERVICE_DISCOUNT_XPATH, Integer.toString(i)))).sendKeys(value);
      i++;
    }
  }

  public String getCampaignGeneralError() {
    return generalError.getText();
  }

  public String getCampaignDiscountValueAlert() {
    return campaign1stDiscountValue.getAttribute("validationMessage");
  }

  public String getCampaignDiscountValueError() {
    return campaignDiscountValueError.getText();
  }

  public List<String> getServiceType() {
    List<WebElement> elements = findElementsBy(By.xpath(SERVICE_TYPE_XPATH_LIST));
    List<String> serviceTypeList = new ArrayList<>();
    for (WebElement element : elements) {
      serviceTypeList.add(element.getText());
    }
    return serviceTypeList;
  }

  public List<String> getServiceLevel() {
    List<WebElement> elements = findElementsBy(By.xpath(SERVICE_LEVEL_XPATH_LIST));
    List<String> serviceLevelList = new ArrayList<>();
    for (WebElement element : elements) {
      serviceLevelList.add(element.getText());
    }
    return serviceLevelList;
  }

  public String getDiscountOperator() {
    List<WebElement> elements = findElementsBy(By.xpath(DISCOUNT_OPERATOR_LIST));
    Assertions.assertThat(elements.size()).as("Assert that discount operator displays")
        .isGreaterThan(0);
    return elements.get(0).getText().trim();
  }

  public List<String> getDiscountValue() {
    List<WebElement> elements = findElementsBy(By.xpath(SERVICE_DISCOUNT_XPATH_LIST));
    List<String> discountList = new ArrayList<>();
    for (WebElement element : elements) {
      discountList.add(element.getAttribute("value"));
    }
    return discountList;
  }

  public void enterCampaignName(String value) {
    campaignName.sendKeys(Keys.CONTROL + "a");
    campaignName.sendKeys(Keys.DELETE);
    if (!value.equalsIgnoreCase("blank")) {
      campaignName.sendKeys(value);
    }
  }

  public String getCampaignName() {
    return campaignName.getValue();
  }

  public String getCampaignNameError() {
    return campaignNameError.getText();
  }

  public void enterCampaignDescription(String value) {
    campaignDescription.sendKeys(Keys.CONTROL + "a");
    campaignDescription.sendKeys(Keys.DELETE);
    if (!value.equalsIgnoreCase("blank")) {
      campaignDescription.sendKeys(value);
    }
  }

  public String getCampaignDescription() {
    return campaignDescription.getText();
  }

  public String getStartDate() {
    return startDateInputBox.getValue();
  }

  public String getStartDateError() {
    return startDateError.getText();
  }

  public String getEndDate() {
    return endDateInputBox.getValue();
  }

  public String getEndDateError() {
    return endDateError.getText();
  }

  public String getNotificationMessageText() {
    antNotificationMessage.waitUntilVisible();
    return antNotificationMessage.getText();
  }

  public void closeNotificationMessage() {
    List<WebElement> notificationElements = findElementsByXpath(
        CAMPAIGN_PAGE_NOTIFICATION_CLOSE_ICON_XPATH);
    if (notificationElements != null) {
      notificationElements.forEach((element) -> {
        element.click();
        pause1s();
      });
    }
  }

  public Boolean isShippersAddButtonDisplayed() {
    return shippersAddButton.isDisplayed();
  }

  public void clickShippersAddButton() {
    shippersAddButton.click();
  }

  public void clickCampaignRuleAddButton() {
    campaignRuleAddButton.click();
  }

  public void clickDownloadButton() {
    downloadButton.click();
  }

  public void clickSearchByShippersTab() {
    searchByShipperTab.click();
  }

  public void searchForTheShipper(String shipperName) {
    searchByShipper.selectValue(shipperName);
  }

  public void clickUploadButton() {
    uploadButton.click();
  }

  public void uploadFile(File file) {
    browseInput.sendKeys(file.getAbsolutePath());
  }

  public Boolean isDownloadButtonDisplayed() {
    return downloadButton.isDisplayed();
  }

  public Boolean isCampaignIdDisplayed() {
    return !campaignId.getValue().isEmpty();
  }

  public String getCampaignId() {
    return campaignId.getValue();
  }

  public Boolean isShippersRemoveButtonDisplayed() {
    return shippersRemoveButton.isDisplayed();
  }

  public void clickPublishButton() {
    campaignPublishButton.waitUntilVisible();
    campaignPublishButton.click();
  }

  public void clickCancelButton() {
    campaignCancelButton.waitUntilVisible();
    campaignCancelButton.click();
  }

  public void verifyNewRowAdded() {
    newServiceTypeRow.getText().equals("Service type");
    newServiceLevelRow.getText().equals("Service level");
    newDiscountValueRow.getText().equals("Discount value");
  }

  public void removeCampaignRule(int row) {
    if (row == 1) {
      campaignRuleRowOne.waitUntilVisible();
    } else {
      clickf(
          "(//label[text()='Service type']//ancestor::div[contains(@class,'row-middle')])[%s]//button",
          row);
    }
  }

  public int getCampaignRuleCount() {
    return getElementsCount(
        "//label[text()='Service type']//ancestor::div[contains(@class,'row-middle')]");
  }

  public void waitUntilCampaignPageIsLoaded() {
    campaignPublishButton.waitUntilClickable(30);
  }
}