package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import java.io.File;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class UploadFileDialog extends MdDialog {

  @FindBy(css = "[label='Choose']")
  public NvButtonFilePicker chooseButton;

  @FindBy(name = "Submit")
  public NvButtonSave submit;

  public UploadFileDialog(WebDriver webDriver, WebElement webElement) {
    super(webDriver, webElement);
  }

  public void uploadFile(File file) {
    waitUntilVisible();
    chooseButton.setValue(file);
    submit.clickAndWaitUntilDone();
  }
}
