package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.OperatorV2SimplePage;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;

import java.util.List;
import java.util.stream.Collectors;

public class PickupAppointmentJobPage extends OperatorV2SimplePage {
    @FindBy(css = "#shippers")
    private PageElement shipperIDField;

    @FindBy(css = "#dateRange")
    private Button selectDateRange;

    @FindBy(css = "div.ant-collapse-extra button")
    private Button createEditJobButton;

    @FindBy(css="[type='submit']")
    private PageElement loadSelection;

    @FindAll(@FindBy(css = ".BaseTable__table-frozen-left .BaseTable__row-cell-text"))
    private  List<PageElement> jobIdElements;

    @FindBy(css = ".ant-collapse-content-box")
    private PageElement contentBox;

    @FindBy(css = "[data-testid='resultTable.editButton']")
    private PageElement editButton;

    @FindBy(css = "#route")
    private PageElement routeIdInput;

    @FindBy(xpath = "//*[text()='Update route']/..")
    private PageElement updateRouteButton;

    @FindBy(css = "")
    private PageElement successJobButton;

    @FindBy(css = ".BaseTable")
    private PageElement jobTable;

    @FindBy(css = "#__next")
    private CreateOrEditJobPage createOrEditJobPage;

    @FindBy(css = "#toast-container")
    private PageElement toastContainer;
    public final String ID_NEXT = "__next";
    public final String MODAL_CONTENT_LOCAL = "div.ant-modal-content";
    public final String VERIFY_SHIPPER_FIELD_LOCATOR = "//input[@aria-activedescendant='shippers_list_0']";

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
        waitUntilVisibilityOfElementLocated(jobTable.getWebElement());
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

    public CreateOrEditJobPage clickOnCreateOrEditJob() {
        waitUntilElementIsClickable(createEditJobButton.getWebElement());
        createEditJobButton.click();
        return getCreateOrEditJobPage();
    }

    public CreateOrEditJobPage getCreateOrEditJobPage() {
        return new CreateOrEditJobPage(webDriver, getWebDriver().findElement(By.id(ID_NEXT)));
    }

    public Integer getNumberOfJobs() {
        return jobIdElements.size();
    }

    public boolean isToastContainerDisplayed() {
        try {
            return toastContainer.isDisplayed();
        } catch (NoSuchElementException e) {
            return false;
        }
    }
    public JobCreatedModalWindowPage getJobCreatedModalWindowElement() {
        return new JobCreatedModalWindowPage(webDriver, getWebDriver().findElement(By.cssSelector(MODAL_CONTENT_LOCAL)));
    }

    public boolean verifyMessageInToastModalIsDisplayed(String messageBody) {
        String xpathExpression = StringUtils.isNotBlank(messageBody)
                ? f("//div[@id='toast-container']//strong[contains(text(), '%s')]", messageBody)
                : "//div[@id='toast-container']";
        return webDriver.findElement(By.xpath(xpathExpression)).isDisplayed();
    }

    public PageElement getLoadSelection() {
        return loadSelection;
    }

}
