package com.nv.qa.selenium.page.page;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;

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
    private static final String XPATH_LABEL_CREATE_LINEHAUL = "//h4[text()='Create Linehaul']";
    private static final String XPATH_CREATE_BUTTON = "//button[@aria-label='Create']";
    private static final String XPATH_SEARCH = "//input[@id='id']";
    private static final String XPATH_TABLE_ITEM = "//tr[@md-virtual-repeat='lh in ctrl.linehauls']";

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

    public void clickCreateButton() {
        CommonUtil.clickBtn(driver, XPATH_CREATE_BUTTON);
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
        int index = 0;
        for (String hub : hubs) {
            if (index > 1) {
                clickAddHubButton();
            }
            CommonUtil.chooseValueFromMdContain(driver, "//md-select[@name='select-hub-" + index + "']", hub);
            index++;
        }
    }

    public void chooseFrequency(String frequencyValue) {
        CommonUtil.chooseValueFromMdContain(driver, "//md-select[contains(@name,'select-frequency')]", frequencyValue);
    }

    public void chooseWorkingDays(List<String> days) {
        CommonUtil.chooseValuesFromMdContain(driver, "//md-select[contains(@name,'select-days-of-week')]", days);
        CommonUtil.clickBtn(driver, XPATH_LABEL_CREATE_LINEHAUL);
    }

    public List<WebElement> grabListOfLinehaul() {
        return driver.findElements(By.xpath(XPATH_TABLE_ITEM));
    }

    public List<WebElement> grabListOfLinehaulComment() {
        return driver.findElements(By.xpath(XPATH_TABLE_ITEM+"/td[12]"));
    }
}
