package com.nv.qa.selenium.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.WebDriver;

import java.text.SimpleDateFormat;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class AddParcelToRoutePage extends SimplePage
{
    private static final SimpleDateFormat DATE_FILTER_SDF = new SimpleDateFormat("EEEE MMMM d yyyy");
    private static final int SUBMIT_BUTTON_LOADING_TIMEOUT_IN_SECONDS = 30;
    public static final String NG_REPEAT = "row in $data";
    public static final String COLUMN_CLASS_TRACKING_ID = "tracking_id";

    public AddParcelToRoutePage(WebDriver driver)
    {
        super(driver);
    }

    public void selectCurrentDate()
    {
        String dateLabel = DATE_FILTER_SDF.format(CommonUtil.getBeforeDate(1));

        click("//md-datepicker[@id='commons.model.route-date']/button");
        pause1s();
        click("//td[@aria-label='" + dateLabel + "']");
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
