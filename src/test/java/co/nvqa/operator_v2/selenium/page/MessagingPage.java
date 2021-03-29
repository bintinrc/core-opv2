package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class MessagingPage extends OperatorV2SimplePage {

  @FindBy(css = "button[aria-label='SMS']")
  public Button smsButton;
  @FindBy(css = "md-autocomplete[placeholder='Add Driver']")
  public MdAutocomplete addDriver;
  @FindBy(css = "md-autocomplete[placeholder='Add Group']")
  public MdAutocomplete addGroup;
  @FindBy(css = "p.selected-count")
  public PageElement selectedCount;
  @FindBy(css = "p[ng-if='hiddenCount > 0']")
  public PageElement hiddenCount;
  @FindBy(css = "md-grid-tile div.name")
  public List<PageElement> driverNames;

  public MessagingPage(WebDriver webDriver) {
    super(webDriver);
  }
}
