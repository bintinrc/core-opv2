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
public class PricingTemplatePage
{
    public static final String ACTION_BUTTON_CODE = "code";
    public static final String ACTION_BUTTON_EDIT = "edit";
    public static final String ACTION_BUTTON_SHIPPERS = "Shippers";
    public static final String ACTION_BUTTON_DELETE = "delete";

    private final WebDriver driver;

    public PricingTemplatePage(WebDriver driver)
    {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void createRules(String rulesName, String description)
    {
        createRules(rulesName, description, null);
    }

    public void createRules(String rulesName, String description, String rules)
    {
        CommonUtil.clickBtn(driver, "//button[@id='button-create-rules']");
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Name']", rulesName);
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Description']", description);

        if(rules!=null)
        {
            if(driver instanceof JavascriptExecutor)
            {
                JavascriptExecutor javascriptExecutor = (JavascriptExecutor)driver;
                javascriptExecutor.executeScript(String.format("window.ace.edit('ace-editor').setValue('%s');", rules));
                CommonUtil.pause100ms();
            }
            else
            {
                throw new RuntimeException("Cannot execute Javascript.");
            }
        }

        CommonUtil.clickBtn(driver, "//nv-api-text-button[@name='Save']");
    }

    public String createDefaultRulesIfNotExists(String rulesName, String rulesDescription, String rules)
    {
        /**
         * Check if the rules exist.
         */
        String pricingTemplateName = searchAndGetTextOnTable(rulesName, 1, "ctrl.table.name");

        if(pricingTemplateName==null || pricingTemplateName.isEmpty())
        {
            createRules(rulesName, rulesDescription, rules);
        }

        String pricingTemplateId = searchAndGetTextOnTable(rulesName, 1, "ctrl.table.id");

        if(pricingTemplateId==null)
        {
            throw new RuntimeException("Failed to create rules if not exists.");
        }

        return pricingTemplateId;
    }

    public void updateRules(int rowNumber, String newRulesName, String newDescription)
    {
        updateRules(rowNumber, newRulesName, newDescription, null);
    }

    public void updateRules(int rowNumber, String newRulesName, String newDescription, String newRules)
    {
        clickActionButton(rowNumber, PricingTemplatePage.ACTION_BUTTON_EDIT);
        CommonUtil.pause1s();
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Name']", newRulesName);
        CommonUtil.inputText(driver, "//input[@type='text'][@aria-label='Description']", newDescription);

        if(newRules!=null)
        {
            CommonUtil.inputText(driver, "//div[@class='ace_content']", newRules);
        }

        CommonUtil.clickBtn(driver, "//nv-api-text-button[@name='Update']");
    }

    public void searchAndDeleteRules(int rowNumber, String rulesName)
    {
        CommonUtil.inputText(driver, "//input[@placeholder='Search rule']", rulesName);
        CommonUtil.pause1s();
        clickActionButton(rowNumber, PricingTemplatePage.ACTION_BUTTON_DELETE);
        CommonUtil.pause1s();
        CommonUtil.clickBtn(driver, "//button[@type='button'][@aria-label='Delete']");
        CommonUtil.pause1s();
    }

    public void simulateRunTest(String deliveryType, String orderType, String timeslotType, String size, String weight)
    {
        clickActionButton(1, PricingTemplatePage.ACTION_BUTTON_EDIT);
        CommonUtil.selectValueFromMdSelectMenu(driver, "//md-input-container[@label='Delivery Type']", String.format("//md-option[@value='%s']", deliveryType));
        CommonUtil.selectValueFromMdSelectMenu(driver, "//md-input-container[@label='Order Type']", String.format("//md-option[@value='%s']", orderType));
        CommonUtil.selectValueFromMdSelectMenu(driver, "//md-input-container[@label='Timeslot Type']", String.format("//md-option[@value='%s']", timeslotType));
        CommonUtil.selectValueFromMdSelectMenu(driver, "//md-input-container[@label='Size']", String.format("//md-option[@value='%s']", size));
        CommonUtil.inputText(driver, "//input[@aria-label='Weight']", weight);
        CommonUtil.clickBtn(driver, "//button[@id='button-run-test']");
    }

    public String linkPricingTemplateToShipper(String defaultRulesName1, String defaultRulesName2, String shipperName)
    {
        String pricingTemplateLinkedToAShipper = null;
        String[] rulesToTest = {defaultRulesName1, defaultRulesName2};

        for(String rules : rulesToTest)
        {
            pricingTemplateLinkedToAShipper = rules;
            CommonUtil.inputText(driver, "//input[@placeholder='Search rule']", pricingTemplateLinkedToAShipper);
            CommonUtil.pause1s();
            clickActionButton(1, PricingTemplatePage.ACTION_BUTTON_SHIPPERS);
            CommonUtil.pause1s();

            /**
             * Assign shipper with value $shipperName to Pricing Template with value $defaultRulesName1 or $defaultRulesName2
             * only if the shipper does not have that shipper.
             */
            if(!isPricingTemplateContainShipper(shipperName))
            {
                CommonUtil.inputText(driver, "//input[@aria-label=concat('Type shipper',\"'\", 's name')]", shipperName);
                CommonUtil.pause1s();
                CommonUtil.clickBtn(driver, String.format("//div[@ng-repeat='item in items | filter:model[title] track by $index' and normalize-space(text())='%s']", shipperName));
                CommonUtil.clickBtn(driver, "//div[@class='idle ng-binding ng-scope' and text()='Complete']");

                /**
                 * Check is Shipper already linked to another Pricing Template by find "Proceed" button.
                 * Click "Proceed" button if found to override the shipper's Pricing Template.
                 */
                WebElement proceedBtn = CommonUtil.getElementByXpath(driver, "//div[@class='idle ng-binding ng-scope' and text()='Proceed']");

                if(proceedBtn!=null)
                {
                    proceedBtn.click();
                }

                /**
                 * Check error element first, if error element not found then linking Pricing Template to the Shipper success.
                 */
                if(CommonUtil.isElementExist(driver, "//md-dialog[@aria-label='ErrorUnexpected error']/md-dialog-content/h2[text()='Error']"))
                {
                    CommonUtil.pause100ms();
                    CommonUtil.clickBtn(driver, "//md-dialog[@aria-label='ErrorUnexpected error']/md-dialog-actions/button/span[text()='Close']");
                    CommonUtil.pause100ms();
                    throw new RuntimeException("Failed to linking Pricing Template to the Shipper.");
                }

                break;
            }
            else
            {
                /**
                 * Shipper already linked to this Pricing Template.
                 * Click "Discard Changes".
                 */
                CommonUtil.clickBtn(driver, "//button[@id='button-cancel-dialog']");
            }
        }

        return pricingTemplateLinkedToAShipper;
    }

    public boolean isPricingTemplateContainShipper(String shipperName)
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
        CommonUtil.inputText(driver, "//input[@placeholder='Search rule']", filter);
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
        WebElement element = CommonUtil.getElementByXpath(driver, String.format("//table[@ng-table='ctrl.pricingTemplateParams']/tbody/tr[%d]/td[@data-title='%s']", rowNumber, columnDataTitle));

        if(element!=null)
        {
            text = element.getText();
        }

        return text;
    }

    /**
     *
     * @param rowNumber Start from 1. Row number where the action button located.
     * @param actionButtonName Valid value are PricingTemplatePage.ACTION_BUTTON_CODE, PricingTemplatePage.ACTION_BUTTON_EDIT, PricingTemplatePage.ACTION_BUTTON_SHIPPERS, PricingTemplatePage.ACTION_BUTTON_DELETE.
     */
    public void clickActionButton(int rowNumber, String actionButtonName)
    {
        WebElement element = CommonUtil.getElementByXpath(driver, String.format("//table[@ng-table='ctrl.pricingTemplateParams']/tbody/tr[%d]/td[@data-title='ctrl.table.actions']/div/*[@name='%s']", rowNumber, actionButtonName));

        if(element==null)
        {
            throw new RuntimeException("Cannot find action button.");
        }

        element.click();
    }
}
