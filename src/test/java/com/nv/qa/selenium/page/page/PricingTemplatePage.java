package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

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
        CommonUtil.pause(3000);
        CommonUtil.clickBtn(driver, "//button[@id='button-create-rules']");
        CommonUtil.pause1s();
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
