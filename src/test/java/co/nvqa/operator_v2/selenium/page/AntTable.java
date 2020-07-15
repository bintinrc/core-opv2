package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class AntTable<T extends DataEntity<?>> extends AbstractTable<T>
{
    public AntTable(WebDriver webDriver)
    {
        super(webDriver);
        PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
    }

    @Override
    protected String getTextOnTable(int rowNumber, String columnDataClass)
    {
        String xpath = f(".//tr[%d]/td[contains(@class,'%s')]", rowNumber, columnDataClass);
        return getText(xpath);
    }

    @Override
    public void clickActionButton(int rowNumber, String actionId)
    {
        throw new UnsupportedOperationException("Not implemented yet");
    }

    @Override
    public int getRowsCount()
    {
        return getElementsCount(".//tr");
    }

    @Override
    public void selectRow(int rowNumber)
    {
        throw new UnsupportedOperationException("Not implemented yet");
    }

    @Override
    protected String getTableLocator()
    {
        return "//div[contains(@class,'nv-table')]";
    }

    @Override
    public AbstractTable<T> filterByColumn(String columnId, String value)
    {
        String xpath = f("//th[contains(@class,'%s')]//input", columnId);
        sendKeys(xpath, value);
        return this;
    }

    public AbstractTable<T> filterByColumn(String columnId, Object value)
    {
        return filterByColumn(columnId, String.valueOf(value));
    }
}
