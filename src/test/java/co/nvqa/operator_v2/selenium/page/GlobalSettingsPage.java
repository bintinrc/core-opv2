package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdCheckbox;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class GlobalSettingsPage extends OperatorV2SimplePage {

  @FindBy(id = "inputWeightTolerance")
  public TextBox inputWeightTolerance;

  @FindBy(css = "nv-api-text-button[form='ctrl.data.weightTolerance.form']")
  public NvApiTextButton updateWeightTolerance;

  @FindBy(id = "inputMaxWeightLimit")
  public TextBox inputMaxWeightLimit;

  @FindBy(css = "nv-api-text-button[form='ctrl.data.maxWeightLimit.form']")
  public NvApiTextButton updateMaxWeightLimit;

  @FindBy(css = "nv-api-text-button[state='ctrl.state.smsSettings.update']")
  public NvApiTextButton updateSmsSettings;

  @FindBy(css = "md-checkbox[aria-label='Enable Van Inbound SMS Shipper Ids']")
  public MdCheckbox enableVanInboundSms;

  @FindBy(css = "md-checkbox[aria-label='Enable Return Pickup SMS Shipper Ids']")
  public MdCheckbox enableReturnPickupSms;

  @FindBy(css = "nv-autocomplete[selected-options='ctrl.data.selectedVanInboundShipper']")
  public NvAutocomplete exemptedShippersFromVanInboundSms;

  @FindBy(css = "nv-autocomplete[selected-options='ctrl.data.selectedReturnPickupShipper']")
  public NvAutocomplete exemptedShippersFromReturnPickupSms;

  @FindBy(css = "div[ng-if='ctrl.data.selectedVanInboundShipper.length > 0'] nv-icon-text-button")
  public List<NvIconTextButton> selectedVanInboundShippers;

  @FindBy(css = "div[ng-if='ctrl.data.selectedReturnPickupShipper.length > 0'] nv-icon-text-button")
  public List<NvIconTextButton> selectedReturnPickupShipper;


  public GlobalSettingsPage(WebDriver webDriver) {
    super(webDriver);
  }
}
