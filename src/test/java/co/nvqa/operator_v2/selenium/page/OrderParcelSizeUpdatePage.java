package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import co.nvqa.operator_v2.util.TestUtils;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import static org.apache.commons.lang3.StringUtils.trimToEmpty;

/**
 * @author Sergey Mishanin
 */
public class OrderParcelSizeUpdatePage extends OperatorV2SimplePage {

  @FindBy(name = "container.order-parcel-size-update.find-orders-with-csv")
  public NvIconTextButton findOrdersWithCsv;

  @FindBy(name = "container.order-parcel-size-update.upload-selected")
  public NvIconTextButton upload;

  @FindBy(css = "md-dialog")
  public FindOrdersWithCsvDialog findOrdersWithCsvDialog;

  public OrderParcelSizeUpdatePage(WebDriver webDriver) {
    super(webDriver);
  }

  public static class FindOrdersWithCsvDialog extends MdDialog {

    @FindBy(css = "[label='Select File']")
    public NvButtonFilePicker chooseButton;

    @FindBy(name = "commons.upload")
    public NvApiTextButton upload;

    @FindBy(name = "commons.cancel")
    public NvIconTextButton cancel;

    @FindBy(name = "commons.edit")
    public NvIconTextButton edit;

    @FindBy(xpath = ".//a[text()='here']")
    public Button downloadSample;

    public FindOrdersWithCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void uploadFile(File file) {
      waitUntilVisible();
      chooseButton.setValue(file);
      edit.waitUntilVisible();
      upload.clickAndWaitUntilDone();
    }
  }

  public File buildMultiCreateOrderUpdateCsv(List<String> trackIds, List<String> listSize) {
    try {
      File file = TestUtils.createFileOnTempFolder(
          String.format("create-mutli-order-update_%s.csv", generateDateUniqueString()));
      PrintWriter pw = new PrintWriter(new FileOutputStream(file));
      for (int i = 0; i < trackIds.size(); i++) {
        String orderAsSb = trimToEmpty(trackIds.get(i)) + ',' +
            '"' + trimToEmpty(listSize.get(i)) + '"';
        pw.write(orderAsSb);
        pw.write(System.lineSeparator());

      }
      pw.close();
      return file;
    } catch (IOException ex) {
      throw new NvTestRuntimeException(ex);
    }
  }
}