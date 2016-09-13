package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class PricingScriptsPage
{
    public static final String ACTION_BUTTON_CODE = "code";
    public static final String ACTION_BUTTON_EDIT = "edit";
    public static final String ACTION_BUTTON_SHIPPERS = "Shippers";
    public static final String ACTION_BUTTON_DELETE = "delete";

    private final WebDriver driver;

    public PricingScriptsPage(WebDriver driver)
    {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void createScript(String scriptName, String description)
    {
        createScript(scriptName, description, null);
    }

    public void createScript(String scriptName, String description, String script)
    {
        CommonUtil.clickBtn(driver, "//button[@id='button-create-rules']");
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Name']", scriptName);
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Description']", description);

        if(script!=null)
        {
            updateAceEditorValue(script);
        }

        CommonUtil.clickBtn(driver, "//nv-api-text-button[@name='Save']");
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

        CommonUtil.pause1s();

        String pricingScriptsId = searchAndGetTextOnTable(scriptName, 1, "id");

        if(pricingScriptsId==null)
        {
            throw new RuntimeException("Failed to create script if not exists.");
        }

        CommonUtil.pause1s();

        return pricingScriptsId;
    }

    public void updateScript(int rowNumber, String newScriptName, String newDescription)
    {
        updateScript(rowNumber, newScriptName, newDescription, null);
    }

    public void updateScript(int rowNumber, String newScriptName, String newDescription, String newScript)
    {
        clickActionButton(rowNumber, PricingScriptsPage.ACTION_BUTTON_EDIT);
        CommonUtil.pause1s();
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Name']", newScriptName);
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Description']", newDescription);

        if(newScript!=null)
        {
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

        CommonUtil.clickBtn(driver, "//nv-api-text-button[@name='Update']");
    }

    public void searchAndDeleteScript(int rowNumber, String scriptName)
    {
        CommonUtil.inputText(driver, "//input[@placeholder='Search Script...']", scriptName);
        CommonUtil.pause1s();
        clickActionButton(rowNumber, PricingScriptsPage.ACTION_BUTTON_DELETE);
        CommonUtil.pause1s();
        CommonUtil.clickBtn(driver, "//button[@type='button'][@aria-label='Delete']");
        CommonUtil.pause1s();
    }

    public void simulateRunTest(String deliveryType, String orderType, String timeslotType, String size, String weight)
    {
        clickActionButton(1, PricingScriptsPage.ACTION_BUTTON_EDIT);
        CommonUtil.selectValueFromMdSelectMenu(driver, "//md-input-container[@label='Delivery Type']", String.format("//md-option[@value='%s']", deliveryType));
        CommonUtil.selectValueFromMdSelectMenu(driver, "//md-input-container[@label='Order Type']", String.format("//md-option[@value='%s']", orderType));
        CommonUtil.selectValueFromMdSelectMenu(driver, "//md-input-container[@label='Timeslot Type']", String.format("//md-option[@value='%s']", timeslotType));
        CommonUtil.selectValueFromMdSelectMenu(driver, "//md-input-container[@label='Size']", String.format("//md-option[@value='%s']", size));
        CommonUtil.inputText(driver, "//input[@aria-label='Weight']", weight);
        CommonUtil.clickBtn(driver, "//button[@id='button-run-test']");
    }

    public String linkPricingScriptsToShipper(String defaultScriptName1, String defaultScriptName2, String shipperName)
    {
        String pricingScriptsLinkedToAShipper = null;
        String[] scriptToTest = {defaultScriptName1, defaultScriptName2};

        for(String script : scriptToTest)
        {
            pricingScriptsLinkedToAShipper = script;
            CommonUtil.inputText(driver, "//input[@placeholder='Search Script...']", pricingScriptsLinkedToAShipper);
            CommonUtil.pause1s();
            clickActionButton(1, PricingScriptsPage.ACTION_BUTTON_SHIPPERS);
            CommonUtil.pause1s();

            /**
             * Assign shipper with value $shipperName to Pricing Scripts with value $defaultScriptName1 or $defaultScriptName2
             * only if the shipper does not have that shipper.
             */
            if(!isPricingScriptsContainShipper(shipperName))
            {
                CommonUtil.inputText(driver, "//input[@aria-label='Find Shipper']", shipperName);
                CommonUtil.pause1s();
                CommonUtil.clickBtn(driver, String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", shipperName));
                CommonUtil.clickBtn(driver, "//div[@class='idle ng-binding ng-scope' and text()='Complete']");

                /**
                 * Check is Shipper already linked to another Pricing Scripts by find "Proceed" button.
                 * Click "Proceed" button if found to override the shipper's Pricing Scripts.
                 */
                WebElement proceedBtn = CommonUtil.getElementByXpath(driver, "//div[@class='idle ng-binding ng-scope' and text()='Proceed']");

                if(proceedBtn!=null)
                {
                    proceedBtn.click();
                }

                /**
                 * Check error element first, if error element not found then linking Pricing Scripts to the Shipper success.
                 */
                if(CommonUtil.isElementExist(driver, "//md-dialog[@aria-label='ErrorUnexpected error']/md-dialog-content/h2[text()='Error']"))
                {
                    CommonUtil.pause100ms();
                    CommonUtil.clickBtn(driver, "//md-dialog[@aria-label='ErrorUnexpected error']/md-dialog-actions/button/span[text()='Close']");
                    CommonUtil.pause100ms();
                    throw new RuntimeException("Failed to linking Pricing Scripts to the Shipper.");
                }

                break;
            }
            else
            {
                /**
                 * Shipper already linked to this Pricing Scripts.
                 * Click "Discard Changes".
                 */
                CommonUtil.clickBtn(driver, "//button[@id='button-cancel-dialog']");
            }
        }

        return pricingScriptsLinkedToAShipper;
    }

    public boolean isPricingScriptsContainShipper(String shipperName)
    {
        boolean isFound = false;
        List<WebElement> elements = CommonUtil.getElementsByXpath(driver, "//div[@ng-repeat='shipper in ctrl.connectedShippers']//div[2]");

        for(WebElement element : elements)
        {
            if(shipperName.equalsIgnoreCase(element.getText()))
            {
                isFound = true;
                break;
            }
        }

        return isFound;
    }

    public String searchAndGetTextOnTable(String filter, int rowNumber, String columnDataTitle)
    {
        CommonUtil.inputText(driver, "//input[@placeholder='Search Script...']", filter);
        CommonUtil.pause1s();
        return getTextOnTable(1, columnDataTitle);
    }

    /**
     *
     * @param rowNumber Start from 1.
     * @param columnDataTitle data-title value. Example: <td data-title="ctrl.table.id" sortable="'id'" class="id ng-binding" data-title-text="ID"> 1 </td>
     * @return
     */
    public String getTextOnTable(int rowNumber, String columnDataTitle)
    {
        String text = null;
        WebElement element = CommonUtil.getElementByXpath(driver, String.format("//tr[@md-virtual-repeat='script in ctrl.tableData'][%d]/td[@class='%s']", rowNumber, columnDataTitle));

        if(element!=null)
        {
            text = element.getText().trim();
        }

        return text;
    }

    /**
     *
     * @param rowNumber Start from 1. Row number where the action button located.
     * @param actionButtonName Valid value are PricingScriptsPage.ACTION_BUTTON_CODE, PricingScriptsPage.ACTION_BUTTON_EDIT, PricingScriptsPage.ACTION_BUTTON_SHIPPERS, PricingScriptsPage.ACTION_BUTTON_DELETE.
     */
    public void clickActionButton(int rowNumber, String actionButtonName)
    {
        WebElement element = CommonUtil.getElementByXpath(driver, String.format("//tr[@md-virtual-repeat='script in ctrl.tableData'][%d]/td[@class='actions column-locked-right']/div/*[@name='%s']", rowNumber, actionButtonName));

        if(element==null)
        {
            throw new RuntimeException("Cannot find action button.");
        }

        element.click();
    }

    private void updateAceEditorValue(String script)
    {
        if(driver instanceof JavascriptExecutor)
        {
            /**
             * editor.setValue(str, -1) // Moves cursor to the start.
             * editor.setValue(str, 1) // Moves cursor to the end.
             */
            JavascriptExecutor javascriptExecutor = (JavascriptExecutor)driver;
            javascriptExecutor.executeScript(String.format("window.ace.edit('ace-editor').setValue('%s', 1);", script));
            CommonUtil.pause100ms();
        }
        else
        {
            throw new RuntimeException("Cannot execute Javascript.");
        }
    }

    private String getAceEditorValue()
    {
        String value = "";

        if(driver instanceof JavascriptExecutor)
        {
            JavascriptExecutor javascriptExecutor = (JavascriptExecutor)driver;
            value = String.valueOf(javascriptExecutor.executeScript("return window.ace.edit('ace-editor').getValue();"));
            CommonUtil.pause100ms();
        }
        else
        {
            throw new RuntimeException("Cannot execute Javascript.");
        }

        return value;
    }
}
