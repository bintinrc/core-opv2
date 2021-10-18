package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author Veera
 */
public class StationCODReportPage extends OperatorV2SimplePage {

    public StationCODReportPage(WebDriver webDriver) {
        super(webDriver);
    }
    private static final String STATION_COD_REPORT_BUTTON_XPATH = "//button[@disabled]//*[text()='%s']";

    @FindBy(css = "md-select[aria-label*='Language'] div.md-text")
    public PageElement selectedLanguage;

    @FindBy(css = "[aria-label*='Language']")
    public MdSelect language;

    @FindBy(css = "iframe")
    private List<PageElement> pageFrame;

    @FindBy(xpath = "//div[@class='nv-filter-container']//div[@class='ant-col']//div")
    private List<PageElement> fieldNames;

    public void switchToStationCODReportFrame() {
        getWebDriver().switchTo().frame(pageFrame.get(0).getWebElement());
    }

    public void verifyStationCODReportFields(List expectedFields) {
        List<String> actualFields = new ArrayList<String>();
        if (pageFrame.size() > 0) {
            switchToStationCODReportFrame();
        }
        fieldNames.forEach( (field) -> actualFields.add( field.getText().trim() ));
        Assert.assertTrue(f("Assert that all ui elements are displayed in %s as expected", "Station COD Report"),
                actualFields.containsAll(expectedFields));
    }

    public void verifyButtonDisplayedInDisabledState(String buttonName) {
        String buttonXpath = f(STATION_COD_REPORT_BUTTON_XPATH, buttonName);
        List<WebElement> buttons = getWebDriver().findElements(By.xpath(buttonXpath));
        int isDisplayed = buttons.size();
        Assert.assertTrue(f("Assert that the button : %s is displayed, and is in disabled state", buttonName),
                isDisplayed > 0);
    }


}