package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.md.MdMenu;
import com.google.common.base.Preconditions;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
public class MdVirtualRepeatTable<T extends DataEntity<?>> extends AbstractTable<T>
{
    @FindBy(css = "th.column-checkbox md-menu")
    public MdMenu selectionMenu;

    private String nvTableParam;
    private String mdVirtualRepeat = "data in getTableData()";

    public MdVirtualRepeatTable(WebDriver webDriver)
    {
        super(webDriver);
        PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
    }

    public String getMdVirtualRepeat()
    {
        return mdVirtualRepeat;
    }

    public void setMdVirtualRepeat(String mdVirtualRepeat)
    {
        this.mdVirtualRepeat = mdVirtualRepeat;
    }

    public void setNvTableParam(String nvTableParam)
    {
        this.nvTableParam = nvTableParam;
    }

    public void selectAllShown()
    {
        selectionMenu.selectOption("Select All Shown");
    }

    @Override
    protected String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat, nvTableParam);
    }

    @Override
    public void clickActionButton(int rowNumber, String actionId)
    {
        String actionButtonLocator = actionButtonsLocators.get(actionId);
        Preconditions.checkArgument(StringUtils.isNotBlank(actionButtonLocator), "Unknown action [" + actionId + "]");

        if (StringUtils.startsWith(actionButtonLocator, "/"))
        {
            clickCustomActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonLocator, mdVirtualRepeat);
        } else
        {
            clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonLocator, mdVirtualRepeat);
        }
    }

    @Override
    public int getRowsCount()
    {
        return getRowsCountOfTableWithMdVirtualRepeat(mdVirtualRepeat, nvTableParam);
    }

    @Override
    public void selectRow(int rowNumber)
    {
        clickf(".//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'column-checkbox')]/md-checkbox", mdVirtualRepeat, rowNumber);
    }

    @Override
    protected String getTableLocator()
    {
        return StringUtils.isNotBlank(nvTableParam) ? f(".//nv-table[@param='%s'][.//tr[@md-virtual-repeat='%s']]", nvTableParam, mdVirtualRepeat) : f(".//nv-table[.//tr[@md-virtual-repeat='%s']]", mdVirtualRepeat);
    }

    @Override
    public void clickColumn(int rowNumber, String columnId)
    {
        throw new UnsupportedOperationException();
    }
}
