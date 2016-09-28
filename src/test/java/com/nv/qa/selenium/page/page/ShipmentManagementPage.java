package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by lanangjati
 * on 9/6/16.
 */
public class ShipmentManagementPage {

    private final WebDriver driver;
    public static final String XPATH_CREATE_SHIPMENT_BUTTON = "//nv-table-button[@id='create-shipment-1']/button";
    public static final String XPATH_CREATE_SHIPMENT_CONFIRMATION_BUTTON = "//nv-table-button[@id='createButton']/button";
//    public static final String XPATH_LOAD_ALL_SHIPMENT_BUTTON = "//button[span[text()='Load All Shipments']]";
    public static final String XPATH_LOAD_ALL_SHIPMENT_BUTTON = "//button[contains(@aria-label, 'Load All Shipment')]";
    public static final String XPATH_SAVE_CHANGES_BUTTON = "//button[span[text()='Save Changes']]";
    public static final String XPATH_START_HUB_DROPDOWN = "//div[p[text()='Start Hub']]/md-select";
    public static final String XPATH_END_HUB_DROPDOWN = "//div[p[text()='End Hub']]/md-select";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, \"md-active\")]/md-select-menu/md-content/md-option";
    public static final String XPATH_COMMENT_TEXT_AREA = "//textarea[@id=\"comment\"]";
    public static final String XPATH_SHIPMENTS_TR = "//tr[@md-virtual-repeat=\"shipment in ctrl.shipments\"]";
//    public static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[span[text()='Edit Filters & Sort']]";
    public static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[contains(@aria-label, 'Edit Filters and Sort')]";
    public static final String XPATH_SORT_DIV = "//div[div[span[text()='Sort by']]]";
    public static final String XPATH_DELETE_CONFIRMATION_BUTTON = "//button[span[text()='Delete']]";
    public static final String XPATH_CANCEL_SHIPMENT_BUTTON = "//button[span[text()='Cancel Shipment']]";
    public static final String XPATH_DISCARD_CHANGE_BUTTON = "//button[h5[text()='Discard Changes']]";


    public List<Shipment> getShipmentsFromTable() {
        List<Shipment> shipmentsResult = new ArrayList<>();
        List<WebElement> shipments = driver.findElements(By.xpath(XPATH_SHIPMENTS_TR));
        for (WebElement shipment : shipments) {
            Shipment sh = new Shipment(shipment);
            shipmentsResult.add(sh);
        }

        return shipmentsResult;
    }

    public Shipment getShipmentFromTable(int index) {
        return getShipmentsFromTable().get(index);
    }

    public ShipmentManagementPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    private WebElement grabStartHubDiv() {
        return driver.findElement(By.xpath(XPATH_START_HUB_DROPDOWN));
    }

    private WebElement grabEndHubDiv() {
        return driver.findElement(By.xpath(XPATH_END_HUB_DROPDOWN));
    }

    public void selectStartHub(String hubName) {
        grabStartHubDiv().click();
        CommonUtil.pause10ms();

        CommonUtil.clickBtn(driver,XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + hubName + "']]");
    }

    public void selectEndHub(String hubName) {
        grabEndHubDiv().click();
        CommonUtil.pause10ms();

        CommonUtil.clickBtn(driver,XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + hubName + "']]");
    }

    public void setupSort(String var1, String var2) {
        WebElement sort = driver.findElement(By.xpath(XPATH_SORT_DIV));
        List<WebElement> sortVars = sort.findElements(By.tagName("md-select"));

        sortVars.get(0).click();
        CommonUtil.pause10ms();
        CommonUtil.clickBtn(driver,XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + var1 + "']]");

        sortVars.get(1).click();
        CommonUtil.pause10ms();
        CommonUtil.clickBtn(driver,XPATH_HUB_ACTIVE_DROPDOWN + "[div[text()='" + var2 + "']]");
    }

    public String grabXPathFilter(String filterLabel) {
        return "//nv-filter-box[div[div[text()='" + filterLabel + "']]]/nv-autocomplete/div";
    }

    public String grabXPathFilterValue(String value) {
        return "//md-virtual-repeat-container[@class='md-autocomplete-suggestions-container md-whiteframe-z1 md-virtual-repeat-container md-orient-vertical']/div/div/ul/li[md-autocomplete-parent-scope[span[text()='" + value + "']]]";
    }

    public class Shipment {

        private final WebElement shipment;
        private String id;
        private String status;
        private String startHub;
        private String endHub;
        private String comment;

        public final String DELETE_ACTION = "Delete";

        public Shipment(WebElement shipment) {
            this.shipment = shipment;
            this.id = shipment.findElements(By.tagName("td")).get(2).findElement(By.tagName("span")).getText();
            this.status = shipment.findElements(By.tagName("td")).get(4).findElement(By.tagName("span")).getText();
            this.startHub = shipment.findElements(By.tagName("td")).get(5).findElement(By.tagName("span")).getText();
            this.endHub = shipment.findElements(By.tagName("td")).get(8).findElement(By.tagName("span")).getText();
            this.comment = shipment.findElements(By.tagName("td")).get(10).getText();
        }

        public void clickShipmentActionButton(String actionButton) {
            WebElement editAction = grabShipmentAction(actionButton);
            CommonUtil.moveAndClick(driver, editAction);

            if (actionButton.equals(DELETE_ACTION)) {
                CommonUtil.pause1s();
                CommonUtil.clickBtn(driver, XPATH_DELETE_CONFIRMATION_BUTTON);
            }
        }

        public WebElement grabShipmentAction(String action) {
            List<WebElement> actionButtons = shipment.findElements(By.tagName("button"));
            for (WebElement actionButton : actionButtons) {
                if (actionButton.getAttribute("aria-label").equalsIgnoreCase(action)) {
                    return actionButton;
                }
            }
            return null;
        }

        public WebElement getShipment() {
            return shipment;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getStartHub() {
            return startHub;
        }

        public void setStartHub(String startHub) {
            this.startHub = startHub;
        }

        public String getEndHub() {
            return endHub;
        }

        public void setEndHub(String endHub) {
            this.endHub = endHub;
        }

        public String getComment() {
            return comment;
        }

        public void setComment(String comment) {
            this.comment = comment;
        }
    }
}
