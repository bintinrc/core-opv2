package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import java.util.List;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class ThB2BPage extends SimpleReactPage<TagManagementPage> {

  @FindBy(css = "[data-testid='upload-csv-button']")
  public Button uploadCsv;
  @FindBy(xpath = "//div[@class='ant-modal-content']")
  public UploadCsvDialog uploadCsvDialog;

  @FindBy(css = "[data-datakey='tracking_id']")
  public List<PageElement> trackingIds;

  @FindBy(css = "[data-datakey='route_id']")
  public List<PageElement> routeIds;

  @FindBy(css = "[data-datakey='status']")
  public List<PageElement> status;

  @FindBy(css = "[data-datakey='message']")
  public List<PageElement> messages;

  public ThB2BPage(WebDriver webDriver) {
    super(webDriver);
  }

  public static class UploadCsvDialog extends AntModal {

    @FindBy(css = "[data-testid='download-sample-file-button']")
    public Button downloadSampleFile;
    @FindBy(xpath = "//input[@type='file']")
    public FileInput fileUpload;
    @FindBy(css = "[data-testid='upload-button']")
    public Button upload;

    public UploadCsvDialog(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }
  }
}
