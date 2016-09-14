package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.util.List;

/**
 * Created by lanangjati
 * on 9/6/16.
 */
public class ShipmentManagementPage {

    private final WebDriver driver;
    public static final String XPATH_CREATE_SHIPMENT_BUTTON = "//nv-table-button[@id='create-shipment-1']/button";
    public static final String XPATH_CREATE_SHIPMENT_CONFIRMATION_BUTTON = "//nv-table-button[@id='createButton']/button";
    public static final String XPATH_LOAD_ALL_SHIPMENT_BUTTON = "//button[@aria-label=\"Load All Shipments\"]";
    public static final String XPATH_SAVE_CHANGES_BUTTON = "//button[span[text()='Save Changes']]";
    public static final String XPATH_START_HUB_DROPDOWN = "//div[p[text()='Start Hub']]/md-select";
    public static final String XPATH_END_HUB_DROPDOWN = "//div[p[text()='End Hub']]/md-select";
    public static final String XPATH_HUB_ACTIVE_DROPDOWN = "//div[contains(@class, \"md-active\")]/md-select-menu/md-content/md-option";
    public static final String XPATH_COMMENT_TEXT_AREA = "//textarea[@id=\"comment\"]";
    public static final String XPATH_SHIPMENTS_TR = "//tr[@md-virtual-repeat=\"shipment in ctrl.shipments\"]";
    public static final String XPATH_EDIT_SEARCH_FILTER_BUTTON = "//button[span[text()='Edit Filters & Sort']]";
    public static final String XPATH_SORT_DIV = "//div[@id='select_order_container']";
    public static final String XPATH_DELETE_CONFIRMATION_BUTTON = "//button[span[text()='Delete']]";
    public static final String XPATH_CANCEL_SHIPMENT_BUTTON = "//button[span[text()='Cancel Shipment']]";
    public static final String XPATH_DISCARD_CHANGE_BUTTON = "//button[h5[text()='Discard Changes']]";

    public final String EDIT_ACTION = "Edit";
    public final String FORCE_ACTION = "Force";
    public final String DELETE_ACTION = "Delete";


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

    public List<WebElement> grabShipments() {
        return driver.findElements(By.xpath(XPATH_SHIPMENTS_TR));
    }

    public void clickShipmentActionButton(WebElement shipment, String actionButton) {
        WebElement editAction = grabShipmentAction(shipment, actionButton);
        CommonUtil.moveAndClick(driver, editAction);
    }

    private WebElement grabShipmentAction(WebElement shipment, String action) {
        List<WebElement> actionButtons = shipment.findElements(By.tagName("button"));
        for (WebElement actionButton : actionButtons) {
            if (actionButton.getAttribute("aria-label").equalsIgnoreCase(action)) {
                return actionButton;
            }
        }
        return null;
    }
}
