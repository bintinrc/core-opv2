package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestConstants;
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
@SuppressWarnings("WeakerAccess")
public class ShipmentManagementPage extends OperatorV2SimplePage
{
    public static final String XPATH_CREATE_SHIPMENT_BUTTON = "//nv-table-button[@id='create-shipment-1']/button";
    public static final String XPATH_CREATE_SHIPMENT_CONFIRMATION_BUTTON = "//nv-table-button[@id='createButton']/button";
    //public static final String XPATH_LOAD_ALL_SHIPMENT_BUTTON = "//button[@aria-label='Load Selection']";
    //public static final String XPATH_SAVE_CHANGES_BUTTON = "//button[div[text()='Save Changes']]";
    public static final String XPATH_LINEHAUL_DROPDOWN = "//div[p[text()='Select Linehaul']]/md-select";
    public static final String XPATH_START_HUB_DROPDOWN = "//div[p[text()='Start Hub']]/md-select";
    public static final String XPATH_END_HUB_DROPDOWN = "//div[p[text()='End Hub']]/md-select";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, \"md-active\")]/md-select-menu/md-content/md-option";
    public static final String XPATH_COMMENT_TEXT_AREA = "//textarea[@id=\"comment\"]";
    public static final String XPATH_SHIPMENTS_TR = "//tr[@md-virtual-repeat='shipment in getTableData()']";
    public static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[contains(@aria-label, 'Edit Filter')]";
    //public static final String XPATH_LABEL_EDIT_SHIPMENT = "//h4[text()='Edit Shipment']";
    public static final String XPATH_SORT_DIV = "//div[div[span[text()='Sort by']]]";
    public static final String XPATH_DELETE_CONFIRMATION_BUTTON = "//button[span[text()='Delete']]";
    public static final String XPATH_FORCE_SUCCESS_CONFIRMATION_BUTTON = "//button[span[text()='Confirm']]";
    public static final String XPATH_CANCEL_SHIPMENT_BUTTON = "//button[div[text()='Cancel Shipment']]";
    //public static final String XPATH_DISCARD_CHANGE_BUTTON = "//button[h5[text()='Discard Changes']]";
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
        pause1s();
    }

    public void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }

    public void clickButtonSaveChangesOnEditShipmentDialog(String shipmentId)
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("Save Changes");
        pause1s();
        waitUntilInvisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s updated']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public List<Shipment> getShipmentsFromTable()
    {
        List<Shipment> shipmentsResult = new ArrayList<>();
        List<WebElement> shipments = findElementsByXpath(XPATH_SHIPMENTS_TR);

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
        return findElementByXpath(XPATH_LINEHAUL_DROPDOWN);
    }

    private WebElement grabStartHubDiv()
    {
        return findElementByXpath(XPATH_START_HUB_DROPDOWN);
    }

    private WebElement grabEndHubDiv()
    {
        return findElementByXpath(XPATH_END_HUB_DROPDOWN);
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
        pause200ms();
    }

    public void selectEndHub(String hubName)
    {
        grabEndHubDiv().click();
        pause1s();
        click(XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + hubName + "']]");
        pause200ms();
    }

    public void fillFieldComments(String comments)
    {
        sendKeys(XPATH_COMMENT_TEXT_AREA, comments);
        pause200ms();
    }

    public void setupSort(String var1, String var2)
    {
        WebElement sort = findElementByXpath(XPATH_SORT_DIV);
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
        TestUtils.hoverMouseTo(getWebDriver(), "//md-virtual-repeat-container[@aria-hidden='false']/div/div/ul/li/md-autocomplete-parent-scope/span");
        click("//h4[text()='Select Search Filters']");

        sendKeys(String.format("//nv-autocomplete[@item-types='%s']//input[@aria-label='Search or Select...']", filterLabel), value);
        clickf("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", value);
        TestUtils.hoverMouseTo(getWebDriver(), "//md-virtual-repeat-container[@aria-hidden='false']/div/div/ul/li/md-autocomplete-parent-scope/span");
        click("//h4[text()='Select Search Filters']");

        pause1s();
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
        WebElement scan = findElementByXpath(xpath);
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
        waitUntilInvisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Shipment %s created']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);

        return shipmentId;
    }

    public void clickActionButton(String shipmentId, String actionButton)
    {
        List<Shipment> shipments = getShipmentsFromTable();

        for(Shipment shipment : shipments)
        {
            if(shipment.getId().equals(shipmentId))
            {
                shipment.clickShipmentActionButton(actionButton);
                break;
            }
        }

        pause200ms();
    }

    public void waitUntilForceToastDisappear(String shipmentId)
    {
        waitUntilInvisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Success changed status to Force Success for Shipment ID %s']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public void clickCancelShipmentButton(String shipmentId)
    {
        click(XPATH_CANCEL_SHIPMENT_BUTTON);
        List<WebElement> toasts = getToasts();
        String actualToastText = "";

        for(WebElement toast : toasts)
        {
            actualToastText = toast.getText();

            if(actualToastText.contains("Success changed status to Cancelled for Shipment ID " + shipmentId))
            {
                break;
            }
        }

        Assert.assertThat("Toast message not contains Cancelled", actualToastText, Matchers.containsString("Success changed status to Cancelled for Shipment ID " + shipmentId));
        waitUntilInvisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Success changed status to Cancelled for Shipment ID %s']", shipmentId), TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public void verifyShipmentUpdatedSuccessfully(String shipmentId, String expectedStartHub, String expectedEndHub, String expectedComment)
    {
        List<Shipment> shipments = getShipmentsFromTable();
        String actualStartHub = "";
        String actualEndHub = "";
        String actualComment = "";

        for(Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(shipmentId))
            {
                actualStartHub = shipment.getStartHub();
                actualEndHub = shipment.getEndHub();
                actualComment = shipment.getComment();
            }
        }

        Assert.assertEquals("Start Hub value", expectedStartHub, actualStartHub);
        Assert.assertEquals("End Hub value", expectedEndHub, actualEndHub);
        Assert.assertEquals("Comment value", expectedComment, actualComment);
    }

    public void verifyShipmentDeletedSuccessfully(String shipmentId)
    {
        WebElement toastWe = getToast();
        String expectedMessage = String.format("Success delete Shipping ID %s", shipmentId);
        String toastText = toastWe.getText();
        Assert.assertThat(String.format("Toast message does not contain '%s'.", expectedMessage), toastText, Matchers.containsString(expectedMessage));
        waitUntilInvisibilityOfElementLocated(String.format("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='%s']", expectedMessage), TestConstants.VERY_LONG_WAIT_FOR_TOAST);

        List<Shipment> shipments = getShipmentsFromTable();
        boolean isRemoved = true;

        for(Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(shipmentId))
            {
                isRemoved = false;
            }
        }

        Assert.assertTrue("Shipment is not removed.", isRemoved);
    }

    public void verifyInboundedShipmentExist(String shipmentId)
    {
        TestUtils.retryIfAssertionErrorOccurred(()->
        {
            try
            {
                List<Shipment> shipmentList = getShipmentsFromTable();
                boolean isExist = false;

                for(ShipmentManagementPage.Shipment shipment : shipmentList)
                {
                    if(shipment.getId().equalsIgnoreCase(shipmentId))
                    {
                        isExist = true;
                        break;
                    }
                }

                Assert.assertTrue(String.format("Shipment with ID = '%s' not exist", shipmentId), isExist);
            }
            catch(AssertionError ex)
            {
                clickEditSearchFilterButton();
                clickButtonLoadSelection();
                throw ex;
            }
        }, getCurrentMethodName());
    }

    public void checkStatus(String shipmentId, String expectedStatus)
    {
        List<Shipment> shipments = getShipmentsFromTable();
        String actualStat = "";

        for(Shipment shipment : shipments)
        {
            String spId = shipment.getId();

            if(spId.equals(shipmentId))
            {
                actualStat = shipment.getStatus();
                break;
            }
        }

        Assert.assertEquals("Shipment " + shipmentId + " status", expectedStatus, actualStat);
    }

    public void clearAllFilters()
    {
        if(findElementByXpath(XPATH_CLEAR_FILTER_BUTTON).isDisplayed())
        {
            if(findElementByXpath(XPATH_CLEAR_FILTER_VALUE).isDisplayed())
            {
                List<WebElement> clearValueBtnList = findElementsByXpath(XPATH_CLEAR_FILTER_VALUE);

                for(WebElement clearBtn : clearValueBtnList)
                {
                    clearBtn.click();
                    pause1s();
                }
            }

            click(XPATH_CLEAR_FILTER_BUTTON);
        }

        pause2s();
    }

    public void closeScanModal()
    {
        click(XPATH_CLOSE_SCAN_MODAL_BUTTON);
        pause1s();
    }

    public class Shipment
    {
        public final String DELETE_ACTION = "Delete";
        public final String FORCE_ACTION = "Force";
        private final WebElement shipmentWe;

        private String id;
        private String status;
        private String startHub;
        private String endHub;
        private String comment;

        public Shipment(WebElement shipmentWe)
        {
            List<WebElement> listOfElements = shipmentWe.findElements(By.tagName("td"));
            this.shipmentWe = shipmentWe;
            this.id = listOfElements.get(2).getText().trim();
            this.status = listOfElements.get(4).getText().trim();
            this.startHub = listOfElements.get(5).getText().trim();
            this.endHub = listOfElements.get(8).getText().trim();
            this.comment = listOfElements.get(10).getText().trim();
        }

        public void clickShipmentActionButton(String actionButton)
        {
            WebElement editAction = grabShipmentAction(actionButton);
            moveAndClick(editAction);

            if(actionButton.equals(DELETE_ACTION))
            {
                pause1s();
                click(XPATH_DELETE_CONFIRMATION_BUTTON);
                pause2s();
            } else if (actionButton.equals(FORCE_ACTION))
            {
                pause1s();
                click(XPATH_FORCE_SUCCESS_CONFIRMATION_BUTTON);
            }
        }

        public WebElement grabShipmentAction(String action)
        {
            List<WebElement> actionButtons = shipmentWe.findElements(By.tagName("button"));

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
            return shipmentWe;
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
