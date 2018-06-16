package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.StringUtils;
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

    public void successfulGlobalInbound(GlobalInboundParams globalInboundParams)
    {
        globalInbound(globalInboundParams);

        String trackingId = globalInboundParams.getTrackingId();
        TestUtils.retryIfAssertionErrorOccurred(() -> {
            String lastScanned = getTextTrimmed("//div[contains(text(), 'Last Scanned')]");
            String lastScannedTrackingId = lastScanned.split(":")[1].trim();
            Assert.assertEquals("Last Scanned Tracking ID", trackingId, lastScannedTrackingId);
        }, "Checking Last Scanned Tracking ID");
    }

    public void globalInbound(GlobalInboundParams globalInboundParams){
        selectHubAndDeviceId(globalInboundParams.getHubName(), globalInboundParams.getDeviceId());
        overrideSize(globalInboundParams.getOverrideSize());
        overrideWeight(globalInboundParams.getOverrideWeight());
        overrideDimHeight(globalInboundParams.getOverrideDimHeight());
        overrideDimWidth(globalInboundParams.getOverrideDimWidth());
        overrideDimLength(globalInboundParams.getOverrideDimLength());

        sendKeysAndEnterByAriaLabel("Scan a new parcel / Enter a tracking ID", globalInboundParams.getTrackingId());
        pause500ms();
    }

    public void globalInboundAndCheckAlert(GlobalInboundParams globalInboundParams, String toastText, String rackInfo)
    {
        globalInbound(globalInboundParams);

        if (StringUtils.isNotBlank(rackInfo))
        {
            String xpath = String.format("//h1[normalize-space(text())='%s']", rackInfo);
            Assert.assertNotNull("rack info", waitUntilVisibilityOfElementLocated(xpath));
        }
        if (StringUtils.isNotBlank(toastText))
        {
            Assert.assertEquals("Toast text", toastText, getToastTopText());
        }
    }
}
