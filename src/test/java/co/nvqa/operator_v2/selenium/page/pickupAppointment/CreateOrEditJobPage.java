package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.List;
import java.util.stream.Collectors;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class CreateOrEditJobPage extends PageElement {

  @FindBy(css = "input[aria-owns=shipper_list]")
  private PageElement shipperIDField;

  @FindBy(css = "input[aria-owns=shipperAddress_list]")
  private PageElement shipperAddress;

  @FindBy(css = "#dateRange")
  private Button selectDateRange;

  @FindBy(css = "input[aria-owns=timeRange_list]")
  private PageElement selectTimeRange;

  @FindBy(css = "div.ant-space-align-center button")
  private Button createButton;

  @FindBy(css = "#readyBy")
  private PageElement readyByField;
  @FindBy(css = "#latestBy")
  private PageElement latestByField;
  @FindBy(css = "#tags")
  private PageElement tagsField;
  @FindBy(css = "#comments")
  private PageElement commentField;
  @FindBy(css = "span.anticon.anticon-close-circle.ant-input-textarea-clear-icon svg path")
  private PageElement clearCommentField;
  @FindBy(xpath = "//span[text()='Total approx Volume']")
  private PageElement totalApproxVolume;
  @FindBy(css = "input[placeholder='Start date']")
  private PageElement selectedStartDay;
  @FindBy(css = "input[placeholder='End date']")
  private PageElement selectedEndDay;
  @FindBy(xpath = "//span[text()='Cancel']/parent::button")
  private Button cancelButton;
  @FindBy(xpath = "//span[text()='Save']/parent::button")
  private Button saveButton;
  @FindAll(@FindBy(css = "span.ant-select-selection-item-content"))
  private List<PageElement> jobTagElements;

  @FindAll(@FindBy(css = "div.ant-popover:not(.ant-popover-hidden) span.ant-typography"))
  private List<PageElement> jobComments;
  @FindBy(xpath = "//label[@for='tags']/../..//span[@class='ant-select-clear']")
  private Button clearAllTags;

  public final String VERIFY_SHIPPER_FIELD_LOCATOR = "//input[@aria-activedescendant='shipper_list_0']";
  public final String VERIFY_ADDRESS_FIELD_LOCATOR = "//input[@aria-activedescendant='shipperAddress_list_0']";
  public final String TITLE_LOCATOR_FOR_VERIFY_ELEMENT = "span[title='%s']";
  public final String CALENDAR_DAY_BY_TITLE_LOCATOR = "td[title='%s']";
  public final String TIME_RANGE_FILTER_LOCATOR = "input[aria-activedescendant='%s']";
  public final String READY_BY_NUMBER_OF_LIST = "readyBy_list_%d";
  public final String LATEST_BY_NUMBER_OF_LIST = "latestBy_list_%d";
  public final String ARIA_ACTIVEDESCENDANT = "aria-activedescendant";
  public final String PICKUP_JOBS_CALENDAR_LOCATOR = "div[status='ready-for-routing']";
  public final String TIME_RANGE_FILTER_LABEL = "div[label='%s']";
  public final String JOB_TAG_FILTER_LOCATOR = "div[aria-label='%s']";
  public final String DELETE_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.cancel.%s']";
 
  public final String SELECTED_TIME_RANGE_LOCATOR = "span[title='%s']";
  public final String STYLE = "style";
  public final String NOTIFICATION_MESSAGE_LOCATOR = "//div[@class='ant-notification-notice-message']";
  public final String NOTIFICATION_DESCRIPTION_LOCATOR = "div.ant-notification-notice-description";
  public final String TEXT_CONTENT = "textContent";
  public final String VISIBLE_SPAN_TAG_LOCATOR = "div.ant-popover:not(.ant-popover-hidden) span.ant-tag";
  public final String VISIBLE_SPAN_COMMENT_LOCATOR = "div.ant-popover:not(.ant-popover-hidden) span.ant-typography";
  public final String STYLE_COLOR_LOCATOR = ".//*[@data-testid='paJobCalendar.day.%s']//span[contains(@style,'color')]";
  public final String CALENDAR_WEB_ELEMENT_LOCATOR = ".//*[@data-testid='paJobCalendar.day.%s']//*[@status='ready-for-routing']";
  public final String CALENDAR_DAY_WEB_ELEMENT_LOCATOR = "div[data-testid='paJobCalendar.day.%s']";
  public final String CALENDAR_STATUS_WEB_ELEMENT_LOCATOR = "div[status='%s']";
  public final String EDIT_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.edit.%s']";

  public CreateOrEditJobPage(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
    PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
  }

  public void setShipperIDInField(String shipperID) {
    sendTextInFieldAndChooseData(shipperIDField, shipperID, VERIFY_SHIPPER_FIELD_LOCATOR);
  }

  public void setShipperAddressField(String addressField) {
    sendTextInFieldAndChooseData(shipperAddress, addressField, VERIFY_ADDRESS_FIELD_LOCATOR);
  }

  private void sendTextInFieldAndChooseData(PageElement field, String data, String verifyLocator) {
    field.sendKeys(data);
    waitUntilVisibilityOfElementLocated(verifyLocator);
    field.sendKeys(Keys.ENTER);
  }

  public boolean isElementDisplayedByTitle(String title) {
    return webDriver.findElement(
        By.cssSelector(String.format(TITLE_LOCATOR_FOR_VERIFY_ELEMENT, title))).isDisplayed();
  }

  public boolean isCreateButtonDisplayed() {
    waitUntilVisibilityOfElementLocated(createButton.getWebElement());
    return createButton.isDisplayed();
  }

  public void selectDataRangeByTitle(String dayStart, String dayEnd) {
    selectDateRange.click();
    waitUntilVisibilityOfElementLocated(webDriver.findElement(
        By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart))));
    webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart)))
        .click();
    webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayEnd)))
        .click();
  }

  public void selectTimeRangeByDataTime(String timeRange) {
    selectTimeRange.click();
    WebElement customTimeRange = webDriver.findElement(
        By.cssSelector(f(TIME_RANGE_FILTER_LABEL, timeRange)));
    moveToElement(customTimeRange);
    customTimeRange.click();
    waitUntilVisibilityOfElementLocated(createButton.getWebElement());
  }

  private void chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String time,
      PageElement filterElement) {
    do {
      filterElement.sendKeys(Keys.ARROW_DOWN);
    } while (isTimeElementDisplayed(time, filterElement));

    webDriver.findElement(By.cssSelector(String.format(TIME_RANGE_FILTER_LOCATOR, time)))
        .sendKeys(Keys.ENTER);
  }

  private boolean isTimeElementDisplayed(String time, PageElement filterElement) {
    if (time.equals(filterElement.getAttribute(ARIA_ACTIVEDESCENDANT))) {
      return false;
    } else {
      return true;
    }
  }

  public void clickOnCreateButton() {
    createButton.click();
  }

  public List<WebElement> getAllPickupJobsFromCalendar() {
    return webDriver.findElements(By.cssSelector(PICKUP_JOBS_CALENDAR_LOCATOR));
  }

  public void selectCustomTimeAndElement(int time, PageElement fieldElement) {
    fieldElement.click();
    String correctConst;
    if (fieldElement.getWebElement().equals(readyByField.getWebElement())) {
      correctConst = READY_BY_NUMBER_OF_LIST;
    } else {
      correctConst = LATEST_BY_NUMBER_OF_LIST;
    }
    chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(correctConst, time),
        fieldElement);
  }

  public void waitLoadJobInTheCalendarDisplayed(String date) {
    waitUntilVisibilityOfElementLocated(getCalendarWebElementByDate(date));
  }

  public void selectTagInJobTagsField(String tag) {
    tagsField.sendKeys(tag);
    WebElement tagElement = webDriver.findElement(By.cssSelector(f(JOB_TAG_FILTER_LOCATOR, tag)));
    moveToElement(tagElement);
    tagsField.sendKeys(Keys.ENTER);
    totalApproxVolume.click();
  }

  public void addCommentInCommentField(String comment) {
    commentField.clear();
    commentField.sendKeys(comment);
  }

  public void clearCommentsInCommentField() {
    clearCommentField.click();
  }

  public boolean isDisplayedCommentTextInCalendar(String date, String text) {
    moveToElement(getCalendarWebElementByDate(date));
    return getWebDriver().findElements(By.cssSelector(VISIBLE_SPAN_COMMENT_LOCATOR)).stream()
        .anyMatch(pageElement -> pageElement.getText().equalsIgnoreCase(text));
  }

  public boolean isDeleteButtonByJobIdDisplayed(String jobId) {
    try {
      return webDriver.findElement(By.cssSelector(f(DELETE_BUTTON_IN_CALENDAR_LOCATOR, jobId)))
          .isDisplayed();
    } catch (NoSuchElementException noSuchElementException) {
      return false;
    }
  }

  public boolean isEditButtonByJobIdDisplayed(String jobId) {
    try {
      return webDriver.findElement(By.cssSelector(f(EDIT_BUTTON_IN_CALENDAR_LOCATOR, jobId)))
          .isDisplayed();
    } catch (NoSuchElementException noSuchElementException) {
      return false;
    }
  }

  public void clickOnEditButtonByJobId(String jobId) {
    webDriver.findElement(By.cssSelector(f(EDIT_BUTTON_IN_CALENDAR_LOCATOR, jobId))).click();
  }

  public void clickOnDeleteButtonByJobId(String jobId) {
    webDriver.findElement(By.cssSelector(f(DELETE_BUTTON_IN_CALENDAR_LOCATOR, jobId))).click();
  }

  public PageElement getReadyByField() {
    return readyByField;
  }

  public PageElement getLatestByField() {
    return latestByField;
  }

  public String getValueSelectedStartDay() {
    return selectedStartDay.getValue();
  }

  public String getValueSelectedEndDay() {
    return selectedEndDay.getValue();
  }

  public boolean isSelectedTimeRangeWebElementDisplayed(String timeRange) {
    return webDriver.findElement(By.cssSelector(f(SELECTED_TIME_RANGE_LOCATOR, timeRange)))
        .isDisplayed();
  }

  public boolean isCancelButtonEnable() {
    return cancelButton.isEnabled();
  }

  public boolean isSaveButtonEnable() {
    return saveButton.isEnabled();
  }

  public void clickOnSaveButton() {
    saveButton.click();
  }

  public void clickOnCancelButton() {
    cancelButton.click();
  }

  public String getTextFromNotificationMessage() {
    return getWebDriver().findElement(By.xpath(NOTIFICATION_MESSAGE_LOCATOR))
        .getAttribute(TEXT_CONTENT);
  }

  public void waitNotificationMessageInvisibility() {
    waitUntilInvisibilityOfElementLocated(NOTIFICATION_MESSAGE_LOCATOR, 20);
  }

  public String getTextFromNotificationDescription() {
    return getWebDriver().findElement(By.cssSelector(NOTIFICATION_DESCRIPTION_LOCATOR))
        .getAttribute(TEXT_CONTENT);
  }

  public WebElement getCalendarWebElementByDate(String date) {
    return webElement.findElement(
        By.xpath(f(CALENDAR_WEB_ELEMENT_LOCATOR, getDayFromFullDate(date))));
  }

  public boolean isTagDisplayedOnPickupJobByDate(String date, String tag) {
    moveToElement(getCalendarWebElementByDate(date));
    return getWebDriver().findElements(By.cssSelector(VISIBLE_SPAN_TAG_LOCATOR)).stream()
        .map(WebElement::getText).collect(Collectors.toList()).contains(tag);
  }

  private String getDayFromFullDate(String date) {
    String day = date.split("-")[2];
    if (day.split("")[0].equals("0")) {
      day = day.substring(1);
    }
    return day;
  }

  public String getColorAttributeInPickupJobFromCalendar(String date, String status) {
    return webDriver.findElement(
            By.cssSelector(f(CALENDAR_DAY_WEB_ELEMENT_LOCATOR, getDayFromFullDate(date))))
        .findElement(By.cssSelector(f(CALENDAR_STATUS_WEB_ELEMENT_LOCATOR, status)))
        .getAttribute(STYLE);
  }

  public List<String> getAllTagsFromJobTagsField() {
    return jobTagElements.stream().map(PageElement::getText).collect(Collectors.toList());
  }

  public String getCommentFromJobCommentField() {
    return commentField.getText();
  }

  public void removeAllTags() {
    moveToElement(tagsField.getWebElement());
    clearAllTags.click();
  }

  public boolean isParticularJobDisplayedByDateAndStatus(String date, String status) {
    try {
      return webDriver.findElement(
              By.cssSelector(f(CALENDAR_DAY_WEB_ELEMENT_LOCATOR, getDayFromFullDate(date))))
          .findElement(By.cssSelector(f(CALENDAR_STATUS_WEB_ELEMENT_LOCATOR, status)))
          .isDisplayed();
    } catch (NoSuchElementException noSuchElementException) {
      return false;
    }
  }
}
