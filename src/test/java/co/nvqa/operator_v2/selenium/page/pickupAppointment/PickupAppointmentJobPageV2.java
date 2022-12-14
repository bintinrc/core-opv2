package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;

import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import org.openqa.selenium.By;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.slf4j.Logger;

import static org.slf4j.LoggerFactory.getLogger;

public class PickupAppointmentJobPageV2 extends SimpleReactPage<PickupAppointmentJobPageV2> {

  Logger LOGGER = getLogger(PickupAppointmentJobPage.class);

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
  @FindBy(css = ".ant-notification")
  public PickupPageNotification notificationModal;
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

    public final String shipperListItem = "//div[@legacyshipperid='%s']";
    public final String shipperAddressListItem = "//div[@label='%s']";

    public final String DELETE_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.cancel.%s']";

    public final String EDIT_BUTTON_IN_CALENDAR_LOCATOR = "div[data-testid='paJob.edit.%s']";

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


  public static class PickupPageNotification extends AntNotification {
    public PickupPageNotification(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }
  }

}
