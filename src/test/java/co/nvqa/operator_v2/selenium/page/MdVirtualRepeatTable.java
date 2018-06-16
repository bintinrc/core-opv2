package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DataEntity;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

public class MdVirtualRepeatTable<T extends DataEntity> extends AbstractTable<T>
{
    private String mdVirtualRepeat = "data in getTableData()";

    public MdVirtualRepeatTable(WebDriver webDriver)
    {
        super(webDriver);
    }

    public String getMdVirtualRepeat()
    {
        return mdVirtualRepeat;
    }

    public void setMdVirtualRepeat(String mdVirtualRepeat)
    {
        this.mdVirtualRepeat = mdVirtualRepeat;
    }

    @Override
    protected String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, mdVirtualRepeat);
    }

    @Override
    public void clickActionButton(int rowNumber, String actionId)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonsLocators.get(actionId), mdVirtualRepeat);
    }

    @Override
    public int getRowsCount()
    {
        return getRowsCountOfTableWithNgRepeat(mdVirtualRepeat);
    }
}
