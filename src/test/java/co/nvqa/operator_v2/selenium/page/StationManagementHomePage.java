package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.util.TestConstants;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindBy;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

/**
 * @author Veera N
 */
@SuppressWarnings("WeakerAccess")
public class StationManagementHomePage extends OperatorV2SimplePage {
    private static final String STATION_URL_PATH = "/station-homepage/hubs/%s";
    private static final String TILE_VALUE_XPATH = ".//div[text()='%s']/ancestor::div[@class='ant-card-body']//div[@class='value']";
    private static final String TILE_HAMBURGER_XPATH = "//div[text()='%s']/ancestor::div[@class='ant-card-body']//*[@role='img']";
    private static final String MODAL_CONTENT_XPATH = "//span[contains(text(),'%s')]//ancestor::div//*[@class='ant-modal-content']";
    private static final String MODAL_TABLE_FILTER_XPATH = "//div[text()='%s']/parent::div[@class='th']//input";
    private static final String MODAL_TABLE_BY_TABLE_NAME_XPATH = "//div[contains(text(),'%s')]/parent::div/parent::div/following-sibling::div//div[@role='table']";
    private static final String MODAL_TABLE_FILTER_BY_TABLE_NAME_XPATH = "//*[contains(text(),'%s')]/ancestor::div[contains(@class,'card')]//div[text()='%s']/parent::div[@class='th']//input";

    public StationManagementHomePage(WebDriver webDriver) {
        super(webDriver);
    }

    @FindBy(id = "hint-link")
    public PageElement referParentsProfileLink;

    @FindBy(css = "iframe")
    private List<PageElement> pageFrame;

    @FindBy(xpath = "(//div[text()='Search or Select'])[2]//ancestor::div[@role='combobox']")
    public AntSelect2 hubs;

    @FindBy(xpath = ".//span[text()='Proceed']")
    public PageElement proceedBtn;

    @FindBy(xpath = "//div[contains(@class,'row-cell-text')]")
    public PageElement hubDropdownValues;

    @FindBy(css = "div.ant-select")
    public AntSelect2 headerHub;

    @FindBy(xpath = "//div[contains(@class,'modal-content')]//div[contains(@class,'base-row')]")
    private List<PageElement> results;

    @FindBy(xpath = "//label[text()='Tracking ID']/following-sibling::h3")
    private PageElement editOrderTrackingId;

    @FindBy(xpath = "//div[text()='Route ID']/following-sibling::div")
    private PageElement routeManifestRouteId;


    public void switchTo() {
        getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }

    public void selectHubAndProceed(String hubName) {
        if(pageFrame.size() > 0){
            waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(),15);
            switchTo();
        }
        waitUntilVisibilityOfElementLocated("(//div[text()='Search or Select'])[2]", 30);
        hubs.enterSearchTerm(hubName);
        hubDropdownValues.click();
        proceedBtn.click();
        waitWhilePageIsLoading();
    }

    public void changeHubInHeaderDropdown(String hubName) {
        headerHub.click();
        headerHub.enterSearchTerm(hubName);
        hubDropdownValues.click();
        waitWhilePageIsLoading();
    }

    public int getNumberFromTile(String tileName) {
        try {
            String tileValueXpath = f(TILE_VALUE_XPATH, tileName);
            waitWhilePageIsLoading();
            if(pageFrame.size() > 0){
                switchTo();
            }
            waitUntilVisibilityOfElementLocated(tileValueXpath,15);
            WebElement tile = getWebDriver().findElement(By.xpath(tileValueXpath));
            int actualCount = Integer.parseInt(tile.getText().trim());
            return actualCount;
        } catch (Exception e) {
            e.printStackTrace();
            return 100;
        }
    }

    public void openModalPopup(String modalTitle, String tileName) {
        waitWhilePageIsLoading();
        String hamburgerXpath = f(TILE_HAMBURGER_XPATH, tileName);
        String titleXpath = f(MODAL_CONTENT_XPATH, modalTitle);
        WebElement hamburger = getWebDriver().findElement(By.xpath(hamburgerXpath));
        hamburger.click();
        waitWhilePageIsLoading();
        WebElement modalContent = getWebDriver().findElement(By.xpath(titleXpath));
        waitUntilVisibilityOfElementLocated(modalContent,15);
        Assert.assertTrue("Assert that modal pop-up is opened",
                modalContent.isDisplayed());
    }

    public void validateURLPath(String hubId) {
        String expectedURLPath = f(STATION_URL_PATH, hubId);
        Assert.assertTrue("Assert that URL path is updated on selecting the hub",
                getCurrentUrl().endsWith(expectedURLPath));
    }

    public void validateTileValueMatches(int beforeOrder, int afterOrder, int delta) {
        Assert.assertTrue("Assert that tile value after order equals the sum of before order count and # of order placed ",
                afterOrder == (beforeOrder + delta));
    }

    public void verifyTableIsDisplayedInModal(String tableName){
        String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
        List<WebElement> modalTables = getWebDriver().findElements(By.xpath(tableXpath));
        int isDisplayed = modalTables.size();
        Assert.assertTrue(f("Assert that the table by name : %s is displayed",tableName),
                isDisplayed > 0);
    }

    public void verifyColumnsInTableDisplayed(String tableName, List<String> expectedColumns){
        List<String> actualColumns = new ArrayList<String>();
        String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
        String tableColumnsXpath = tableXpath.concat("//div[contains(@class,'th')]/*[1]");
        List<WebElement> tableColumns = getWebDriver().findElements(By.xpath(tableColumnsXpath));
        //List<WebElement> tableColumns = getWebDriver().findElement(By.xpath(tableXpath)).findElements(By.cssSelector("div.th"));
        tableColumns.forEach( (tableColumn) -> actualColumns.add(tableColumn.getText().trim()));
        Assert.assertTrue(f("Assert that the table: %s has all columns as expected",tableName),
                actualColumns.containsAll(expectedColumns));
    }


    //div[@class='modal-content']//div[contains(@class,'th')]/*[1]
    @FindBy(xpath = "//div[contains(@class,'modal-content')]//div[contains(@class,'th')]/*[1]")
    private List<PageElement> modalTableColumns;

    public void verifyColumnsInTableDisplayed(List<String> expectedColumns){
        List<String> actualColumns = new ArrayList<String>();
        modalTableColumns.forEach( (tableColumn) -> {
            scrollIntoView(tableColumn.getWebElement());
            actualColumns.add(tableColumn.getText().trim());
        });

        Assert.assertTrue("Assert that the table: has all columns as expected",
                actualColumns.containsAll(expectedColumns));
    }

    public void applyFilters(Map<String,String> filters){

        for (Map.Entry<String, String> filter : filters.entrySet()) {
            String filterXpath = f(MODAL_TABLE_FILTER_XPATH,filter.getKey());
            scrollIntoView(filterXpath);
            List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
            if(filterFields.size() > 0){
                filterFields.get(0).click();
                filterFields.get(0).sendKeys(filter.getValue());
            }
        }
        waitWhilePageIsLoading();
        Assert.assertTrue("Assert that the search has results as expected after applying filters",
                results.size() > 0);
    }

    public void applyFilters(String tableName, Map<String,String> filters){

        for (Map.Entry<String, String> filter : filters.entrySet()) {
            String filterXpath = f(MODAL_TABLE_FILTER_BY_TABLE_NAME_XPATH, tableName, filter.getKey());
            scrollIntoView(filterXpath);
            List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
            if(filterFields.size() > 0){
                filterFields.get(0).click();
                filterFields.get(0).sendKeys(filter.getValue());
            }
        }
        waitWhilePageIsLoading();
        String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
        String tableRowsXpath = tableXpath.concat("//div[contains(@class,'base-row')]");
        List<WebElement> tableRows = getWebDriver().findElements(By.xpath(tableRowsXpath));
        Assert.assertTrue("Assert that the search has results as expected after applying filters",
                tableRows.size() > 0);
    }

    public void verifyNavigationToEditOrderScreen(String expectedTrackingId){
        String windowHandle = getWebDriver().getWindowHandle();
        WebElement trackingIdLink = getWebDriver().findElement(By.linkText(expectedTrackingId));
        trackingIdLink.click();
        switchToNewWindow();
        waitWhilePageIsLoading();
        String actualTrackingId = editOrderTrackingId.getText().trim();
        closeAllWindows(windowHandle);
        pause3s();
        Assert.assertTrue("Assert that the search has results as expected after applying filters",
                actualTrackingId.equalsIgnoreCase(expectedTrackingId));

    }

    public void verifyNavigationToRouteManifestScreen(String expectedRouteId){
        waitWhilePageIsLoading();
        String windowHandle = getWebDriver().getWindowHandle();
        if(pageFrame.size() > 0){
            switchTo();
        }
        WebElement routeIdLink = getWebDriver().findElement(By.linkText(expectedRouteId));
        routeIdLink.click();
        switchToNewWindow();
        waitWhilePageIsLoading();
        String actualRouteId = routeManifestRouteId.getText().trim();
        closeAllWindows(windowHandle);
        Assert.assertTrue("Assert that the search has results as expected after applying filters",
                actualRouteId.equalsIgnoreCase(expectedRouteId));
    }

    public void reloadOperatorPortal(){
        getWebDriver().get(TestConstants.OPERATOR_PORTAL_BASE_URL);
    }
}
