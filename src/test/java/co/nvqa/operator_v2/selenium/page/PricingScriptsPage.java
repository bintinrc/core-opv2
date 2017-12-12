package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvTestRuntimeException;
import org.junit.Assert;
import org.openqa.selenium.*;

import java.util.List;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class PricingScriptsPage extends SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "script in getTableData()";
    public static final String COLUMN_CLASS_NAME = "name";

    public static final String ACTION_BUTTON_CODE = "code";
    public static final String ACTION_BUTTON_EDIT = "edit script";
    public static final String ACTION_BUTTON_SHIPPERS = "link shippers";
    public static final String ACTION_BUTTON_DELETE = "delete";

    public static final String WRITE_SCRIPT_TAB = "//md-tab-item[span[text()='Write Script']]";
    public static final String SCRIPT_INFO_TAB = "//md-tab-item[span[text()='Script Info']]";
    public static final String SAVE_CHANGE_BUTTON = "//nv-api-text-button[@name='commons.save-changes']";
    public static final String DELETE_SCRIPT_BUTTON = "//nv-api-text-button[@name='container.pricing-scripts.delete-script']";
    public static final String SRIPT_NAME_TEXT_FIELD = "//input[@type='text'][@aria-label='Name']";
    public static final String SRIPT_DESCRIPTION_TEXT_FIELD = "//input[@type='text'][@aria-label='Description']";
    public static final String CLOSE_BUTTON = "//nv-icon-button[@name='Cancel']";

    public PricingScriptsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void createScript(String scriptName, String description)
    {
        createScript(scriptName, description, null);
    }

    public void createScript(String scriptName, String description, String script)
    {
        clickButtonByAriaLabel("Create Script");
        sendKeys(SRIPT_NAME_TEXT_FIELD, scriptName);
        sendKeys(SRIPT_DESCRIPTION_TEXT_FIELD, description);

        if(script!=null)
        {
            updateAceEditorValue(script);
        }

        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class, 'pricing-script-linked-shippers-dialog')]"); // Wait until Link Shippers dialog appear.
        clickNvIconButtonByName("Cancel");
    }

    public String createDefaultScriptIfNotExists(String scriptName, String scriptDescription, String script)
    {
        /**
         * Check if the script exist.
         */
        String pricingScriptsName = searchAndGetTextOnTable(scriptName, 1, "name");

        if(pricingScriptsName==null || pricingScriptsName.isEmpty())
        {
            createScript(scriptName, scriptDescription, script);
        }
        else
        {
            updateScript(1, scriptName, scriptDescription, script);
        }

        pause1s();

        String pricingScriptsId = searchAndGetTextOnTable(scriptName, 1, "id");

        if(pricingScriptsId==null)
        {
            throw new NvTestRuntimeException("Failed to create script if not exists.");
        }

        pause1s();

        return pricingScriptsId;
    }

    public void updateScript(int rowNumber, String newScriptName, String newDescription)
    {
        updateScript(rowNumber, newScriptName, newDescription, null);
    }

    public void updateScript(int rowNumber, String newScriptName, String newDescription, String newScript)
    {
        openEditDialogAndWaitUntilLoadingIsDone();
        click(SCRIPT_INFO_TAB);
        sendKeys(SRIPT_NAME_TEXT_FIELD, newScriptName);
        sendKeys(SRIPT_DESCRIPTION_TEXT_FIELD, newDescription);

        if(newScript!=null)
        {
            click(WRITE_SCRIPT_TAB);
            String oldScript = getAceEditorValue().replaceAll(System.lineSeparator(), "\\\\n"); // Replace all "CrLf" to "\n".

            /**
             * Updating script using the same code makes Angular Ace Editor two ways data binding not works.
             * Refer to this JIRA NV-2830.
             */
            if(!oldScript.equals(newScript))
            {
                updateAceEditorValue(newScript);
            }
        }

        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
    }

    public void searchAndDeleteScript(String scriptName)
    {
        searchScript(scriptName);
        openEditDialogAndWaitUntilLoadingIsDone();
        clickNvApiTextButtonByNameAndWaitUntilDone("container.pricing-scripts.delete-script");
    }

    public void searchScript(String scriptName)
    {
        sendKeys(DEFAULT_MAX_RETRY_FOR_STALE_ELEMENT_REFERENCE, "//th[@column='name']//input", scriptName);
        pause1s();
    }

    public void openEditDialogAndWaitUntilLoadingIsDone()
    {
        clickActionButton(1, ACTION_BUTTON_EDIT);
        waitUntilVisibilityOfElementLocated(SCRIPT_INFO_TAB); // Wait until Edit dialog is loaded.
    }

    public void simulateRunTest(String deliveryType, String orderType, String timeslotType, String size, String weight, String insuredValue, String codValue)
    {
        openEditDialogAndWaitUntilLoadingIsDone();
        selectValueFromMdSelectMenu("//md-input-container[@label='container.pricing-scripts.description-delivery-type']", String.format("//md-option[@value='%s']", deliveryType));
        selectValueFromMdSelectMenu("//md-input-container[@label='container.pricing-scripts.description-order-type']", String.format("//md-option[@value='%s']", orderType));
        selectValueFromMdSelectMenu("//md-input-container[@label='container.pricing-scripts.description-time-slot-type']", String.format("//md-option[@value='%s']", timeslotType));
        selectValueFromMdSelectMenu("//md-input-container[@label='commons.size']", String.format("//md-option[@value='%s']", size));
        sendKeysById("commons.weight", weight);
        clickNvApiTextButtonByNameAndWaitUntilDone("container.pricing-scripts.run-check");
    }

    public String linkPricingScriptsToShipper(String defaultScriptName1, String defaultScriptName2, String shipperName)
    {
        String pricingScriptsLinkedToAShipper = null;
        String[] scriptToTest = {defaultScriptName1, defaultScriptName2};

        for(String script : scriptToTest)
        {
            pricingScriptsLinkedToAShipper = script;
            searchScript(pricingScriptsLinkedToAShipper);
            clickActionButton(1, ACTION_BUTTON_SHIPPERS);
            pause1s();

            /**
             * Assign shipper with value $shipperName to Pricing Scripts with value $defaultScriptName1 or $defaultScriptName2
             * only if the shipper does not have that shipper.
             */
            if(!isPricingScriptsContainShipper(shipperName))
            {
                sendKeysByAriaLabel("Search or Select...", shipperName);
                pause1s();
                click(String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", shipperName));
                clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");

                /**
                 * Check is Shipper already linked to another Pricing Scripts by find "Proceed" button.
                 * Click "Proceed" button if found to override the shipper's Pricing Scripts.
                 */
                /*WebElement proceedBtn = findElementByXpath("//button[div[contains(@class, 'idle ng-binding ng-scope') and text()='Proceed']]");

                if(proceedBtn!=null)
                {
                    proceedBtn.click();
                }*/

                /**
                 * Check error element first, if error element not found then linking Pricing Scripts to the Shipper success.
                 */
                if(isElementExistFast("//md-dialog[@aria-label='ErrorUnexpected error']/md-dialog-content/h2[text()='Error']"))
                {
                    pause100ms();
                    click("//md-dialog[@aria-label='ErrorUnexpected error']/md-dialog-actions/button/span[text()='Close']");
                    pause100ms();
                    throw new NvTestRuntimeException("Failed to linking Pricing Scripts to the Shipper.");
                }

                break;
            }
            else
            {
                /**
                 * Shipper already linked to this Pricing Scripts.
                 * Click "Discard Changes".
                 */
                clickButtonClose();
            }
        }

        return pricingScriptsLinkedToAShipper;
    }

    public boolean isPricingScriptsContainShipper(String shipperName)
    {
        boolean isFound = false;

        try
        {
            List<WebElement> elements = findElementsByXpathFast("//tr[@ng-repeat='shipper in $data']/td");

            for(WebElement element : elements)
            {
                if(shipperName.equalsIgnoreCase(element.getText()))
                {
                    isFound = true;
                    break;
                }
            }
        }
        catch(NoSuchElementException | TimeoutException ex)
        {
        }

        return isFound;
    }

    public void verifyCostAndComments(Map<String,String> mapOfData)
    {
        String expectedTotal = mapOfData.get("total");
        String expectedGst = mapOfData.get("gst");
        String expectedCodFee = mapOfData.get("codFee");
        String expectedInsuranceFee = mapOfData.get("insuranceFee");
        String expectedDeliveryFee = mapOfData.get("deliveryFee");
        String expectedHandlingFee = mapOfData.get("handlingFee");
        String expectedComments = mapOfData.get("comments");

        WebElement totalEl = findElementByXpath("//md-input-container/label[text()='Grand Total']/following-sibling::div[1]");
        String actualTotal = totalEl.getText();
        Assert.assertEquals("Total", expectedTotal, actualTotal);

        /*WebElement gstEl = findElementByXpath("//md-input-container[label[text()='GST']]/div[@class='readonly ng-binding']");
        String actualGst = gstEl.getText();
        Assert.assertEquals("GST", expectedGst, actualGst);*/

        WebElement codFeeEl = findElementByXpath("//md-input-container/label[text()='COD Fee']/following-sibling::div[1]");
        String actualCodFee = codFeeEl.getText();
        Assert.assertEquals("COD Fee", expectedCodFee, actualCodFee);

        WebElement insuranceFeeEl = findElementByXpath("//md-input-container/label[text()='Insurance Fee']/following-sibling::div[1]");
        String actualInsuranceFee = insuranceFeeEl.getText();
        Assert.assertEquals("Insurance Fee", expectedInsuranceFee, actualInsuranceFee);

        WebElement deliveryFeeEl = findElementByXpath("//md-input-container/label[text()='Delivery Fee']/following-sibling::div[1]");
        String actualDeliveryFee = deliveryFeeEl.getText();
        Assert.assertEquals("Delivery Fee", expectedDeliveryFee, actualDeliveryFee);

        WebElement handlingFeeEl = findElementByXpath("//md-input-container/label[text()='Handling Fee']/following-sibling::div[1]");
        String actualHandlingFee = handlingFeeEl.getText();
        Assert.assertEquals("Handling Fee", expectedHandlingFee, actualHandlingFee);

        WebElement commentsEl = findElementByXpath("//md-input-container/label[text()='Comments']/following-sibling::div[1]");
        String actualComments = commentsEl.getText();
        Assert.assertEquals("Comments", expectedComments, actualComments);
    }

    public void clickButtonCancel()
    {
        clickButtonByAriaLabel("Cancel");
    }

    public void clickButtonClose()
    {
        clickNvIconButtonByName("Cancel");
    }

    public String searchAndGetTextOnTable(String filter, int rowNumber, String columnDataTitle)
    {
        searchScript(filter);
        return getTextOnTable(rowNumber, columnDataTitle);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT, true);
    }

    public void clickActionButton(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }

    private void updateAceEditorValue(String script)
    {
        /**
         * editor.setValue(str, -1) // Moves cursor to the start.
         * editor.setValue(str, 1) // Moves cursor to the end.
         */
        executeJavascript(String.format("window.ace.edit('ace-editor').setValue('%s', 1);", script));
    }

    private String getAceEditorValue()
    {
        return executeJavascript("return window.ace.edit('ace-editor').getValue();");
    }

    private String executeJavascript(String script)
    {
        String value;

        if(getwebDriver() instanceof JavascriptExecutor)
        {
            JavascriptExecutor javascriptExecutor = (JavascriptExecutor) getwebDriver();
            value = String.valueOf(javascriptExecutor.executeScript(script));
            pause100ms();
        }
        else
        {
            throw new RuntimeException("Cannot execute Javascript.");
        }

        return value;
    }
}
