package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class BulkAddToRoutePage extends OperatorV2SimplePage
{
    public static final String NG_REPEAT = "row in $data";

    public BulkAddToRoutePage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectCurrentDate()
    {
        setMdDatepickerById("commons.model.route-date", new Date());
    }

    public void selectRouteGroup(String routeGroupName)
    {
        selectMultipleValuesFromMdSelectById("select-route-group(s)", routeGroupName);
    }

    public void selectTag(String tagName)
    {
        clickf("//md-switch[@aria-label='%s']", tagName);
        pause100ms();
    }

    public void clickSubmit()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.submit");
        waitUntilInvisibilityOfToast("Submitted successfully");
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }
}
