package com.nv.qa.selenium.page;

import org.openqa.selenium.WebDriver;

import java.util.Random;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class OpsRoutePage extends SimplePage
{
    public static final String NG_REPEAT = "opsRoute in $data";
    public static final String COLUMN_CLASS_ROUTE_ID = "routeId";
    public static final String ACTION_BUTTON_EDIT = "Edit";

    public OpsRoutePage(WebDriver driver)
    {
        super(driver);
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
        String routeId = getTextOnTableWithNgRepeat(editedRouteRowNumber, COLUMN_CLASS_ROUTE_ID, NG_REPEAT);
        return routeId;
    }
}
