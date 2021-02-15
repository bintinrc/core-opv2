package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
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

  public GlobalSettingsPage(WebDriver webDriver) {
    super(webDriver);
  }
}
