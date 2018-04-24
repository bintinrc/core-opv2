package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class OpsRoutePage extends OperatorV2SimplePage
{
    public static final String NG_REPEAT = "opsRoute in $data";
    public static final String COLUMN_CLASS_DATA_ROUTE_ID = "routeId";
    public static final String ACTION_BUTTON_EDIT = "Edit";

    public OpsRoutePage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickEditButton(int rowNumber)
    {
        clickActionButtonOnTableWithNgRepeat(rowNumber, ACTION_BUTTON_EDIT, NG_REPEAT);
        pause200ms();
    }

    public void setRouteId(String routeId)
    {
        sendKeys("//input[@aria-label='commons.model.route-id']", routeId);
    }

    public void clickSubmitChangesOnEditOpsRouteDialog()
    {
        click("//button[@aria-label='Save Button']");
        pause1s();
    }

    public void editOpsRoute(int editedRouteRowNumber, String newRouteId)
    {
        clickEditButton(editedRouteRowNumber);
        setRouteId(newRouteId);
        clickSubmitChangesOnEditOpsRouteDialog();
        pause1s();
    }

    public String getRouteIdAtRow(int editedRouteRowNumber)
    {
        return getTextOnTableWithNgRepeat(editedRouteRowNumber, COLUMN_CLASS_DATA_ROUTE_ID, NG_REPEAT);
    }
}
