package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import java.util.List;
import java.util.function.Consumer;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class PackTidGeneratorSkuPage extends OperatorV2SimplePage {

  public static final String ITEM_EQUALS_LOCATOR = "//li[text()='%s']";
  public static final String GENERATED_FILE_NAME = "trackingids";

  @FindBy(xpath = "//iframe[contains(@src,'pregen-tids')]")
  public PageElement iframe;

  @FindBy(xpath = "//div[contains(@class,'ant-select-selection__rendered')]")
  public AntSelect productSku;

  @FindBy(xpath = "//input[@id='register_quantity']")
  public TextBox quantity;

  @FindBy(xpath = "//button[contains(.,'Generate tracking ids')]")
  public Button generateButton;

  public PackTidGeneratorSkuPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectProductSku(String productName) {
    inFrame(page -> {
      page.waitUntilVisibilityOfElementLocated(page.productSku.getWebElement());
      page.productSku.click();
      String xpath = f(ITEM_EQUALS_LOCATOR, productName);
      page.waitUntilVisibilityOfElementLocated(page.findElementByXpath(xpath));
      page.click(xpath);

    });
  }

  public void fillQuantity(int quantity) {
    inFrame(page -> {
      page.waitUntilVisibilityOfElementLocated(page.quantity.getWebElement());
      page.quantity.sendKeys(quantity);
    });
  }

  public void clickGenerateButton() {
    inFrame(page -> {
      page.waitUntilVisibilityOfElementLocated(page.generateButton.getWebElement());
      page.generateButton.click();
    });
  }

  public List<String> readGeneratedCsvFile() {
    String fileName = getLatestDownloadedFilename(GENERATED_FILE_NAME);

    return readDownloadedFile(fileName);
  }

  private void inFrame(Consumer<PackTidGeneratorSkuPage> consumer) {
    getWebDriver().switchTo().defaultContent();
    iframe.waitUntilVisible();
    getWebDriver().switchTo().frame(iframe.getWebElement());
    try {
      consumer.accept(this);
    } finally {
      getWebDriver().switchTo().defaultContent();
      }
  }
}
