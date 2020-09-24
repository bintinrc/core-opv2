package co.nvqa.operator_v2.selenium.elements.ant;

import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class AntSelect extends PageElement
{
    public AntSelect(WebDriver webDriver, WebElement webElement)
    {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public AntSelect(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
    {
        super(webDriver, searchContext, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(className = "ant-select-selection-selected-value")
    public PageElement selectValueElement;

    @FindBy(className = "ant-select-search__field")
    public PageElement searchInput;

    public void selectValue(String value)
    {
        enterSearchTerm(value);
        clickf("//div[@class='ant-select-dropdown-menu']//div[@class='BaseTable__row-cell-text'][contains(normalize-space(text()), '%s')]", StringUtils.normalizeSpace(value));
    }

    private void openMenu()
    {
        waitUntilClickable();
        jsClick();
        pause1s();
    }

    private void enterSearchTerm(String value)
    {
        openMenu();
        searchInput.sendKeys(value);
        pause1s();
    }

    public String getValue()
    {
        return selectValueElement.isDisplayedFast() ?
                selectValueElement.getText() :
                null;
    }
}