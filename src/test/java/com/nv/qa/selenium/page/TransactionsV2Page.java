package com.nv.qa.selenium.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.text.SimpleDateFormat;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class TransactionsV2Page extends SimplePage
{
    private static final int SAVE_BUTTON_LOADING_TIMEOUT_IN_SECONDS = 30;
    private static final SimpleDateFormat DATE_FILTER_SDF = new SimpleDateFormat("EEEE MMMM d yyyy");

    public TransactionsV2Page(WebDriver driver)
    {
        super(driver);
    }

    public void setCreationTimeFilter()
    {
        String dateLabel = DATE_FILTER_SDF.format(CommonUtil.getNextDate(1));

        /**
         * Set fromHour & fromMinute of Creation Time.
         */
        click("//md-input-container[@model='container.fromHour']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 00 ')]");
        pause500ms();
        click("//md-input-container[@model='container.fromMinute']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 00 ')]");
        pause500ms();

        /**
         * Set toHour & toMinute of Creation Time.
         */
        click("//md-input-container[@model='container.toHour']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 23 ')]");
        pause500ms();
        click("//md-input-container[@model='container.toMinute']");
        pause500ms();
        click("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), ' 30 ')]");
        pause500ms();

        click("//md-datepicker[@ng-model='container.toDate']/button");
        pause500ms();
        click("//td[@aria-label='" + dateLabel + "']");
        pause500ms();
    }

    public void removeFilter(String filterName)
    {
        if (filterName.contains("time"))
        {
            if(isElementExist("//div[div[p[text()='" + filterName + "']]]/div/nv-icon-button/button")){
                click("//div[div[p[text()='" + filterName + "']]]/div/nv-icon-button/button");
            }
        }
        else
        {
            click("//div[div[p[text()='" + filterName + "']]]/div/div/nv-icon-button/button");
        }
    }

    public void clickLoadSelectionButton()
    {
        click("//button[@aria-label='Load Selection']");
    }

    public void searchByTrackingId(String trackingId)
    {
        //-- get checkbox relative to the tracking id cell
        WebElement textbox = findElementByXpath("//input[@ng-model='searchText' and @tabindex='13']");
        textbox.clear();
        textbox.sendKeys(trackingId);
        pause100ms();
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
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Save Button']//md-progress-circular", SAVE_BUTTON_LOADING_TIMEOUT_IN_SECONDS);
    }
}
