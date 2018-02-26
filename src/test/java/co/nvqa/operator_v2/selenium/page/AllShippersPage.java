package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class AllShippersPage extends OperatorV2SimplePage
{
    private CreateEditShipperPage createEditShipperPage;

    public AllShippersPage(WebDriver webDriver)
    {
        super(webDriver);
        createEditShipperPage = new CreateEditShipperPage(webDriver);
    }

    public void createNewShipperV4()
    {
        clickNvIconTextButtonByName("container.shippers.create-shipper");
        createEditShipperPage.createNewShipperV4();
    }
}
