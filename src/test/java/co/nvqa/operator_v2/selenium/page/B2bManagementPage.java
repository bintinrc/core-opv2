package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.Shipper;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;

/**
 * @author Lanang Jati
 */
public class B2bManagementPage extends OperatorV2SimplePage
{
    private final B2bShipperTable masterShipperTable;
    private final B2bShipperTable subShipperTable;

    private static final String LAST_URL_PATH = "/b2b-management";
    private static final String IFRAME_XPATH = "//iframe[contains(@src,'b2b-management')]";
    public static final String ID_COLUMN_MASTER_SHIPPER_LOCATOR_KEY = "id";
    public static final String ID_COLUMN_SUB_SHIPPER_LOCATOR_KEY = "externalRef";
    public static final String NAME_COLUMN_LOCATOR_KEY = "name";
    public static final String EMAIL_COLUMN_LOCATOR_KEY = "email";
    public static final int MASTER_SHIPPER_VIEW_SUB_SHIPPER_ACTION_BUTTON_INDEX = 3;

    public B2bManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        masterShipperTable = new B2bShipperTable(webDriver);
        subShipperTable = new B2bShipperTable(webDriver, ID_COLUMN_SUB_SHIPPER_LOCATOR_KEY, NAME_COLUMN_LOCATOR_KEY, EMAIL_COLUMN_LOCATOR_KEY);
    }

    public void onDisplay()
    {
        super.waitUntilPageLoaded();
        getWebDriver().switchTo().parentFrame();
        assertTrue(getWebDriver().getCurrentUrl().endsWith(LAST_URL_PATH));
        assertTrue(isElementExist(IFRAME_XPATH));
        getWebDriver().switchTo().parentFrame();
    }

    public B2bShipperTable getMasterShipperTable() {
        return masterShipperTable;
    }

    public B2bShipperTable getSubShipperTable() {
        return subShipperTable;
    }

    public static class B2bShipperTable extends AntTable<Shipper>
    {
        private static final String NAME_SEARCH_XPATH = "//th[contains(@class, 'name')]//input";
        private static final String EMAIL_SEARCH_XPATH = "//th[contains(@class, 'email')]//input";
        private static final String ROWS_XPATH = "//tbody/tr";
        private static final String ACTION_BUTTON_BY_COLUMN_VALUE_XPATH = "//tr[td[contains(@class,'%s') and descendant::*[contains(text(),'%s')]]]//button[%d]";


        public B2bShipperTable(WebDriver webDriver)
        {
            this(webDriver, ID_COLUMN_MASTER_SHIPPER_LOCATOR_KEY, NAME_COLUMN_LOCATOR_KEY, EMAIL_COLUMN_LOCATOR_KEY);
        }

        public B2bShipperTable(WebDriver webDriver, String idLocator, String nameLocator, String emailLocator)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(idLocator, "sellerId")
                    .put(nameLocator, "name")
                    .put(emailLocator, "email")
                    .build()
            );
            setEntityClass(Shipper.class);
        }

        @Override
        public int getRowsCount()
        {
            getWebDriver().switchTo().parentFrame();
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            int rowCount = getElementsCount(ROWS_XPATH);
            getWebDriver().switchTo().parentFrame();
            return rowCount;
        }

        @Override
        protected String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text;
            getWebDriver().switchTo().parentFrame();
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            String xpath = f(".//tr[%d]/td[contains(@class,'%s')]", rowNumber, columnDataClass);
            text = findElementByXpath(xpath).getText();
            getWebDriver().switchTo().parentFrame();
            return text;
        }

        public void clickActionButton(String columnLocatorKey, String value, int actionButtonIndex)
        {
            String columnLocator = columnLocators.get(columnLocatorKey);
            String xpath = f(ACTION_BUTTON_BY_COLUMN_VALUE_XPATH, columnLocator, value, actionButtonIndex);
            getWebDriver().switchTo().parentFrame();
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            click(xpath);
            getWebDriver().switchTo().parentFrame();
        }

        public void searchByName(String searchValue)
        {
            getWebDriver().switchTo().parentFrame();
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            doubleClick(NAME_SEARCH_XPATH);
            sendKeys(NAME_SEARCH_XPATH, searchValue);
            getWebDriver().switchTo().parentFrame();
        }

        public void searchByEmail(String searchValue)
        {
            getWebDriver().switchTo().parentFrame();
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            doubleClick(EMAIL_SEARCH_XPATH);
            sendKeys(EMAIL_SEARCH_XPATH, searchValue);
            getWebDriver().switchTo().parentFrame();
        }
    }
}
