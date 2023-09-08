package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
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
public class OrderParcelSizeUpdatePage extends SimpleReactPage<OrderParcelSizeUpdatePage> {

  @FindBy(css = "[data-testid='upload-csv-button']")
  public Button findOrdersWithCsv;

  @FindBy(css = "[data-testid='upload-button']")
  public Button upload;

  @FindBy(css = ".ant-modal")
  public FindOrdersWithCsvDialog findOrdersWithCsvDialog;

  public OrderParcelSizeUpdatePage(WebDriver webDriver) {
    super(webDriver);
  }

  public static class FindOrdersWithCsvDialog extends AntModal {

    @FindBy(css = "[data-testid='upload-dragger']")
    public FileInput chooseButton;

    @FindBy(css = "[data-testid='upload-button']")
    public Button upload;

    @FindBy(css = "[data-testid='cancel-button']")
    public Button cancel;

    @FindBy(css = ".ant-upload-list-item-name")
    public PageElement uploadedItem;

    @FindBy(css = "[data-testid='download-sample-file-button']")
    public Button downloadSample;

    public FindOrdersWithCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void uploadFile(File file) {
      waitUntilVisible();
      chooseButton.setValue(file);
      uploadedItem.waitUntilVisible();
      upload.click();
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