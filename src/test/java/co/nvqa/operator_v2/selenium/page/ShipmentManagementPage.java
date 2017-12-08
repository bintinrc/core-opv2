package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Lanang Jati
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
public class ShipmentManagementPage extends SimplePage
{
    public static final String XPATH_CREATE_SHIPMENT_BUTTON = "//nv-table-button[@id='create-shipment-1']/button";
    public static final String XPATH_CREATE_SHIPMENT_CONFIRMATION_BUTTON = "//nv-table-button[@id='createButton']/button";
    public static final String XPATH_LOAD_ALL_SHIPMENT_BUTTON = "//button[@aria-label='Load Selection']";
    public static final String XPATH_SAVE_CHANGES_BUTTON = "//button[div[text()='Save Changes']]";
    public static final String XPATH_LINEHAUL_DROPDOWN = "//div[p[text()='Select Linehaul']]/md-select";
    public static final String XPATH_START_HUB_DROPDOWN = "//div[p[text()='Start Hub']]/md-select";
    public static final String XPATH_END_HUB_DROPDOWN = "//div[p[text()='End Hub']]/md-select";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, \"md-active\")]/md-select-menu/md-content/md-option";
    public static final String XPATH_COMMENT_TEXT_AREA = "//textarea[@id=\"comment\"]";
    public static final String XPATH_SHIPMENTS_TR = "//tr[@md-virtual-repeat='shipment in getTableData()']";
    public static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[contains(@aria-label, 'Edit Filter')]";
    public static final String XPATH_LABEL_EDIT_SHIPMENT = "//h4[text()='Edit Shipment']";
    public static final String XPATH_SORT_DIV = "//div[div[span[text()='Sort by']]]";
    public static final String XPATH_DELETE_CONFIRMATION_BUTTON = "//button[span[text()='Delete']]";
    public static final String XPATH_CANCEL_SHIPMENT_BUTTON = "//button[div[text()='Cancel Shipment']]";
    public static final String XPATH_DISCARD_CHANGE_BUTTON = "//button[h5[text()='Discard Changes']]";
    public static final String XPATH_SHIPMENT_SCAN = "//div[contains(@class,'table-shipment-scan-container')]/table/tbody/tr";
    public static final String XPATH_CLOSE_SCAN_MODAL_BUTTON = "//button[@aria-label='Cancel']";
    public static final String XPATH_CLEAR_FILTER_BUTTON = "//button[@aria-label='Clear All Selections']";
    public static final String XPATH_CLEAR_FILTER_VALUE = "//button[@aria-label='Clear All']";

    public ShipmentManagementPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickEditSearchFilterButton()
    {
        click(XPATH_EDIT_SEARCH_FILTER_BUTTON);
    }

    public void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }

    public void clickButtonSaveChangesOnEditShipmentDialog()
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("Save Changes");
    }

    public List<Shipment> getShipmentsFromTable()
    {
        List<Shipment> shipmentsResult = new ArrayList<>();
        List<WebElement> shipments = getwebDriver().findElements(By.xpath(XPATH_SHIPMENTS_TR));

        for(WebElement shipment : shipments)
        {
            Shipment sh = new Shipment(shipment);
            shipmentsResult.add(sh);
        }

        return shipmentsResult;
    }

    public Shipment getShipmentFromTable(int index)
    {
        return getShipmentsFromTable().get(index);
    }

    private WebElement grabLineHaul()
    {
        return getwebDriver().findElement(By.xpath(XPATH_LINEHAUL_DROPDOWN));
    }

    private WebElement grabStartHubDiv()
    {
        return getwebDriver().findElement(By.xpath(XPATH_START_HUB_DROPDOWN));
    }

    private WebElement grabEndHubDiv()
    {
        return getwebDriver().findElement(By.xpath(XPATH_END_HUB_DROPDOWN));
    }

    public void selectFirstLineHaul()
    {
        grabLineHaul().click();
        pause1s();
        click(XPATH_HUB_ACTIVE_DROPDOWN + "[@ng-repeat='l in ctrl.linehauls']");
    }

    public void selectStartHub(String hubName)
    {
        grabStartHubDiv().click();
        pause1s();
        click(XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + hubName + "']]");
    }

    public void selectEndHub(String hubName)
    {
        grabEndHubDiv().click();
        pause1s();
        click(XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + hubName + "']]");
    }

    public void fillFieldComments(String comments)
    {
        sendKeys(XPATH_COMMENT_TEXT_AREA, comments);
    }

    public void setupSort(String var1, String var2)
    {
        WebElement sort = getwebDriver().findElement(By.xpath(XPATH_SORT_DIV));
        List<WebElement> sortVars = sort.findElements(By.tagName("md-select"));

        sortVars.get(0).click();
        pause1s();
        click(XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + var1 + "']]");

        sortVars.get(1).click();
        pause1s();
        click(XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + var2 + "']]");
        pause1s();
    }

    public void clickAddFilter(String filterLabel, String value)
    {
        click("//input[@placeholder='Select Filter']");
        click(grabXPathFilterDropdown(filterLabel));
        TestUtils.hoverMouseTo(getwebDriver(), "//md-virtual-repeat-container[@aria-hidden='false']/div/div/ul/li/md-autocomplete-parent-scope/span");
        click("//h4[text()='Select Search Filters']");

        sendKeys(String.format("//nv-autocomplete[@item-types='%s']//input[@aria-label='Search or Select...']", filterLabel), value);
        click(String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", value));
        TestUtils.hoverMouseTo(getwebDriver(), "//md-virtual-repeat-container[@aria-hidden='false']/div/div/ul/li/md-autocomplete-parent-scope/span");
        click("//h4[text()='Select Search Filters']");
    }

    public String grabXPathFilter(String filterLabel)
    {
        return "//nv-filter-box/div[div/p[text()='" + filterLabel + "']]/div/nv-autocomplete";
    }

    public String grabXPathFilterDropdown(String value)
    {
        return "//md-virtual-repeat-container[@aria-hidden='false']/div/div/ul/li/md-autocomplete-parent-scope/span[text()='" + value + "']";
    }

    public void shipmentScanExist(String source, String hub)
    {
        String xpath = XPATH_SHIPMENT_SCAN + "[td[text()='" + source + "']]" + "[td[text()='" + hub + "']]";
        WebElement scan = getwebDriver().findElement(By.xpath(xpath));
        Assert.assertEquals("shipment(" + source + ") not exist", "tr", scan.getTagName());
    }

    public String createShipment(String startHub, String endHub, String comment)
    {
        click(XPATH_CREATE_SHIPMENT_BUTTON);

        selectFirstLineHaul();
        pause200ms();

        selectStartHub(startHub);
        pause200ms();

        selectEndHub(endHub);
        pause200ms();

        fillFieldComments(comment);
        click(XPATH_CREATE_SHIPMENT_CONFIRMATION_BUTTON);

        WebElement toast = getToast();
        String toastMessage = toast.getText();

        Assert.assertThat("Toast message not contains Shipment <SHIPMENT_ID> created", toastMessage, Matchers.allOf(Matchers.containsString("Shipment"), Matchers.containsString("created")));
        String shipmentId = toastMessage.split(" ")[1];
        return shipmentId;
    }

    public class Shipment
    {
        public final String DELETE_ACTION = "Delete";
        private final WebElement shipment;

        private String id;
        private String status;
        private String startHub;
        private String endHub;
        private String comment;

        public Shipment(WebElement shipment)
        {
            this.shipment = shipment;
            this.id = shipment.findElements(By.tagName("td")).get(2).getText().trim();
            this.status = shipment.findElements(By.tagName("td")).get(4).getText().trim();
            this.startHub = shipment.findElements(By.tagName("td")).get(5).getText().trim();
            this.endHub = shipment.findElements(By.tagName("td")).get(8).getText().trim();
            this.comment = shipment.findElements(By.tagName("td")).get(10).getText().trim();
        }

        public void clickShipmentActionButton(String actionButton)
        {
            WebElement editAction = grabShipmentAction(actionButton);
            TestUtils.moveAndClick(getwebDriver(), editAction);

            if (actionButton.equals(DELETE_ACTION))
            {
                pause1s();
                click(XPATH_DELETE_CONFIRMATION_BUTTON);
            }
        }

        public WebElement grabShipmentAction(String action)
        {
            List<WebElement> actionButtons = shipment.findElements(By.tagName("button"));

            for(WebElement actionButton : actionButtons)
            {
                if(actionButton.getAttribute("aria-label").equalsIgnoreCase(action))
                {
                    return actionButton;
                }
            }

            return null;
        }

        public WebElement getShipment()
        {
            return shipment;
        }

        public String getId()
        {
            return id;
        }

        public void setId(String id)
        {
            this.id = id;
        }

        public String getStatus()
        {
            return status;
        }

        public void setStatus(String status)
        {
            this.status = status;
        }

        public String getStartHub()
        {
            return startHub;
        }

        public void setStartHub(String startHub)
        {
            this.startHub = startHub;
        }

        public String getEndHub()
        {
            return endHub;
        }

        public void setEndHub(String endHub)
        {
            this.endHub = endHub;
        }

        public String getComment()
        {
            return comment;
        }

        public void setComment(String comment)
        {
            this.comment = comment;
        }
    }
}
