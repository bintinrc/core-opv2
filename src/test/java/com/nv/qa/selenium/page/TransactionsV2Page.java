package com.nv.qa.selenium.page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class TransactionsV2Page extends SimplePage {
    public TransactionsV2Page(WebDriver driver) {
        super(driver);
    }

    public void removeFilter(String filterName) {
        if (filterName.contains("time")) {
            click("//div[div[p[text()='" + filterName + "']]]/div/nv-icon-button/button");
        } else {
            click("//div[div[p[text()='" + filterName + "']]]/div/div/nv-icon-button/button");
        }
    }

    public void clickLoadSelectionButton() {
        click("//button[@aria-label='Load Selection']");
    }

    public void searchByTrackingId(String trackingId) {
        //-- get checkbox relative to the tracking id cell
        WebElement textbox = findElementByXpath(
                "//input[@ng-model='searchText' and @tabindex='13']"
        );
        textbox.clear();
        textbox.sendKeys(trackingId);
        pause100ms();
    }

    public void selectAllShown() {
        click("//button[@aria-label='Selection']");
        pause100ms();
        click("//button[@aria-label='Select All Shown']");
        pause100ms();
    }

    public void clickAddToRouteGroupButton() {
        click("//button[@aria-label='Add to Route Group']");
        pause100ms();
    }

    public void selectRouteGroupOnAddToRouteGroupDialog(String routeGroupName) {
        click("//md-select[@aria-label='Route Group']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routeGroupName));
        pause100ms();
    }

    public void clickAddTransactionsOnAddToRouteGroupDialog() {
        click("//button[@aria-label='Save Button']");
    }
}
