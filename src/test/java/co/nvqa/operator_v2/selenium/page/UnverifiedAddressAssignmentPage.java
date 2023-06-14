package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.TxnAddress;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterDateBox;
import com.google.common.collect.ImmutableMap;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class UnverifiedAddressAssignmentPage extends
    SimpleReactPage<UnverifiedAddressAssignmentPage> {

  public TxnAddressTable txnAddressTable;

  @FindBy(css = "nv-autocomplete[placeholder='filter.select-filter']")
  public NvAutocomplete addFilter;

  @FindBy(css = "nv-filter-box[item-types='Zone']")
  public NvFilterBox zoneFilter;

  @FindBy(xpath = "//nv-filter-date-box[.//p[.='Due Date']]")
  public NvFilterDateBox dueDateFilter;

  @FindBy(css = "nv-filter-box[item-types='Delivery Type']")
  public NvFilterBox deliveryTypeFilter;

  @FindBy(css = "[data-testid='load-addresses']")
  public AntButton loadSelection;

  @FindBy(css = "div.select-zone")
  public AntSelect selectZone;

  @FindBy(xpath = "//button[.='Assign']")
  public Button assignButton;

  public UnverifiedAddressAssignmentPage(WebDriver webDriver) {
    super(webDriver);
    txnAddressTable = new TxnAddressTable(webDriver);
  }

  /**
   * Accessor for Transaction/Reservation table
   */
  public static class TxnAddressTable extends AntTable<TxnAddress> {

    public static final String MD_VIRTUAL_REPEAT = "trvn in getTableData()";
    public static final String COLUMN_ADDRESS = "address";

    public TxnAddressTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("score", "score")
          .put(COLUMN_ADDRESS, "address")
          .build()
      );
      setEntityClass(TxnAddress.class);
    }
  }

  public void verifyNotificationWithMessage(String containsMessage) {
    String notificationXpath = "//div[contains(@class,'ant-notification')]//div[@class='ant-notification-notice-message']";
    waitUntilVisibilityOfElementLocated(notificationXpath);
    WebElement notificationElement = findElementByXpath(notificationXpath);
    Assertions.assertThat(notificationElement.getText()).as("Toast message is the same")
        .isEqualTo(containsMessage);
    waitUntilInvisibilityOfNotification(notificationXpath, false);
  }

}