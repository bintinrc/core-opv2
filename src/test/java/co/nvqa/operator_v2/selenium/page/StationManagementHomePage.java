package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.StationLanguage;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.util.TestConstants;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.Wait;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Veera N
 */


@SuppressWarnings("WeakerAccess")
public class StationManagementHomePage extends OperatorV2SimplePage {

    private static final String STATION_HOME_URL_PATH = "/station-homepage";
    private static final String STATION_HUB_URL_PATH = "/station-homepage/hubs/%s";
    private static final String TILE_VALUE_XPATH = "//div[@class='ant-card-body'][.//*[.='%s']]//div[@class='value']";
    //private static final String TILE_VALUE_XPATH = ".//div[text()='%s']/ancestor::div[@class='ant-card-body']//div[@class='value']";
    private static final String TILE_HAMBURGER_XPATH = "//div[@class='ant-card-body'][.//*[.='%s']]//*[@role='img']";
    //private static final String TILE_HAMBURGER_XPATH = "//div[text()='%s']/ancestor::div[@class='ant-card-body']//*[@role='img']";
    private static final String MODAL_CONTENT_XPATH = "//span[contains(text(),'%s')]//ancestor::div//*[@class='ant-modal-content']";
    private static final String MODAL_TABLE_FILTER_XPATH = "//div[@class='th'][.//*[.='%s']]//input";
    //private static final String MODAL_TABLE_FILTER_XPATH = "//div[text()='%s']/parent::div[@class='th']//input";
    private static final String MODAL_TABLE_BY_TABLE_NAME_XPATH = "//div[contains(text(),'%s')]/parent::div/parent::div/following-sibling::div//div[@role='table']";
    private static final String MODAL_TABLE_FILTER_BY_TABLE_NAME_XPATH = "//*[contains(text(),'%s')]/ancestor::div[contains(@class,'card')]//div[text()='%s']/parent::div[@class='th']//input";
    private static final String LEFT_NAVIGATION_LINKS_BY_HEADER = "//div[text()='%s']/following-sibling::div//div[@class='link']//a | //div[text()='%s']/ancestor::div//div[@class='link-index']//following-sibling::div//a";
    private static final String HUB_SELECTION_COMBO_VALUE_XPATH = "(//div[text()='%s'])[2]//ancestor::div[@role='combobox']";
    private static final String TABLE_CONTENT_BY_COLUMN_NAME = "//div[contains(@data-datakey,'%s')]//span[@class]";


    public StationManagementHomePage(WebDriver webDriver) {
        super(webDriver);
    }

    @FindBy(id = "hint-link")
    public PageElement referParentsProfileLink;

    @FindBy(css = "iframe")
    private List<PageElement> pageFrame;

    @FindBy(xpath = "(//div[text()='Search or Select'])[2]//ancestor::div[@role='combobox']")
    public AntSelect2 hubs;

    @FindBy(xpath = "//button[contains(@*,'proceed')]")
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

    @FindBy(xpath = "//div[contains(@class,'modal-content')]//div[contains(@class,'th')]/*[1]")
    private List<PageElement> modalTableColumns;

    public void switchToStationHomeFrame() {
        getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }

    public void selectHubAndProceed(String hubName) {
        if (pageFrame.size() > 0) {
            waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
            switchToStationHomeFrame();
        }
        waitUntilVisibilityOfElementLocated("(//div[text()='Search or Select'])[2]", 30);
        hubs.enterSearchTerm(hubName);
        hubDropdownValues.click();
        proceedBtn.click();
        waitWhilePageIsLoading();
    }


    public void selectHubAndProceed(String hubName, StationLanguage.HubSelectionText language) {
        String langDropdownText = "";
        if (pageFrame.size() > 0) {
            waitUntilVisibilityOfElementLocated(pageFrame.get(0).getWebElement(), 15);
            switchToStationHomeFrame();
        }
        langDropdownText = language.getText();
        waitUntilVisibilityOfElementLocated(f("(//div[text()='%s'])[2]", langDropdownText), 30);
        WebElement hubs = getWebDriver().findElement(By.xpath(f(HUB_SELECTION_COMBO_VALUE_XPATH, langDropdownText)));
        AntSelect2 pageHubs = new AntSelect2(getWebDriver(), hubs);
        pageHubs.click();
        pageHubs.enterSearchTerm(hubName);
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
            if (pageFrame.size() > 0) {
                switchToStationHomeFrame();
            }
            waitUntilVisibilityOfElementLocated(tileValueXpath, 15);
            WebElement tile = getWebDriver().findElement(By.xpath(tileValueXpath));
            int actualCount = Integer.parseInt(tile.getText().trim());
            return actualCount;
        } catch (Exception e) {
            e.printStackTrace();
            return 100;
        }
    }

    public double getDollarValueFromTile(String tileName) {
        try {
            String tileValueXpath = f(TILE_VALUE_XPATH, tileName);
            waitWhilePageIsLoading();
            if (pageFrame.size() > 0) {
                switchToStationHomeFrame();
            }
            waitUntilVisibilityOfElementLocated(tileValueXpath, 15);
            WebElement tile = getWebDriver().findElement(By.xpath(tileValueXpath));
            String dollarAmount = tile.getText().trim().replaceAll("\\$|\\,","");
            double dollarValue = Double.parseDouble(dollarAmount);
            return dollarValue;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
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
        waitUntilVisibilityOfElementLocated(modalContent, 15);
        Assert.assertTrue("Assert that modal pop-up is opened",
                modalContent.isDisplayed());
    }

    public void validateHubURLPath(String hubId) {
        String expectedURLPath = f(STATION_HUB_URL_PATH, hubId);
        Assert.assertTrue("Assert that URL path is updated on selecting the hub",
                getCurrentUrl().endsWith(expectedURLPath));
    }

    public void validateStationURLPath() {
        waitUntilStationHomeUrlLoads(STATION_HOME_URL_PATH);
        Assert.assertTrue("Assert that URL path is updated with station management url",
                getCurrentUrl().endsWith(STATION_HOME_URL_PATH));
    }

    public void reloadURLWithNewHudId(String hubId) {
        String currentHubId = "";
        String currentUrl = getCurrentUrl();
        Pattern pattern = Pattern.compile("hubs.(\\d+)");
        Matcher matcher = pattern.matcher(currentUrl);
        if (matcher.find()) {
            currentHubId = matcher.group(1);
            Assert.assertTrue("Assert that the current hub id is extracted from the url ", currentHubId.length() > 0);
        }
        String newUrl = currentUrl.replace(currentHubId, hubId);
        getWebDriver().get(newUrl);
        Assert.assertTrue("Assert that URL path is updated with new hub id",
                getCurrentUrl().endsWith(hubId));
        getWebDriver().navigate().refresh();
    }

    public void waitUntilStationHomeUrlLoads(String partUrl) {
        Wait<WebDriver> fWait = new FluentWait<WebDriver>(getWebDriver())
                .withTimeout(Duration.ofSeconds(15))
                .pollingEvery(Duration.ofMillis(100))
                .ignoring(NoSuchElementException.class);
        fWait.until(driver -> {
            System.out.println(f("THE CURRENT URL IS %s", driver.getCurrentUrl()));
            return driver.getCurrentUrl().endsWith(partUrl);
        });
    }

    @FindBy(css = "div.ant-notification-notice-message")
    private PageElement toastMessage;

    public void verifyHubNotFoundToast(String message) {
        if (pageFrame.size() > 0) {
            switchToStationHomeFrame();
        }
        waitUntilVisibilityOfElementLocated(hubs.getWebElement());
        waitUntilVisibilityOfToastReact(message);
    }

    @FindBy(css = "div[class*='selected-value']")
    private PageElement headerHubValue;

    public void validateHeaderHubValue(String expectedHub) {
        refreshPage_v1();
        if (pageFrame.size() > 0) {
            switchToStationHomeFrame();
        }
        String actualHub = headerHubValue.getText().trim();
        Assert.assertTrue("Assert that the actual hub selected is as expected", actualHub.startsWith(expectedHub));
    }

    public void validateTileValueMatches(int beforeOrder, int afterOrder, int delta) {
        Assert.assertTrue("Assert that tile value after order equals the sum of before order count and # of order placed ",
                afterOrder == (beforeOrder + delta));
    }

    public void validateTileValueMatches(double beforeOrder, double afterOrder, double delta) {
        Assert.assertTrue("Assert that tile value after order equals the sum of before order count and # of order placed ",
            afterOrder == (beforeOrder + delta));
    }

    public void verifyTableIsDisplayedInModal(String tableName) {
        String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
        List<WebElement> modalTables = getWebDriver().findElements(By.xpath(tableXpath));
        int isDisplayed = modalTables.size();
        Assert.assertTrue(f("Assert that the table by name : %s is displayed", tableName),
                isDisplayed > 0);
    }

    public void verifyColumnsInTableDisplayed(String tableName, List<String> expectedColumns) {
        List<String> actualColumns = new ArrayList<String>();
        String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
        String tableColumnsXpath = tableXpath.concat("//div[contains(@class,'th')]/*[1]");
        List<WebElement> tableColumns = getWebDriver().findElements(By.xpath(tableColumnsXpath));
        tableColumns.forEach((tableColumn) -> actualColumns.add(tableColumn.getText().trim()));
        Assert.assertTrue(f("Assert that the table: %s has all columns as expected", tableName),
                actualColumns.containsAll(expectedColumns));
    }

    public void verifyColumnsInTableDisplayed(List<String> expectedColumns) {
        List<String> actualColumns = new ArrayList<String>();
        modalTableColumns.forEach((tableColumn) -> {
            scrollIntoView(tableColumn.getWebElement());
            actualColumns.add(tableColumn.getText().trim());
        });

        Assert.assertTrue("Assert that the table: has all columns as expected",
                actualColumns.containsAll(expectedColumns));
    }

    public void applyFilters(Map<String, String> filters, int resultsCount) {
        waitWhilePageIsLoading();
        for (Map.Entry<String, String> filter : filters.entrySet()) {
            String filterXpath = f(MODAL_TABLE_FILTER_XPATH, filter.getKey());
            scrollIntoView(filterXpath);
            List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
            if (filterFields.size() > 0) {
                filterFields.get(0).click();
                filterFields.get(0).sendKeys(filter.getValue());
            }
        }
        waitWhilePageIsLoading();
        Assert.assertTrue("Assert that the search has results as expected after applying filters",
                results.size() == resultsCount);
    }

    public void applyFilters(String tableName, Map<String, String> filters) {

        for (Map.Entry<String, String> filter : filters.entrySet()) {
            String filterXpath = f(MODAL_TABLE_FILTER_BY_TABLE_NAME_XPATH, tableName, filter.getKey());
            scrollIntoView(filterXpath);
            List<WebElement> filterFields = getWebDriver().findElements(By.xpath(filterXpath));
            if (filterFields.size() > 0) {
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

    public void verifyNavigationToEditOrderScreen(String expectedTrackingId) {
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

    public void verifyNavigationToRouteManifestScreen(String expectedRouteId) {
        waitWhilePageIsLoading();
        String windowHandle = getWebDriver().getWindowHandle();
        if (pageFrame.size() > 0) {
            switchToStationHomeFrame();
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

    public void loadOperatorPortal() {
        getWebDriver().get(TestConstants.OPERATOR_PORTAL_BASE_URL);
    }

    public void verifyLinksDisplayedInLeftPanel(String headerName, List<String> expectedNavLinks) {
        List<String> actualNavLinks = new ArrayList<String>();
        String linksXpath = f(LEFT_NAVIGATION_LINKS_BY_HEADER, headerName, headerName);
        List<WebElement> navLinks = getWebDriver().findElements(By.xpath(linksXpath));
        navLinks.forEach((navLink) -> actualNavLinks.add(navLink.getText().trim()));
        Assert.assertTrue(f("Assert that the header: %s has all navigation links as expected", headerName),
                actualNavLinks.containsAll(expectedNavLinks));
    }

    @FindBy(css = "div.nv-h4")
    private PageElement pageHeader;

    public void verifyPageOpenedOnClickingHyperlink(String linkName, String expectedPageName) {
        WebElement navLink = getWebDriver().findElement(By.linkText(linkName));
        navLink.click();
        switchToNewWindow();
        waitWhilePageIsLoading();
        String actualPageName = pageHeader.getText().trim();
        Assert.assertTrue("Assert that the expected page has opened in new tab from navigation links",
                actualPageName.contains(expectedPageName));
        closeAllWindowsExceptCurrentWindow();
        pause3s();
    }

    public void verifyPageUsingPageHeader(StationLanguage.HeaderText language) {
        waitWhilePageIsLoading();
        pause3s();
        getWebDriver().switchTo().defaultContent();
        waitUntilVisibilityOfElementLocated(pageHeader.getWebElement());
        String actualPageName = pageHeader.getText().trim();
        Assert.assertTrue(f("Assert that the expected page : %s has opened", language.getText()),
                actualPageName.contains(language.getText()));
    }

    @FindBy(css = "div.polling-time-info")
    public PageElement pollingTimeInfo;

    public void verifyPagePollingTimeInfo(StationLanguage.PollingTimeText language) {
        if (pageFrame.size() > 0) {
            switchToStationHomeFrame();
        }
        waitUntilVisibilityOfElementLocated(pollingTimeInfo.getWebElement());
        String actualText = pollingTimeInfo.getText().trim();
        Assert.assertTrue(f("Assert that the expected text : %s is displayed", language.getText()),
                actualText.contains(language.getText()));
    }


    @FindBy(css = "[id*='DialogTitle']")
    public PageElement dialogLanguage;

    public void verifyLanguageModalTextLanguage(StationLanguage.ModalText lang) {
        waitWhilePageIsLoading();
        if (pageFrame.size() > 0) {
            switchToStationHomeFrame();
        }
        waitUntilVisibilityOfElementLocated(dialogLanguage.getWebElement());
        String modalText = dialogLanguage.getText().trim();
        Assert.assertTrue(f("Assert that the text displayed is %s", lang), modalText.equals(lang.getText()));
    }


    public Map<String, String> getColumnContentByTableName(String tableName, String columnName, String columnValue ) {
        Map<String,String> tabContent = new HashMap<String, String>();
        String tableXpath = f(MODAL_TABLE_BY_TABLE_NAME_XPATH, tableName);
        String tableColumnNameXpath = f(tableXpath.concat(TABLE_CONTENT_BY_COLUMN_NAME), columnName);
        String tableColumnValueXpath = f(tableXpath.concat(TABLE_CONTENT_BY_COLUMN_NAME), columnValue);
        List<WebElement> tableColumnNames = getWebDriver().findElements(By.xpath(tableColumnNameXpath));
        List<WebElement> tableColumnValues = getWebDriver().findElements(By.xpath(tableColumnValueXpath));
        String rowName, rowValue;
        for(int row = 0; row < tableColumnNames.size(); row++){
            rowName = tableColumnNames.get(row).getText();
            rowValue = tableColumnValues.get(row).getText();
            tabContent.put(rowName, rowValue);
        }
        return tabContent;
    }

    @FindAll(@FindBy(xpath = "//div[contains(@class,'th')]/*[1]"))
    private List<PageElement> columnNames;

    @FindAll(@FindBy(css = "div[class='cell-wrapper']"))
    private List<PageElement> columnValues;

    public Map<String, String> getResultGridContent() {
        Map<String,String> gridContent = new HashMap<String, String>();
        String columnName, columnValue;
        pause3s();
        for(int row = 0; row < columnNames.size(); row++){
            scrollIntoView(columnNames.get(row).getWebElement());
            columnName = columnNames.get(row).getText();
            columnValue = columnValues.get(row).getText();
            gridContent.put(columnName, columnValue);
        }
        return gridContent;
    }
}
