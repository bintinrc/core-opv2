package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.support.CommonUtil;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TransactionsPage extends SimplePage
{
    public TransactionsPage(WebDriver driver)
    {
        super(driver);
    }

    public void selectVariable(String routeGroupTemplateName)
    {
        click("//md-select[@aria-label='Select variable..']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routeGroupTemplateName));
    }

    public void clickLoadAllEntriesButton()
    {
        click("//button[@aria-label='Load Selection']");
    }

    public void selectShipperFilter(String shipperId) {
        String xpathExpression = "//div[div[p[text()='Shipper']]]/div/nv-autocomplete/div/label/md-autocomplete/md-autocomplete-wrap";
        click(xpathExpression);
        sendKeysAndEnter(xpathExpression + "/input", shipperId);
    }

    public void searchTrackingId(String trackingId) {
        CommonUtil.columnSearchTable(getDriver(), "Tracking ID", trackingId);
    }

    public void selectAllShown()
    {
        click("//button[@aria-label='Selection']");
        pause100ms();
        click("//button[@aria-label='Select All Shown']");
        pause100ms();
    }

    public void clickAddToRouteGroupButton()
    {
        click("//button[@aria-label='Add to Route Group']");
        pause100ms();
    }

    public void selectRouteGroupOnAddToRouteGroupDialog(String routeGroupName)
    {
        click("//md-select[@aria-label='Route Group']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routeGroupName));
        pause100ms();
    }

    public void clickAddTransactionsOnAddToRouteGroupDialog()
    {
        click("//button[@aria-label='Save Button']");

    }
}
