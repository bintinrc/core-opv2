package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class DriverSeedingPage extends OperatorV2SimplePage {

  public DriverSeedingPage(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(css = "nv-autocomplete[item-types='zones']")
  public NvAutocomplete zones;

  @FindBy(css = "md-checkbox[aria-label='Inactive Drivers']")
  public MdCheckbox inactiveDrivers;

  @FindBy(css = "md-checkbox[aria-label='All Preferred Zones']")
  public MdCheckbox allPreferredZones;

  @FindBy(css = "md-checkbox[aria-label='Reserve Fleet Drivers']")
  public MdCheckbox reserveFleetDrivers;

  @FindBy(css = "h3")
  public List<PageElement> drivers;

  @FindBy(css = "div.leaflet-marker-icon")
  public List<DriverMark> driverMarks;

  public static class DriverMark extends PageElement {

    public DriverMark(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(css = "img")
    public PageElement mark;

    @FindBy(css = "span")
    public PageElement label;
  }
}