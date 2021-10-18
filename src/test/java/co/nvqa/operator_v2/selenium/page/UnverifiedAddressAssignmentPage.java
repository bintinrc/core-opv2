package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.TxnAddress;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterDateBox;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class UnverifiedAddressAssignmentPage extends OperatorV2SimplePage {

  public TxnAddressTable txnAddressTable;

  @FindBy(css = "nv-autocomplete[placeholder='filter.select-filter']")
  public NvAutocomplete addFilter;

  @FindBy(css = "nv-filter-box[item-types='Zone']")
  public NvFilterBox zoneFilter;

  @FindBy(xpath = "//nv-filter-date-box[.//p[.='Due Date']]")
  public NvFilterDateBox dueDateFilter;

  @FindBy(css = "nv-filter-box[item-types='Delivery Type']")
  public NvFilterBox deliveryTypeFilter;

  @FindBy(name = "commons.load-selection")
  public NvApiTextButton loadSelection;

  @FindBy(css = "md-autocomplete[placeholder='Assign to zone']")
  public MdAutocomplete selectZone;

  @FindBy(id = "assignButton")
  public MdAutocomplete assignButton;

  public UnverifiedAddressAssignmentPage(WebDriver webDriver) {
    super(webDriver);
    txnAddressTable = new TxnAddressTable(webDriver);
  }

  /**
   * Accessor for Transaction/Reservation table
   */
  public static class TxnAddressTable extends MdVirtualRepeatTable<TxnAddress> {

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
      setMdVirtualRepeat("txn in getTableData()");
    }
  }

}