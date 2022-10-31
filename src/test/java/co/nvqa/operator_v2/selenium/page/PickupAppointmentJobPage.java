package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterDateBox;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.PageFactoryFinder;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;

public class PickupAppointmentJobPage extends OperatorV2SimplePage {
    @FindBy(css = "input[aria-owns=shipper_list]")
    public PageElement shipperIDField;

    @FindBy(css = "div.ant-collapse-extra button")
    public Button createEditJobButton;

    @FindBy(css = "button[type=submit]")
    public NvApiTextButton loadSelection;

    @FindBy(css = "#shippers")
    public NvFilterBox shippersFilter;

    @FindBy(css = "#__next")
    private CreateOrEditJobElement createOrEditJobElement;
    public final String ID_NEXT = "__next";
    public final String MODAL_CONTENT_LOCAL = "div.ant-modal-content";

    public PickupAppointmentJobPage(WebDriver webDriver) {
        super(webDriver);
    }

    public static class CreateOrEditJobElement extends PageElement {

        @FindBy(css = "input[aria-owns=shipper_list]")
        public PageElement shipperIDField;

        @FindBy(css = "input[aria-owns=shipperAddress_list]")
        public PageElement shipperAddress;

        @FindBy(css = "#dateRange")
        public Button selectDateRange;

        @FindBy(css = "input[aria-owns=timeRange_list]")
        public PageElement selectTimeRange;

        @FindBy(css = "div.ant-space-align-center button")
        public Button createButton;

        public final String VERIFY_SHIPPER_FIELD_LOCATOR = "//input[@aria-activedescendant='shipper_list_0']";
        public final String VERIFY_ADDRESS_FIELD_LOCATOR = "//input[@aria-activedescendant='shipperAddress_list_0']";
        public final String TITLE_LOCATOR_FOR_VERIFY_ELEMENT = "span[title='%s']";
        public final String CALENDAR_DAY_BY_TITLE_LOCATOR = "td[title='%s']";
        public final String TIME_RANGE_FILTER_LOCATOR = "input[aria-activedescendant='%s']";
        public final String TIME_RANGE_NUMBER_OF_LIST = "timeRange_list_%d";
        public final String ARIA_ACTIVEDESCENDANT = "aria-activedescendant";
        public final String PICKUP_JOBS_CALENDAR_LOCATOR = "div[status='ready-for-routing']";

        public CreateOrEditJobElement(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public CreateOrEditJobElement(WebDriver webDriver, String xpath) {
            super(webDriver, xpath);
        }

        public CreateOrEditJobElement(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
            super(webDriver, searchContext, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public CreateOrEditJobElement(WebDriver webDriver) {
            super(webDriver);
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
            return webDriver.findElement(By.cssSelector(String.format(TITLE_LOCATOR_FOR_VERIFY_ELEMENT, title))).isDisplayed();
        }

        public boolean isCreateButtonDisplayed() {
            waitUntilVisibilityOfElementLocated(createButton.getWebElement());
            return createButton.isDisplayed();
        }

        public void selectDataRangeByTitle(String dayStart, String dayEnd) {
            selectDateRange.click();
            waitUntilVisibilityOfElementLocated(webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart))));
            webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart))).click();
            webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayEnd))).click();
            waitUntilVisibilityOfElementLocated(createButton.getWebElement());
        }

        public void selectTimeRangeByDataTime(String timeRange) {
            selectTimeRange.click();
            switch (timeRange) {
                case ("09:00 - 22:00"):
                    chooseCorrectTimeRange(String.format(TIME_RANGE_NUMBER_OF_LIST, 0));
                    break;
                case ("09:00 - 18:00"):
                    chooseCorrectTimeRange(String.format(TIME_RANGE_NUMBER_OF_LIST, 1));
                    break;
                case ("09:00 - 12:00"):
                    chooseCorrectTimeRange(String.format(TIME_RANGE_NUMBER_OF_LIST, 2));
                    break;
                case ("12:00 - 15:00"):
                    chooseCorrectTimeRange(String.format(TIME_RANGE_NUMBER_OF_LIST, 3));
                    break;
                case ("15:00 - 18:00"):
                    chooseCorrectTimeRange(String.format(TIME_RANGE_NUMBER_OF_LIST, 4));
                    break;
                case ("18:00 - 22:00"):
                    chooseCorrectTimeRange(String.format(TIME_RANGE_NUMBER_OF_LIST, 5));
                    break;
                default:
                    chooseCorrectTimeRange(String.format(TIME_RANGE_NUMBER_OF_LIST, 6));
            }
        }

        private void chooseCorrectTimeRange(String timeRangeListNumber) {
            do {
                selectTimeRange.sendKeys(Keys.ARROW_DOWN);
            } while (isTimeRangeElementDisplayed(timeRangeListNumber));

            webDriver.findElement(By.cssSelector(String.format(TIME_RANGE_FILTER_LOCATOR, timeRangeListNumber))).sendKeys(Keys.ENTER);
        }

        private boolean isTimeRangeElementDisplayed(String timeRangeListNumber) {
            if (timeRangeListNumber.equals(selectTimeRange.getAttribute(ARIA_ACTIVEDESCENDANT))) {
                return false;
            } else return true;
        }

        public void clickOnCreateButton() {
            createButton.click();
        }

        public List<WebElement> getAllPickupJobsFromCalendar() {
            return webDriver.findElements(By.cssSelector(PICKUP_JOBS_CALENDAR_LOCATOR));
        }

    }

    public void clickOnCreateOrEditJob() {
        waitUntilElementIsClickable(createEditJobButton.getWebElement());
        createEditJobButton.click();
    }

    public CreateOrEditJobElement getCreateOrEditJobElement() {
        return new CreateOrEditJobElement(webDriver, getWebDriver().findElement(By.id(ID_NEXT)));
    }

    public static class JobCreatedModalWindowElement extends PageElement {

        @FindBy(xpath = "//div[span[text()='Shipper name:']]//following-sibling::span")
        public TextBox shipperName;

        @FindBy(xpath = "//div[span[text()='Shipper address:']]//following-sibling::span")
        public TextBox shipperAddress;

        @FindBy(xpath = "//div[span[text()='Ready by:']]//following-sibling::span")
        public TextBox startTime;

        @FindBy(xpath = "//div[span[text()='Latest by:']]//following-sibling::span")
        public TextBox endTime;

        @FindBy(xpath = "//span[span[text()='Jobs created for the following dates:']]//following-sibling::span")
        public TextBox dates;

        @FindBy(xpath = "div.ant-modal-footer button")
        public Button okButton;

        public JobCreatedModalWindowElement(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public String getShipperNameString() {
            return shipperName.getText();
        }

        public String getShipperAddressString() {
            return shipperAddress.getText();
        }

        public String getStartTimeString() {
            return startTime.getText();
        }

        public String getEndTimeString() {
            return endTime.getText();
        }

        public String getDatesString() {
            return dates.getText();
        }

        public void clickOnOKButton() {
            okButton.click();
        }
    }

    public JobCreatedModalWindowElement getJobCreatedModalWindowElement() {
        return new JobCreatedModalWindowElement(webDriver, getWebDriver().findElement(By.cssSelector(MODAL_CONTENT_LOCAL)));
    }

}
