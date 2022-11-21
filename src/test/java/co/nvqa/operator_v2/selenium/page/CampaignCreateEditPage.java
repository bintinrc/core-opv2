package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntDateRangePicker;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class CampaignCreateEditPage extends SimpleReactPage<CampaignCreateEditPage> {

  public static final String ITEM_CONTAINS_XPATH = "(//div[contains(@class, 'ant-select-dropdown') and not(contains(@class , 'ant-select-dropdown-hidden'))]//div[contains(normalize-space(text()), '%s')])[2]";
  public static final String SERVICE_TYPE_XPATH = "//div[contains(@class, ' ant-select')][.//input[@id='services_%s_serviceType']]";
  public static final String SERVICE_LEVEL_XPATH = "//div[contains(@class, ' ant-select')][.//input[@id='services_%s_serviceLevel']]";
  public static final String SERVICE_DISCOUNT_XPATH = "services_%s_discount_value";
  public static final String SERVICE_TYPE_XPATH_LIST = "//input[contains(@id,'serviceType')]//parent::span//following-sibling::span";
  public static final String SERVICE_LEVEL_XPATH_LIST = "//input[contains(@id,'serviceLevel')]//parent::span//following-sibling::span";
  public static final String SERVICE_DISCOUNT_XPATH_LIST = "//input[contains(@id,'discount_value')]";
  private static final String CAMPAIGN_PAGE_NOTIFICATION_CLOSE_ICON_XPATH = "//div[contains(@class,'ant-notification')]//span[@class='ant-notification-notice-close-x']";


  @FindBy(id = "name")
  public PageElement campaignName;

  @FindBy(id = "description")
  public PageElement campaignDescription;

  @FindBy(xpath = ".//div[contains(@class,'ant-form-item-row')][.//div[contains(.,'Start date')]]")
  public AntDateRangePicker startDate;

  @FindBy(xpath = ".//div[contains(@class,'ant-form-item-row')][.//div[contains(.,'End date')]]")
  public AntDateRangePicker endDate;

  @FindBy(id = "start_date")
  public PageElement startDateInputBox;

  @FindBy(id = "end_date")
  public PageElement endDateInputBox;

  @FindBy(xpath = "(//span[text()='Add']/parent::button)[1]")
  public PageElement addButton;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;

  @FindBy(xpath = "//a[text()='Download']")
  public PageElement downloadButton;

  @FindBy(xpath = "//span[text()='Shippers']//parent::div//following::span[text()='Add']//parent::button")
  public PageElement shippersAddButton;

  @FindBy(xpath = "//span[text()='Search by shipper']//parent::li")
  public PageElement searchByShipperTab;

  @FindBy(xpath = "//div[contains(@class, ' ant-select')][.//input[@id='rc_select_7']]")
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

  public CampaignCreateEditPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void clickAddButton(List<String> options){
    if (options.size() > 1) {
      for (int x = 1; x < options.size(); x++) {
        addButton.click();
      }
    }
  }

  public void selectServiceType(List<String> options) {
    int i = 0;
    for (String option : options) {
      AntSelect serviceType = new AntSelect(getWebDriver(),
          findElementBy(By.xpath(f(SERVICE_TYPE_XPATH, Integer.toString(i)))));
      serviceType.selectValue(option, ITEM_CONTAINS_XPATH);
      i++;
    }
  }

  public void selectServiceLevel(List<String> options) {
    int i = 0;
    for (String option : options) {
      AntSelect serviceLevel = new AntSelect(getWebDriver(),
          findElementBy(By.xpath(f(SERVICE_LEVEL_XPATH, Integer.toString(i)))));
      serviceLevel.selectValue(option);
      i++;
    }
  }

  public void enterDiscountValue(List<String> values) {
    int i = 0;
    for (String value : values) {
      findElementBy(By.id(f(SERVICE_DISCOUNT_XPATH, Integer.toString(i)))).sendKeys(value);
      i++;
    }
  }

  public List<String> getServiceType() {
    List<WebElement> elements = findElementsBy(By.xpath(SERVICE_TYPE_XPATH_LIST));
    List<String> serviceTypeList = new ArrayList<>();
    for (WebElement element: elements) {
      serviceTypeList.add(element.getText());
    }
    return serviceTypeList;
  }

  public List<String> getServiceLevel() {
    List<WebElement> elements = findElementsBy(By.xpath(SERVICE_LEVEL_XPATH_LIST));
    List<String> serviceLevelList = new ArrayList<>();
    for (WebElement element: elements) {
      serviceLevelList.add(element.getText());
    }
    return serviceLevelList;
  }

  public List<String> getDiscountValue() {
    List<WebElement> elements = findElementsBy(By.xpath(SERVICE_DISCOUNT_XPATH_LIST));
    List<String> discountList = new ArrayList<>();
    for (WebElement element: elements) {
      discountList.add(element.getAttribute("value"));
    }
    return discountList;
  }

  public void enterCampaignName(String value) {
    campaignName.sendKeys(value);
  }

  public String getCampaignName() {
    return campaignName.getValue();
  }

  public void enterCampaignDescription(String value) {
    campaignDescription.sendKeys(value);
  }

  public String getCampaignDescription() {
    return campaignDescription.getText();
  }

  public String getStartDate() {
    return startDateInputBox.getValue();
  }

  public String getEndDate() {
    return endDateInputBox.getValue();
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
}