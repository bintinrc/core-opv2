package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.Shipper;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;

/**
 * @author Lanang Jati
 */
public class B2bManagementPage extends OperatorV2SimplePage
{
    private static final String LAST_URL_PATH = "/b2b-management";
    private static final String IFRAME_XPATH = "//iframe[contains(@src,'b2b-management')]";
    private final B2bShipperTable masterShipper;

    public B2bManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        masterShipper = new B2bShipperTable(webDriver);
    }

    public void onDisplay()
    {
        super.waitUntilPageLoaded();
        assertTrue(getWebDriver().getCurrentUrl().endsWith(LAST_URL_PATH));
    }

    public B2bShipperTable getMasterShipper() {
        return masterShipper;
    }

//    public boolean isShipperExist(long)

    public static class B2bShipperTable extends AntTable<Shipper>
    {
        private static final String NAME_SEARCH_XPATH = "//th[contains(@class, 'name')]//input";
        private static final String EMAIL_SEARCH_XPATH = "//th[contains(@class, 'email')]//input";

        public B2bShipperTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("id", "sellerId")
                    .put("name", "name")
                    .put("email", "email")
                    .build()
            );
            setEntityClass(Shipper.class);
        }

        @Override
        protected String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text;
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            String xpath = f(".//tr[%d]/td[contains(@class,'%s')]", rowNumber, columnDataClass);
            text = findElementByXpath(xpath).getText();
            getWebDriver().switchTo().parentFrame();
            return text;
        }

        public void clearSearchFields()
        {
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            doubleClick(NAME_SEARCH_XPATH);
            sendKeys(NAME_SEARCH_XPATH, "");
            getWebDriver().switchTo().parentFrame();
        }

        public void searchByName(String searchValue)
        {
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            doubleClick(NAME_SEARCH_XPATH);
            sendKeys(NAME_SEARCH_XPATH, searchValue);
            getWebDriver().switchTo().parentFrame();
        }

        public void searchByEmail(String searchValue)
        {
            getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
            doubleClick(EMAIL_SEARCH_XPATH);
            sendKeys(EMAIL_SEARCH_XPATH, searchValue);
            getWebDriver().switchTo().parentFrame();
        }
    }
}
