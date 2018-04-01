package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class GlobalInboundPage extends OperatorV2SimplePage
{
    public GlobalInboundPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    private void selectHubAndDeviceId(String hubName, String deviceId)
    {
        if(isElementExistFast("//h4[text()='Select the following to begin:']"))
        {
            TestUtils.retryIfRuntimeExceptionOccurred(()->
            {
                selectValueFromNvAutocomplete("ctrl.hubSearchText", hubName);
                pause500ms();

                if(isElementExistFast("//nv-api-text-button[@name='Continue']/button[@disabled='disabled']"))
                {
                    throw new NvTestRuntimeException("Hub is not loaded yet.");
                }
            });

            if(deviceId!=null)
            {
                sendKeysToMdInputContainerByModel("ctrl.data.deviceId", deviceId);
            }

            clickNvApiTextButtonByNameAndWaitUntilDone("Continue");
        }
        else
        {
            clickNvIconButtonByNameAndWaitUntilEnabled("commons.settings");
            selectValueFromNvAutocomplete("ctrl.hubSearchText", hubName);

            if(deviceId!=null)
            {
                sendKeysToMdInputContainerByModel("ctrl.data.deviceId", deviceId);
            }

            clickNvIconTextButtonByNameAndWaitUntilDone("Save changes");
        }
    }

    private void overrideSize(String overrideSize)
    {
        if(overrideSize==null)
        {
            if(isElementExistFast("//nv-icon-text-button[@name='container.global-inbound.manual']"))
            {
                clickNvIconTextButtonByName("container.global-inbound.manual");
            }

            return;
        }
        else
        {
            if(isElementExistFast("//nv-icon-text-button[@name='container.global-inbound.retain']"))
            {
                clickNvIconTextButtonByName("container.global-inbound.retain");
                selectValueFromMdSelectById("size", overrideSize);
            }
        }
    }

    private void overrideWeight(Double overrideWeight)
    {
        setOverrideValue("input-weight", overrideWeight);
    }

    private void overrideDimHeight(Double overrideDimHeight)
    {
        setOverrideValue("input-height", overrideDimHeight);
    }

    private void overrideDimWidth(Double overrideDimWidth)
    {
        setOverrideValue("input-width", overrideDimWidth);
    }

    private void overrideDimLength(Double overrideDimLength)
    {
        setOverrideValue("input-length", overrideDimLength);
    }

    private void setOverrideValue(String inputId, Double value)
    {
        if(value==null)
        {
            clearf("//input[@id='%s']", inputId);
        }
        else
        {
            sendKeysById(inputId, NO_TRAILING_ZERO_DF.format(value));
        }
    }

    public void globalInbound(GlobalInboundParams globalInboundParams)
    {
        String trackingId = globalInboundParams.getTrackingId();

        selectHubAndDeviceId(globalInboundParams.getHubName(), globalInboundParams.getDeviceId());
        overrideSize(globalInboundParams.getOverrideSize());
        overrideWeight(globalInboundParams.getOverrideWeight());
        overrideDimHeight(globalInboundParams.getOverrideDimHeight());
        overrideDimWidth(globalInboundParams.getOverrideDimWidth());
        overrideDimLength(globalInboundParams.getOverrideDimLength());

        sendKeysAndEnterByAriaLabel("Scan a new parcel / Enter a tracking ID", globalInboundParams.getTrackingId());
        pause500ms();

        String lastScanned = getTextTrimmed("//div[contains(text(), 'Last Scanned')]");
        String lastScannedTrackingId = lastScanned.split(":")[1].trim();
        Assert.assertEquals("Last Scanned Tracking ID", trackingId, lastScannedTrackingId);
    }
}
