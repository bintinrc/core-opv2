package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
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
