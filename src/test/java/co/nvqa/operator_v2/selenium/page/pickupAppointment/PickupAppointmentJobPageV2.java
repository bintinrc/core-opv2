package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;

import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import co.nvqa.operator_v2.selenium.page.ToastInfo;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class PickupAppointmentJobPageV2 extends SimpleReactPage<PickupAppointmentJobPageV2> {

  Logger LOGGER = getLogger(PickupAppointmentJobPageV2.class);

  public PickupAppointmentJobPageV2(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(css = "#toast-container")
  private PageElement toastContainer;


  @FindBy(css = "[type='submit']")
  private PageElement loadSelection;
  @FindBy(xpath = "//a[text()='Create / edit job']")
  private Button createEditJobButton;
  @FindBy(xpath = "//span[text()='Create or edit job']//ancestor::div[@id='__next']")
  public CreateOrEditJobPage createOrEditJobPage;
  @FindBy(className = "ant-modal-wrap")
  public DeletePickupJobModal deletePickupJobModal;

  @FindBy(className = "ant-modal-wrap")
  public JobCreatedModal jobCreatedModal;
  @FindBy(css = ".ant-notification")
  public PickupPageNotification notificationModal;
  @FindBy(xpath = "//div[@id='toast-container']")
  public PickupPageErrorNotification pickupPageErrorNotification;

  public boolean isToastContainerDisplayed() {
    try {
      return toastContainer.isDisplayed();
    } catch (NoSuchElementException e) {
      return false;
    }
  }

  public PageElement getLoadSelection() {
    return loadSelection;
  }

  public void clickOnCreateOrEditJob() {
    waitUntilElementIsClickable(createEditJobButton.getWebElement());
    createEditJobButton.click();
  }

  public static class CreateOrEditJobPage extends PageElement {

    @FindBy(css = "input[id='shipper']")
    private PageElement shipperIDField;
    @FindBy(css = "input[id='shipperAddress']")
    private PageElement shipperAddressField;
    @FindBy(xpath = "//span[text()='Create']/parent::button")
    private Button createButton;

    @FindBy(css = "#dateRange")
    private Button selectDateRange;

    @FindBy(css = "input[aria-owns=timeRange_list]")
    private PageElement selectTimeRange;

    @FindBy(css = "#tags")
    private PageElement tagsField;
    @FindBy(css = "#readyBy")
    private PageElement readyByField;
    @FindBy(css = "#latestBy")
    private PageElement latestByField;
    @FindBy(css = "#comments")
    public PageElement commentsInput;


    public final String timeScrollBar = ".rc-virtual-list-scrollbar";
    public final String shipperListItem = "//div[@legacyshipperid='%s']";
    public final String shipperAddressListItem = "//div[@label='%s']";

    public final String DELETE_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.cancel.%s']";

    public final String EDIT_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.edit.%s']";
    public final String CALENDAR_DAY_BY_TITLE_LOCATOR = "td[title='%s']";

    public final String TIME_RANGE_FILTER_BY_LABEL_LOCATOR = "div[label='%s']";
    public final String JOB_TAG_FILTER_LOCATOR = "div[label='%s']";
    public final String JOB_CUSTOM_TIME_FILTER_LOCATOR = "//div[@label='%s']";

    public final String LAST_ITEM_IN_TIME_LIST = "//div[@class='rc-virtual-list-holder-inner']/descendant::div[@class='ant-select-item ant-select-item-option'][last()]";

    public final String Time_LIST_LOCATR = "//div[@id='%s']/parent::div";

    public CreateOrEditJobPage(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void clickDeleteButton(String jobId) {
      WebElement deleteButton = getWebDriver().findElement(
          By.cssSelector(f(DELETE_BUTTON_IN_CALENDAR_LOCATOR, jobId)));
      deleteButton.click();
    }

    public void fillShipperIdField(String shipperID) {
      shipperIDField.sendKeys(shipperID);
    }

    public void selectShipperFromList(String shipperID) {
      WebElement shipperItem = getWebDriver().findElement(By.xpath(f(shipperListItem, shipperID)));
      shipperItem.click();
    }

    public void fillShipperAddressField(String address) {
      shipperAddressField.sendKeys(address);
    }

    public void selectShipperAddressFromList(String address) {
      WebElement addressItem = getWebDriver().findElement(
          By.xpath(f(shipperAddressListItem, address)));
      addressItem.click();
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


    public boolean isCreateButtonDisabled() {
      try {

        return createButton.isEnabled();
      } catch (NoSuchElementException noSuchElementException) {
        return false;
      }
    }

    public void clickCreateButton() {
      createButton.click();
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

    public void selectTimeRange(String timeRange) {
      selectTimeRange.click();

      WebElement customTimeRange = webDriver.findElement(
          By.cssSelector(f(TIME_RANGE_FILTER_BY_LABEL_LOCATOR, timeRange)));
      retryIfRuntimeExceptionOccurred(() -> {
        customTimeRange.click();
      });

    }

    public void selectTagInJobTagsField(String tag) {
      tagsField.click();
      WebElement tagElement = webDriver.findElement(By.cssSelector(f(JOB_TAG_FILTER_LOCATOR, tag)));

      tagElement.click();
      tagsField.sendKeys(Keys.ESCAPE);
    }


    public void selectReadybyTime(String time) {
      readyByField.click();
      scrollToTimeIfNeeded(time, "readyBy_list");
      retryIfRuntimeExceptionOccurred(() -> {

        WebElement timeToPick = webDriver.findElement(
            By.xpath(
                f(Time_LIST_LOCATR, "readyBy_list") + f(JOB_CUSTOM_TIME_FILTER_LOCATOR, time)));
        timeToPick.click();

      });

    }


    public void selectLatestbyTime(String time) {
      latestByField.click();

      scrollToTimeIfNeeded(time, "latestBy_list");

      retryIfRuntimeExceptionOccurred(() -> {
        WebElement timeToPick = webDriver.findElement(
            By.xpath(
                f(Time_LIST_LOCATR, "latestBy_list") + f(JOB_CUSTOM_TIME_FILTER_LOCATOR, time)));
        timeToPick.click();

      });

    }

    public void scrollToTimeIfNeeded(String time, String listName) {
      int neededTime = Integer.parseInt(List.of(time.split(":")).get(0));
      String lastElementTime = webDriver.findElement(
          By.xpath(f(Time_LIST_LOCATR, listName) + LAST_ITEM_IN_TIME_LIST)).getAttribute("label");
      int lastTime = Integer.parseInt(List.of(lastElementTime.split(":")).get(0));
      if (lastTime <= neededTime) {
        WebElement readyTimeList = webDriver.findElement(By.xpath(f(Time_LIST_LOCATR, listName)));
        WebElement timeToScroll = readyTimeList.findElement(
            By.xpath(f(JOB_CUSTOM_TIME_FILTER_LOCATOR, lastElementTime)));
        scrollIntoView(timeToScroll, true);
      }
    }

    public void addJobComments(String comment) {
      commentsInput.sendKeys(comment);
    }

  }


  public static class DeletePickupJobModal extends AntModal {

    @FindBy(xpath = "//span[text()='Submit']/parent::button")
    public PageElement submitButton;
    public final String ITEMS_ON_DELETE_JOB_MODAL = "//div[span[text()='%s']]//following-sibling::div//span";

    public DeletePickupJobModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getFieldTextOnDeleteJobModal(String fieldName) {
      waitUntilVisibilityOfElementLocated(
          webDriver.findElement(By.xpath(f(ITEMS_ON_DELETE_JOB_MODAL, fieldName))));
      return webDriver.findElement(By.xpath(f(ITEMS_ON_DELETE_JOB_MODAL, fieldName))).getText();
    }
  }


  public static class JobCreatedModal extends AntModal {

    @FindBy(xpath = "//span[text()='Ok']/parent::button")
    public PageElement okButton;
    public final String ITEMS_ON_JOB_CREATED_MODAL = "//span[text()='%s']//following-sibling::span";

    public final String ALERT_TEXT = "//span[contains(text(),'%s')]";

    public JobCreatedModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getFieldTextOnJobCreatedModal(String fieldName) {
      waitUntilVisibilityOfElementLocated(
          webDriver.findElement(By.xpath(f(ITEMS_ON_JOB_CREATED_MODAL, fieldName))));
      return webDriver.findElement(By.xpath(f(ITEMS_ON_JOB_CREATED_MODAL, fieldName))).getText();
    }

    public String getErrorMessageWithText(String message) {
      waitUntilVisibilityOfElementLocated(
          webDriver.findElement(By.xpath(f(ALERT_TEXT, message))));
      return webDriver.findElement(By.xpath(f(ALERT_TEXT, message))).getText();
    }
  }


  public static class PickupPageNotification extends AntNotification {

    public PickupPageNotification(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

  public static class PickupPageErrorNotification extends ToastInfo {

    public PickupPageErrorNotification(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

}
