package com.nv.qa.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AddParcelToRoutePage extends SimplePage
{
    private static final int SUBMIT_BUTTON_LOADING_TIMEOUT_IN_SECONDS = 30;
    public static final String NG_REPEAT = "row in $data";
    public static final String COLUMN_CLASS_TRACKING_ID = "tracking_id";

    public AddParcelToRoutePage(WebDriver driver)
    {
        super(driver);
    }

    public void selectRouteGroup(String routeGroupName)
    {
        click("//md-select[@aria-label='Select Route Group(s)']");
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
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Submit']//md-progress-circular", SUBMIT_BUTTON_LOADING_TIMEOUT_IN_SECONDS);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }
}
