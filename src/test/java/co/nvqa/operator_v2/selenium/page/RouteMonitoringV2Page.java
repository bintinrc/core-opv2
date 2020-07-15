package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteMonitoringParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntFilterSelect;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class RouteMonitoringV2Page extends OperatorV2SimplePage
{
    @FindBy(css = ".ant-spin")
    public PageElement spinner;

    @FindBy(tagName = "iframe")
    private PageElement pageFrame;

    @FindBy(xpath = "//div[@class='filter-container'][contains(.,'Hubs')]")
    public AntFilterSelect hubsFilter;

    @FindBy(xpath = "//div[@class='filter-container'][contains(.,'Zones')]")
    public AntFilterSelect zonesFilter;

    @FindBy(xpath = "//button[.='Load Selection']")
    public Button loadSelection;

    public final RouteMonitoringTable routeMonitoringTable;

    public RouteMonitoringV2Page(WebDriver webDriver)
    {
        super(webDriver);
        routeMonitoringTable = new RouteMonitoringTable(webDriver);
    }

    public void switchTo()
    {
        getWebDriver().switchTo().frame(pageFrame.getWebElement());
    }

    public static class RouteMonitoringTable extends AntTable<RouteMonitoringParams>
    {
        public static final String COLUMN_ROUTE_ID = "routeId";

        public RouteMonitoringTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_ROUTE_ID, "routeId")
                    .put("totalParcels", "totalParcels")
                    .build()
            );
            setEntityClass(RouteMonitoringParams.class);
        }
    }
}
