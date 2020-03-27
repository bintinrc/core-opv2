package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectConfirmed;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class GlobalInboundPage extends OperatorV2SimplePage
{
    public static final String XPATH_ORDER_TAGS_ON_GLOBAL_INBOUND_PAGE = "//div[contains(@class,'order-tags-container')]//span";

    public GlobalInboundPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    private void selectHubAndDeviceId(String hubName, String deviceId)
    {
        if(isElementExistFast("//h4[text()='Select the following to begin:']"))
        {
            retryIfRuntimeExceptionOccurred(() ->
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

        retryIfAssertionErrorOccurred(() ->
        {
            String lastScanned = getTextTrimmed("//div[contains(text(), 'Last Scanned')]");
            String lastScannedTrackingId = lastScanned.split(":")[1].trim();
            assertEquals("Last Scanned Tracking ID", trackingId, lastScannedTrackingId);
        }, "Checking Last Scanned Tracking ID");
    }

    @SuppressWarnings("WeakerAccess")
    public void globalInbound(GlobalInboundParams globalInboundParams)
    {
        selectHubAndDeviceId(globalInboundParams.getHubName(), globalInboundParams.getDeviceId());
        overrideSize(globalInboundParams.getOverrideSize());
        overrideWeight(globalInboundParams.getOverrideWeight());
        overrideDimHeight(globalInboundParams.getOverrideDimHeight());
        overrideDimWidth(globalInboundParams.getOverrideDimWidth());
        overrideDimLength(globalInboundParams.getOverrideDimLength());

        sendKeysAndEnterByAriaLabel("Scan a new parcel / Enter a tracking ID", globalInboundParams.getTrackingId());
        pause500ms();
    }

    public void globalInboundAndCheckAlert(GlobalInboundParams globalInboundParams, String toastText, String rackInfo,
                                           String rackColor, String weightWarning, String rackSector, String destinationHub)
    {
        globalInbound(globalInboundParams);

        retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
        {
            if(StringUtils.isNotBlank(weightWarning))
            {
                String message = getText("//div[contains(@class,'weight-diff-info')]/span");
                assertEquals("Weight warning message", weightWarning, message);
            }

            if(StringUtils.isNotBlank(rackInfo))
            {
                String xpath = String.format("//h1[normalize-space(text())='%s']", rackInfo);
                assertNotNull("rack info", waitUntilVisibilityOfElementLocated(xpath));
            }

            if(StringUtils.isNotBlank(rackColor))
            {
                String xpath = "//div[contains(@class, 'rack-sector')]";
                String actualStyle = getAttribute(xpath, "style");
                NvLogger.infof("Actual Style: %s", actualStyle);
                String colorString = actualStyle.replace("background:", "").replaceAll(";", "").trim();
                NvLogger.infof("Color       : %s", colorString);
                Color color = Color.fromString(colorString);
                NvLogger.infof("Color as Hex: %s", color.asHex());
                assertThat("Unexpected Rack Sector color", color.asHex(), equalToIgnoringCase(rackColor));
            }
            if(StringUtils.isNotBlank(rackSector))
            {
                String xpath = f("//div[contains(@class, 'rack-container')]/descendant::*[normalize-space(text())='%s']", rackSector);
                assertNotNull("Rack Sector", waitUntilVisibilityOfElementLocated(xpath));
            }
            if(StringUtils.isNotBlank(destinationHub))
            {
                String xpath = f("//div[contains(@class, 'rack-container')]/descendant::*[normalize-space(text())='Hub: %s']", destinationHub);
                assertNotNull("Destination Hub", waitUntilVisibilityOfElementLocated(xpath));
            }
        }, "globalInboundAndCheckAlert");

        if(StringUtils.isNotBlank(toastText))
        {
            assertEquals("Toast text", toastText, getToastTopText());
            waitUntilInvisibilityOfToast(toastText);
        }
    }

    public void verifiesPriorityLevelInfoIsCorrect(int expectedPriorityLevel, String expectedPriorityLevelColorAsHex)
    {
        String actualPriorityLevel = getText("//div[contains(text(), 'Priority Level')]/following-sibling::div[1]/span");
        Color actualPriorityLevelColor = getBackgroundColor("//div[contains(@class,'priority-container')][descendant::div[contains(text(), 'Priority Level')]]");

        assertEquals("Priority Level", String.valueOf(expectedPriorityLevel), actualPriorityLevel);
        assertEquals("Priority Level Color", expectedPriorityLevelColorAsHex, actualPriorityLevelColor.asHex());
    }

    public void verifyPetsGlobalInbound(GlobalInboundParams globalInboundParams, String ticketType)
    {
        globalInbound(globalInboundParams);

        String actualWarningText = getText("//p[@ng-if='!ctrl.data.setAsideRackSector']/following-sibling::h1");
        assertEquals("Warning Text is not the same : ", actualWarningText, "RECOVERY " + ticketType.toUpperCase());
    }

    public void verifiesDetailsAreRightForGlobalInbound(DatabaseCheckingNinjaCollectConfirmed result, DpDetailsResponse dpDetails, String barcode, String source)
    {
        assertEquals("Barcode is not the same : ", result.getBarcode(), barcode);
        assertEquals("DP ID is not the same : ", result.getDpId(), dpDetails.getId());
        assertEquals("Status is not the same : ", result.getStatus(), "CONFIRMED");
        if(source.equalsIgnoreCase("Fully Integrated"))
        {
            assertEquals("Source is not the same : ", result.getSource(), "FULLY_INTEGRATED_NINJA_COLLECT");
        }
        else if (source.equalsIgnoreCase("Semi Integrated"))
        {
            assertEquals("Source is not the same : ", result.getSource(), "SEMI_INTEGRATED_NINJA_COLLECT");
        }
    }

    public void verifiesTagsOnOrder(List<String> expectedOrderTags)
    {
        List<String> tags = new ArrayList<>();
        List<WebElement> listOfTags = findElementsByXpath(XPATH_ORDER_TAGS_ON_GLOBAL_INBOUND_PAGE);
        for (WebElement we : listOfTags)
        {
            tags.add(we.getText());
        }
        assertEquals("Order tags is not equal to tags set on Order Tag Management page for order Id - %s", expectedOrderTags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList()), tags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList()));
    }

    public void unSuccessfulGlobalInbound(String recoveryTicketType, GlobalInboundParams globalInboundParams)
    {
        globalInbound(globalInboundParams);
        String xpathRackSector = "//div[contains(@class,'rack-sector')]/h1";
        String rackSector = getText(xpathRackSector);
        assertEquals("Recovery Ticket Type rack sector is displayed", ("RECOVERY "+recoveryTicketType).toLowerCase(), rackSector.toLowerCase());
    }
}
