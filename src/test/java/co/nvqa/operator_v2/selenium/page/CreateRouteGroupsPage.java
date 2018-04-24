package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.text.SimpleDateFormat;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class CreateRouteGroupsPage extends OperatorV2SimplePage
{
    private static final SimpleDateFormat DATE_FILTER_SDF = new SimpleDateFormat("EEEE MMMM d yyyy");

    public CreateRouteGroupsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void setCreationTimeFilter()
    {
        String dateLabel = DATE_FILTER_SDF.format(TestUtils.getNextDate(1));

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
        if(filterName.contains("time"))
        {
            if(isElementExist("//div[div[p[text()='" + filterName + "']]]/div/nv-icon-button/button"))
            {
                click("//div[div[p[text()='" + filterName + "']]]/div/nv-icon-button/button");
            }
        }
        else
        {
            click("//div[div[p[text()='" + filterName + "']]]/div/div/nv-icon-button/button");
        }
    }

    public void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
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
        clickButtonByAriaLabel("Selection");
        pause100ms();
        clickButtonByAriaLabel("Select All Shown");
        pause100ms();
    }

    public void clickAddToRouteGroupButton()
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("container.transactions.add-to-route-group");
    }

    public void selectRouteGroupOnAddToRouteGroupDialog(String routeGroupName)
    {
        click("//md-select[@aria-label='Route Group']");
        pause100ms();
        clickf("//md-option/div[contains(text(), '%s')]", routeGroupName);
        pause100ms();
    }

    public void clickAddTransactionsOnAddToRouteGroupDialog()
    {
        clickNvButtonSaveByNameAndWaitUntilDone("Add Transactions/Reservations");
    }
}
