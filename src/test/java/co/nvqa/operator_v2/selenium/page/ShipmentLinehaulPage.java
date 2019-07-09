package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.Linehaul;
import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class ShipmentLinehaulPage extends OperatorV2SimplePage
{
    private static final String XPATH_CREATE_LINEHAUL_BUTTON = "//button[div[text()='Create Linehaul']]";
    private static final String XPATH_CREATE_LINEHAUL_BUTTON_ONSCHEDULE = "//button[div[text()='create linehaul']]";
    private static final String XPATH_DELETE_BUTTON = "//button[@aria-label='Delete']";
    private static final String XPATH_LINEHAUL_NAME_TF = "//input[contains(@name,'linehaul-name')]";
    private static final String XPATH_COMMENT_TF = "//textarea[contains(@name,'comments')]";
    private static final String XPATH_ADD_HUB_BUTTON = "//button[@aria-label='Add Hub']";
    private static final String XPATH_REMOVE_HUB_BUTTON = "//button[@aria-label='remove']";
    private static final String XPATH_LABEL_CREATE_LINEHAUL = "//h4[text()='Create Linehaul']";
    private static final String XPATH_LABEL_EDIT_LINEHAUL = "//h4[text()='Edit Linehaul']";
    private static final String XPATH_CREATE_BUTTON = "//button[@aria-label='Create']";
    //private static final String XPATH_SAVE_CHANGES_BUTTON = "//button[@aria-label='Save Changes']";
    private static final String XPATH_SEARCH = "//th[@nv-table-filter='id']//input[@id='id']";
    private static final String XPATH_TABLE_ITEM = "//tr[@md-virtual-repeat='linehaul in getTableData()']";
    private static final String XPATH_LINEHAUL_ENTRIES_TAB = "//md-tab-item/span[text()='Linehaul Entries']";
    private static final String XPATH_LINEHAUL_DATE_TAB = "//md-tab-item/span[text()='Linehaul Date']";
    //private static final String XPATH_SCHEDULE_MONTH = "//md-select[contains(@aria-label,'Month:')]";
    //private static final String XPATH_SCHEDULE_YEAR = "//md-select[contains(@aria-label,'Year:')]";
    //public static final String XPATH_LOAD_ALL_SHIPMENT_BUTTON = "//button[@aria-label='Load Selection']";
    public static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[contains(@aria-label, 'Edit Filter')]";

    public ShipmentLinehaulPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickCreateLinehaul()
    {
        click(XPATH_CREATE_LINEHAUL_BUTTON);
    }

    public void clickCreateLinehaulOnSchedule()
    {
        click(XPATH_CREATE_LINEHAUL_BUTTON_ONSCHEDULE);
    }

    public void clickAddHubButton()
    {
        click(XPATH_ADD_HUB_BUTTON);
    }

    public void clickRemoveHubButton()
    {
        click(XPATH_REMOVE_HUB_BUTTON);
    }

    public void clickCreateButton()
    {
        click(XPATH_CREATE_BUTTON);
    }

    public void clickSaveChangesButton()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("container.shipment-management.save-changes");
    }

    public void clickTab(String nameTab)
    {
        String xpath = XPATH_LINEHAUL_ENTRIES_TAB;

        if("LINEHAUL DATE".equalsIgnoreCase(nameTab))
        {
            xpath = XPATH_LINEHAUL_DATE_TAB;
        }

        click(xpath);
        pause3s();
    }

    public void clickOnLabelCreate()
    {
        click(XPATH_LABEL_CREATE_LINEHAUL);
    }

    public void clickOnLabelEdit()
    {
        click(XPATH_LABEL_EDIT_LINEHAUL);
    }

    public void search(String value)
    {
        searchTableCustom1("id", value);
        waitUntilInvisibilityOfElementLocated("//h5[text()='Loading more results...']");
    }

    public void fillLinehaulNameFT(String name)
    {
        retryIfStaleElementReferenceExceptionOccurred(()-> sendKeys(XPATH_LINEHAUL_NAME_TF, name), "fillLinehaulNameFT");
    }

    public void fillCommentsFT(String comment)
    {
        sendKeys(XPATH_COMMENT_TF, comment);
    }

    public void fillHubs(List<String> hubs)
    {
        int hubCount = findElementsByXpath(XPATH_REMOVE_HUB_BUTTON).size();

        for(int i=0; i<hubCount; i++)
        {
            clickRemoveHubButton();
        }

        int index = 0;

        for(String hub : hubs)
        {
            clickAddHubButton();
            selectValueFromMdSelectByName("select-hub-"+index, hub);
            index++;
        }
    }

    public void chooseFrequency(String frequencyValue)
    {
        selectValueFromMdSelectByIdContains("select-frequency", frequencyValue);
    }

    public void chooseWorkingDays(List<String> days)
    {
        selectMultipleValuesFromMdSelectById("select-days-of-week", days);
    }

    public List<WebElement> grabListOfLinehaulWebElements()
    {
        return findElementsByXpath(XPATH_TABLE_ITEM);
    }

    public List<WebElement> grabListOfLinehaulId()
    {
        return findElementsByXpath(XPATH_TABLE_ITEM+"/td[3]");
    }

    public List<Linehaul> grabListOfLinehaul()
    {
        List<WebElement> list = grabListOfLinehaulWebElements();
        List<Linehaul> result = new ArrayList<>();

        for(WebElement element : list)
        {
            Linehaul linehaul = new Linehaul(element);
            result.add(linehaul);
        }

        return result;
    }

    public void clickDeleteButton()
    {
        click(XPATH_DELETE_BUTTON);
    }

    public void clickLinehaulScheduleDate(Calendar date)
    {
        selectValueFromMdSelect("calendar.month", TestUtils.integerToMonth(date.get(Calendar.MONTH)));
        pause1s();
        selectValueFromMdSelect("calendar.year", String.valueOf(date.get(Calendar.YEAR)));
        pause1s();
        click("//div[@tabindex='" + date.get(Calendar.DAY_OF_MONTH) + "']");
    }

    public void clickEditLinehaulAtDate(String linehaulId)
    {
        click(getXpathLinehaulInfoOnSchedule(linehaulId) + "/div/nv-icon-text-button/button[@aria-label='edit linehaul']");
    }

    public void checkLinehaulAtDate(String linehaulId)
    {
        waitUntilVisibilityOfElementLocated(getXpathLinehaulInfoOnSchedule(linehaulId));
    }

    private String getXpathLinehaulInfoOnSchedule(String linehaulId)
    {
        return "//md-card-content[div[span[text()='Linehaul ID : " + linehaulId + "']]]";
    }

    public void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }

    public void clickEditSearchFilterButton()
    {
        click(XPATH_EDIT_SEARCH_FILTER_BUTTON);
    }

    public void waitUntilLinehaulEntriesIsLoaded()
    {
        waitUntilVisibilityOfElementLocated("//button[@aria-label='Load Selection']");
    }

    public void waitUntilLinehaulDateTabIsLoaded()
    {
        waitUntilInvisibilityOfElementLocated("//md-progress-circular/parent::*[@style='display: inherit;']");
    }
}
