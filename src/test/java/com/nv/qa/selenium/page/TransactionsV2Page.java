package com.nv.qa.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TransactionsV2Page extends SimplePage
{
    public TransactionsV2Page(WebDriver driver)
    {
        super(driver);
    }



    public void clickLoadSelectionButton()
    {
        click("//button[@aria-label='Load Selection']");
    }

    public void selectAllShown()
    {
        click("//button[@aria-label='Selection']");
        pause100ms();
        click("//button[@aria-label='Select All Shown']");
        pause100ms();
    }

    public void clickAddToRouteGroupButton()
    {
        click("//button[@aria-label='Add to Route Group']");
        pause100ms();
    }

    public void selectRouteGroupOnAddToRouteGroupDialog(String routeGroupName)
    {
        click("//md-select[@aria-label='Route Group']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routeGroupName));
        pause100ms();
    }

    public void clickAddTransactionsOnAddToRouteGroupDialog()
    {
        click("//button[@aria-label='Save Button']");
    }
}
