package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 * @author Sergey Mishanin
 */
public class GlobalSettingsPage extends OperatorV2SimplePage
{
    private static final String LOCATOR_WEIGHT_TOLERANCE = "inputWeightTolerance";
    private static final String LOCATOR_INBOUND_SETTINGS_UPDATE_BUTTON = "//*[@on-click='::ctrl.function.updateWeightTolerance()']/button";

    public GlobalSettingsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void setWeightTolerance(String weightTolerance)
    {
        sendKeysById(LOCATOR_WEIGHT_TOLERANCE, weightTolerance);
    }

    public void clickInboudSettingsUpdateButton()
    {
        click(LOCATOR_INBOUND_SETTINGS_UPDATE_BUTTON);
    }
}
