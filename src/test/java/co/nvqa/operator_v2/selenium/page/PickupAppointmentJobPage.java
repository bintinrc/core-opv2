package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.List;
import java.util.stream.Collectors;

public class PickupAppointmentJobPage extends OperatorV2SimplePage {
    @FindBy(css = "#shippers")
    public PageElement shipperIDField;

    @FindBy(css = "#dateRange")
    public Button selectDateRange;

    @FindBy(css = "div.ant-collapse-extra button")
    public Button createEditJobButton;

    @FindBy(css="[type='submit']")
    public PageElement loadSelection;

    @FindAll(@FindBy(css = ".BaseTable__table-frozen-left .BaseTable__row-cell-text"))
    public  List<PageElement> jobIdElements;

    @FindBy(css = ".ant-collapse-content-box")
    public PageElement contentBox;

    @FindBy(css = "[data-testid='resultTable.editButton']")
    public PageElement editButton;

    @FindBy(css = "#route")
    public PageElement routeIdInput;

    @FindBy(xpath = "//*[text()='Update route']/..")
    public PageElement updateRouteButton;

    @FindBy(css = "")
    public PageElement successJobButton;

    @FindBy(css = ".BaseTable")
    public PageElement jobTable;

    @FindBy(css = "#__next")
    private CreateOrEditJobElement createOrEditJobElement;
    public final String ID_NEXT = "__next";
    public final String MODAL_CONTENT_LOCAL = "div.ant-modal-content";
    public final String VERIFY_SHIPPER_FIELD_LOCATOR = "//input[@aria-activedescendant='shipper_list_0']";

    public final String VERIFY_ROUTE_FIELD_LOCATOR = "//input[@aria-activedescendant='route_list_0']";

    public final String CALENDAR_DAY_BY_TITLE_LOCATOR = "td[title='%s']";

    public PickupAppointmentJobPage(WebDriver webDriver) {
        super(webDriver);
    }

    public PickupAppointmentJobPage clickLoadSelectionButton(){
        contentBox.click();
        loadSelection.click();
        return this;
    }

    public PickupAppointmentJobPage clickEditButton(){
        editButton.click();
        return this;
    }

    public PickupAppointmentJobPage setRouteId(String routeId){
        waitUntilVisibilityOfElementLocated(routeIdInput.getWebElement());
        routeIdInput.sendKeys(routeId);
        waitUntilVisibilityOfElementLocated(VERIFY_ROUTE_FIELD_LOCATOR);
        routeIdInput.sendKeys(Keys.ENTER);
        return this;
    }

    public PickupAppointmentJobPage clickUpdateRouteButton(){
        updateRouteButton.click();
        return this;
    }

    public PickupAppointmentJobPage clickSuccessJobButton(){
        waitUntilVisibilityOfElementLocated(successJobButton.getWebElement());
        successJobButton.click();
        return this;
    }

    public List<String> getJobIdsText(){
        waitUntilVisibilityOfElementLocated(jobIdElements.get(0).getWebElement());
        return jobIdElements.stream().map(PageElement::getText).collect(Collectors.toList());
    }

    public PickupAppointmentJobPage setShipperIDInField(String shipperID) {
        sendTextInFieldAndChooseData(shipperIDField, shipperID, VERIFY_SHIPPER_FIELD_LOCATOR);
        return this;
    }

    private void sendTextInFieldAndChooseData(PageElement field, String data, String verifyLocator) {
        field.sendKeys(data);
        waitUntilVisibilityOfElementLocated(verifyLocator);
        field.sendKeys(Keys.ENTER);
    }

    public PickupAppointmentJobPage selectDataRangeByTitle(String dayStart, String dayEnd) {
        selectDateRange.click();
        waitUntilVisibilityOfElementLocated(webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart))));
        webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayStart))).click();
        webDriver.findElement(By.cssSelector(String.format(CALENDAR_DAY_BY_TITLE_LOCATOR, dayEnd))).click();
        return this;
    }

    public CreateOrEditJobElement clickOnCreateOrEditJob() {
        waitUntilElementIsClickable(createEditJobButton.getWebElement());
        createEditJobButton.click();
        return getCreateOrEditJobElement();
    }

    public CreateOrEditJobElement getCreateOrEditJobElement() {
        return new CreateOrEditJobElement(webDriver, getWebDriver().findElement(By.id(ID_NEXT)));
    }

    public Integer getNumberOfJobs() {
        return jobIdElements.size();
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

        @FindBy(css = "#readyBy")
        public PageElement readyByField;
        @FindBy(css = "#latestBy")
        public PageElement latestByField;

        public final String VERIFY_SHIPPER_FIELD_LOCATOR = "//input[@aria-activedescendant='shipper_list_0']";
        public final String VERIFY_ADDRESS_FIELD_LOCATOR = "//input[@aria-activedescendant='shipperAddress_list_0']";
        public final String TITLE_LOCATOR_FOR_VERIFY_ELEMENT = "span[title='%s']";
        public final String CALENDAR_DAY_BY_TITLE_LOCATOR = "td[title='%s']";
        public final String TIME_RANGE_FILTER_LOCATOR = "input[aria-activedescendant='%s']";
        public final String TIME_RANGE_NUMBER_OF_LIST = "timeRange_list_%d";
        public final String READY_BY_NUMBER_OF_LIST = "readyBy_list_%d";
        public final String LATEST_BY_NUMBER_OF_LIST = "latestBy_list_%d";
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
        }

        public void selectTimeRangeByDataTime(String timeRange) {
            selectTimeRange.click();
            switch (timeRange) {
                case ("09:00 - 22:00"):
                    chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(TIME_RANGE_NUMBER_OF_LIST, 0), selectTimeRange);
                    break;
                case ("09:00 - 18:00"):
                    chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(TIME_RANGE_NUMBER_OF_LIST, 1), selectTimeRange);
                    break;
                case ("09:00 - 12:00"):
                    chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(TIME_RANGE_NUMBER_OF_LIST, 2), selectTimeRange);
                    break;
                case ("12:00 - 15:00"):
                    chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(TIME_RANGE_NUMBER_OF_LIST, 3), selectTimeRange);
                    break;
                case ("15:00 - 18:00"):
                    chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(TIME_RANGE_NUMBER_OF_LIST, 4), selectTimeRange);
                    break;
                case ("18:00 - 22:00"):
                    chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(TIME_RANGE_NUMBER_OF_LIST, 5), selectTimeRange);
                    break;
                default:
                    chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(TIME_RANGE_NUMBER_OF_LIST, 6), selectTimeRange);
            }
            waitUntilVisibilityOfElementLocated(createButton.getWebElement());
        }

        private void chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String time, PageElement filterElement) {
            do {
                filterElement.sendKeys(Keys.ARROW_DOWN);
            } while (isTimeElementDisplayed(time, filterElement));

            webDriver.findElement(By.cssSelector(String.format(TIME_RANGE_FILTER_LOCATOR, time))).sendKeys(Keys.ENTER);
        }

        private boolean isTimeElementDisplayed(String time, PageElement filterElement) {
            if (time.equals(filterElement.getAttribute(ARIA_ACTIVEDESCENDANT))) {
                return false;
            } else return true;
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
            } else correctConst = LATEST_BY_NUMBER_OF_LIST;
            chooseCorrectTimeFromAttributeUsingTimeAndWebElement(String.format(correctConst, time), fieldElement);
        }
        public boolean verifyMessageInToastModalIsDisplayed(String messageBody) {
            String xpathExpression = StringUtils.isNotBlank(messageBody)
                    ? f("//div[@id='toast-container']//strong[contains(text(), '%s')]", messageBody)
                    : "//div[@id='toast-container']";
            return findElement(By.xpath(xpathExpression)).isDisplayed();
        }

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

        @FindBy(css = "div.ant-modal-footer button")
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
