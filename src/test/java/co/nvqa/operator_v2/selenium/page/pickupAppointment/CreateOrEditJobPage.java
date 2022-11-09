package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.openqa.selenium.*;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.List;

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
    private  Actions actions;

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
        actions = new Actions(webDriver);
        WebElement customTimeRange = webDriver.findElement(By.cssSelector(f(TIME_RANGE_FILTER_LABEL, timeRange)));
        actions.moveToElement(customTimeRange);
        actions.perform();
        customTimeRange.click();
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
    public void waitLoadJobInTheCalendarDisplayed(String date){
        String day = date.split("-")[2];
        if(day.split("")[0].equals("0")){
            day = day.substring(1);
        }
        waitUntilVisibilityOfElementLocated(f(".//*[@data-testid='paJobCalendar.day.%s']//*[@status='ready-for-routing']",day));
    }

    public void selectTagInJobTagsField(String tag) {
        tagsField.sendKeys(tag);
//        actions = new Actions(webDriver);
        WebElement tagElement = webDriver.findElement(By.cssSelector(f(JOB_TAG_FILTER_LOCATOR, tag)));
//        actions.moveToElement(tagElement);
//        actions.perform();
        tagElement.sendKeys(Keys.ENTER);
        tagsField.click();
    }

    public PageElement getReadyByField() {
        return readyByField;
    }

    public PageElement getLatestByField() {
        return latestByField;
    }
}
