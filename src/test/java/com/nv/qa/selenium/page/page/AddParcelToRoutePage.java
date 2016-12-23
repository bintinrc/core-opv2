package com.nv.qa.selenium.page.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AddParcelToRoutePage extends SimplePage
{
    public static final String NG_REPEAT = "row in $data";
    public static final String COLUMN_CLASS_TRACKING_ID = "tracking_id";

    public AddParcelToRoutePage(WebDriver driver)
    {
        super(driver);
    }

    public void selectRouteGroup(String routeGroupName)
    {
        click("//md-select[@aria-label='Choose Route Groups']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routeGroupName));
        pause100ms();
        click("//button[@aria-label='container.sidenav.routing.add-parcel']"); //Click sidebar menu to close route group modal option.
        pause50ms();
    }

    public void selectTag(String tagName)
    {
        click(String.format("//md-switch[@aria-label='%s']", tagName));
        pause100ms();
    }

    public void clickSubmit()
    {
        click("//button[@aria-label='Submit']");
        pause200ms();
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }
}
