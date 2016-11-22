package com.nv.qa.selenium.page.page;

import com.nv.qa.model.Linehaul;
import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by lanangjati
 * on 10/24/16.
 */
public class ShipmentLinehaulPage {

    private final WebDriver driver;

    private static final String XPATH_CREATE_LINEHAUL_BUTTON = "//button[div[text()='Create Linehaul']]";
    private static final String XPATH_EDIT_ACTION_BUTTON = "//nv-icon-button[@name='Edit']/button";
    private static final String XPATH_LINEHAUL_NAME_TF = "//input[contains(@name,'linehaul-name')]";
    private static final String XPATH_COMMENT_TF = "//textarea[contains(@name,'comments')]";
    private static final String XPATH_ADD_HUB_BUTTON = "//button[@aria-label='Add Hub']";
    private static final String XPATH_REMOVE_HUB_BUTTON = "//button[@aria-label='remove']";
    private static final String XPATH_LABEL_CREATE_LINEHAUL = "//h4[text()='Create Linehaul']";
    private static final String XPATH_LABEL_EDIT_LINEHAUL = "//h4[text()='Edit Linehaul']";
    private static final String XPATH_CREATE_BUTTON = "//button[@aria-label='Create']";
    private static final String XPATH_SAVE_CHANGES_BUTTON = "//button[@aria-label='Save Changes']";
    private static final String XPATH_SEARCH = "//input[@id='id']";
    private static final String XPATH_TABLE_ITEM = "//tr[@md-virtual-repeat='lh in ctrl.linehauls']";
    private static final String XPATH_LINEHAUL_ENTRIES_TAB = "//md-tab-item/span[text()='Linehaul Entries']";
    private static final String XPATH_LINEHAUL_DATE_TAB = "//md-tab-item/span[text()='Linehaul Date']";

    public ShipmentLinehaulPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    public void clickCreateLinehaul() {
        CommonUtil.clickBtn(driver, XPATH_CREATE_LINEHAUL_BUTTON);
    }

    public void clickEditActionButton() {
        CommonUtil.clickBtn(driver, XPATH_EDIT_ACTION_BUTTON);
    }

    public void clickAddHubButton() {
        CommonUtil.clickBtn(driver, XPATH_ADD_HUB_BUTTON);
    }

    public void clickRemoveHubButton() {
        CommonUtil.clickBtn(driver, XPATH_REMOVE_HUB_BUTTON);
    }

    public void clickCreateButton() {
        CommonUtil.clickBtn(driver, XPATH_CREATE_BUTTON);
    }

    public void clickSaveChangesButton() {
        CommonUtil.clickBtn(driver, XPATH_SAVE_CHANGES_BUTTON);
    }

    public void clickTab(String nameTab) {
        String xpath = XPATH_LINEHAUL_ENTRIES_TAB;
        if (nameTab.equalsIgnoreCase("linehaul date")) {
            xpath = XPATH_LINEHAUL_DATE_TAB;
        }

        CommonUtil.clickBtn(driver, xpath);
    }

    public void clickOnLabelCreate() {
        CommonUtil.clickBtn(driver, XPATH_LABEL_CREATE_LINEHAUL);
    }

    public void clickOnLabelEdit() {
        CommonUtil.clickBtn(driver, XPATH_LABEL_EDIT_LINEHAUL);
    }

    public void search(String value) {
        CommonUtil.inputText(driver, XPATH_SEARCH, value);
    }

    public void fillLinehaulNameFT(String name) {
        CommonUtil.inputText(driver, XPATH_LINEHAUL_NAME_TF, name);
    }

    public void fillCommentsFT(String comment) {
        CommonUtil.inputText(driver, XPATH_COMMENT_TF, comment);
    }

    public void fillHubs(List<String> hubs) {

        int hubCount = driver.findElements(By.xpath(XPATH_REMOVE_HUB_BUTTON)).size();

        for (int i = 0; i < hubCount; i++) {
            clickRemoveHubButton();
        }

        int index = 0;
        for (String hub : hubs) {
            clickAddHubButton();
            CommonUtil.chooseValueFromMdContain(driver, "//md-select[@name='select-hub-" + index + "']", hub);
            index++;
        }
    }

    public void chooseFrequency(String frequencyValue) {
        CommonUtil.chooseValueFromMdContain(driver, "//md-select[contains(@name,'select-frequency')]", frequencyValue);
    }

    public void chooseWorkingDays(List<String> days) {
        CommonUtil.chooseValuesFromMdContain(driver, "//md-select[contains(@name,'select-days-of-week')]", days);
    }

    public List<WebElement> grabListOfLinehaul() {
        return driver.findElements(By.xpath(XPATH_TABLE_ITEM));
    }

    public List<WebElement> grabListOfLinehaulId() {
        return driver.findElements(By.xpath(XPATH_TABLE_ITEM+"/td[3]"));
    }

    public List<Linehaul> grabListofLinehaul() {
        List<WebElement> list = grabListOfLinehaul();
        List<Linehaul> result = new ArrayList<>();
        for (WebElement element : list) {
            Linehaul linehaul = extractLinehaulInfoFromTable(element);
            result.add(linehaul);
        }

        return result;
    }

    public Linehaul extractLinehaulInfoFromTable(WebElement element) {
        Linehaul linehaul = new Linehaul();
        List<WebElement> column = element.findElements(By.tagName("td"));
        linehaul.setId(column.get(3).getText().trim());
        linehaul.setName(column.get(4).getText());
        String hubs = (column.get(5).getText() + "," + column.get(6).getText() + "," + column.get(7).getText()).replaceAll("\\s+", "");
        if (column.get(6).getText().contains(",-")) {
            hubs = hubs.replace(",-", "");
        }
        linehaul.setHubs(hubs);
        linehaul.setFrequency(column.get(8).getText());
        linehaul.setDays(column.get(9).getText());
        linehaul.setComment(column.get(12).getText());
        return linehaul;
    }
}
