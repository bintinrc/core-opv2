package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Sergey Mishanin
 */
public class NvDashboardPage extends OperatorV2SimplePage
{
    private static final String USER_INFO_XPATH = "//span[contains(@class, 'username')]";
    private static final String MENU_LEVEL_1_XPATH = "//li[@ng-repeat='item in menu']/a[normalize-space(.)='%s']";
    private static final String MENU_LEVEL_2_XPATH = "//li[@ng-repeat='child in item.children']/a[normalize-space(.)='%s']";
    private static final String PICKUP_ADDRESS_XPATH = "//select[@name='shipper_address_id']";

    public NvDashboardPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        wait10sUntil(() -> getWebDriver().getCurrentUrl().contains("/orders/management/"));
        waitUntilVisibilityOfElementLocated(USER_INFO_XPATH, 10);
        waitUntilInvisibilityOfElementLocated(By.id("loading"));
    }

    public void validateUserInfo(String username, String email)
    {
        waitUntilPageLoaded();
        retryIfAssertionErrorOccurred(() -> assertEquals("Username and email", username + "\n" + email, getText(USER_INFO_XPATH)), "Validate User Info");
    }

    public void selectMenuItem(String item1, String item2)
    {
        String xpath = String.format(MENU_LEVEL_1_XPATH, item1);
        waitUntilVisibilityOfElementLocated(xpath);
        click(xpath);
        xpath = String.format(MENU_LEVEL_2_XPATH, item2);
        waitUntilVisibilityOfElementLocated(xpath);
        click(xpath);
    }

    public void validatePickupAddressExists(Address address)
    {
        waitUntilVisibilityOfElementLocated(PICKUP_ADDRESS_XPATH);
        List<String> addresses = getSelectElementOptions(PICKUP_ADDRESS_XPATH).stream()
                .map(StringUtils::normalizeSpace)
                .collect(Collectors.toList());
        String expectedAddress = address.to1LineAddressWithPostcode().replaceAll(",", "").toUpperCase();
        assertThat("List of available addresses", addresses, hasItem(expectedAddress));
    }
}
