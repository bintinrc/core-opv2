package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import com.google.common.base.Strings;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.List;

public class AntDropdown extends PageElement {
    public AntDropdown(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public AntDropdown(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public AntDropdown(WebDriver webDriver) {
        super(webDriver);
        PageFactory.initElements(webDriver, this);
    }

    @FindBy(className = "ant-select-selection-selected-value")
    public PageElement selectValueElement;
    @FindBy(css = ".anticon.anticon-close-circle.ant-select-clear-icon")
    public PageElement closeIcon;
    @FindBy(css = ".anticon.anticon-down.ant-select-arrow-icon")
    public PageElement arrowIcon;
    @FindBy(css = ".ant-tag.ant-tag-has-color")
    public PageElement tagValueElement;

    public void selectValue(String value) {
        if (Strings.isNullOrEmpty(value)) {
            boolean isExist = closeIcon.isDisplayedFast();
            if (isExist) {
                closeIcon.click();
            } else {
                arrowIcon.click();
            }
        } else {
            String menuItem = String.format("//div[contains(@class,'ant-dropdown')][not(contains(@class,'ant-dropdown-hidden'))]//li[contains(@class,'ant-dropdown-menu-item')]//span[text() = '%s']", StringUtils.normalizeSpace(value));
            Boolean isPresent = isElementExistWait1Second(menuItem);
            if (isPresent) {
                clickf(menuItem);
            } else {
                clickf("//div[contains(@class,'ant-dropdown')][not(contains(@class,'ant-dropdown-hidden'))]//div[text()='%s']", StringUtils.normalizeSpace(value));
            }
        }
    }

    private void openMenu() {
        waitUntilClickable();
        click();
        pause1s();
    }

    public String getValue() {
        return selectValueElement.isDisplayedFast() ?
                selectValueElement.getText() :
                null;
    }

    public String getTagValue() {
        return tagValueElement.isDisplayedFast() ? tagValueElement.getText() : null;
    }

    public int getItemCount() {
        openMenu();
        pause1s();
        List<WebElement> listEle = getWebDriver().findElements(By.xpath("//div[contains(@class,'ant-dropdown')][not(contains(@class,'ant-dropdown-hidden'))]//li[@role='option']"));
        int itemcount = listEle.size();
        openMenu();
        return itemcount;
    }

    public String getItemNameByIndex(int index) {
        openMenu();
        pause1s();
        List<WebElement> listEle = getWebDriver().findElements(By.xpath("//div[contains(@class,'ant-dropdown')][not(contains(@class,'ant-dropdown-hidden'))]//li[@role='option']"));
        String itemName = listEle.get(index - 1).getText();
        openMenu();
        return itemName;
    }

    public int getItemIndexByName(String name){
        openMenu();
        pause1s();
        List<WebElement> listEle = getWebDriver().findElements(By.xpath("//div[contains(@class,'ant-dropdown')][not(contains(@class,'ant-dropdown-hidden'))]//li[@role='option']"));
        for(int i = 0; i < listEle.size(); i++){
            if(listEle.get(i).getText().equals(name)){
                return i;
            }
        }
        openMenu();
        return -1;
    }
}