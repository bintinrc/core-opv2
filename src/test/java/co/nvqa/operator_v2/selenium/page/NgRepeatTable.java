package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DataEntity;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Sergey Mishanin
 */
public class NgRepeatTable<T extends DataEntity> extends AbstractTable<T>
{
    private String ngRepeat;

    public NgRepeatTable(WebDriver webDriver)
    {
        super(webDriver);
    }

    public String getNgRepeat()
    {
        return ngRepeat;
    }

    public void setNgRepeat(String ngRepeat)
    {
        this.ngRepeat = ngRepeat;
    }

    public void waitUntilVisibility()
    {
        String xpath = String.format("//tr[@ng-repeat='%s']", ngRepeat);
        waitUntilVisibilityOfElementLocated(xpath);
    }

    @Override
    protected String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, ngRepeat);
    }

    @Override
    public void clickActionButton(int rowNumber, String actionId)
    {
        clickActionButtonOnTableWithNgRepeat(rowNumber, actionButtonsLocators.get(actionId), ngRepeat);
    }

    @Override
    public int getRowsCount()
    {
        return getRowsCountOfTableWithNgRepeat(ngRepeat);
    }
}
