package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

public class SsbTemplatePage extends OperatorV2SimplePage {

  private static String XPATH_HEADER_COLUMN = "//div[@data-testid='options-drop-area']//div[text()='%s']";

  @FindBy(xpath = "//button[@label='Create New Template']")
  public Button createNewTemplateBtn;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(xpath = "//h1[text()='SSB Report Template Editor']")
  public PageElement createTemplateHeader;
  private WebElement element;
  @FindBy(xpath = "//input[@data-testid='name-input']")
  private PageElement templateNameInput;
  @FindBy(xpath = "//input[@data-testid='description-input']")
  private PageElement templateDescriptionInput;
  @FindBy(xpath = "//button[@data-testid='back-btn']")
  private Button goBackBtn;
  @FindBy(xpath = "//button[@data-testid='download-example-btn']")
  private Button downloadExampleCsvBtn;
  @FindBy(xpath = "//button[@data-testid='submit-btn']")
  private Button submitBtn;
  @FindBy(xpath = "//div[@data-testid='selected-drop-area']")
  private PageElement to;
  @FindBy(xpath = "//div[@data-testid='options-drop-area']//div[text()='Legacy Shipper ID']")
  private PageElement from;

  public SsbTemplatePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilLoaded() {
    if (spinner.waitUntilVisible(10)) {
      spinner.waitUntilInvisible();
    }
  }

  public void setTemplateName(String name) {
    templateNameInput.sendKeys(name);
  }

  public void setTemplateDescription(String description) {
    templateDescriptionInput.sendKeys(description);
  }

  public void dragAndDropColumn(String column) {
    //option 1
    WebElement from1 = findElementBy(By.xpath("//div[text()='Legacy Shipper ID']"));
    WebElement to1 = findElementBy(
        By.xpath("//div[@data-testid='selected-drop-area']"));

    Actions actions = new Actions(getWebDriver());
    actions
        .dragAndDrop(from1, to1)
        .pause(2000)
        .release()
        .perform();
    pause7s();

    //option 2
    from.scrollIntoView();
    from.moveAndClick();
    from.dragAndDropBy(40, 0);

    // option 3
    try {
      String filePath = "src/test/java/co/nvqa/operator_v2/util/drag_and_drop_helper.js";
      String jqueryPath = "src/test/java/co/nvqa/operator_v2/util/jquery-3.6.0.js";

      StringBuffer buffer = new StringBuffer();

      String line;
      BufferedReader br = new BufferedReader(new FileReader(filePath));
      while ((line = br.readLine()) != null) {
        buffer.append(line);
      }

      Path path = Paths.get(jqueryPath);

      String jquery = Files.readAllLines(path).get(0);

      String javaScript = buffer.toString();
      javaScript = jquery + javaScript
          + "$('div:contains(\"Legacy Shipper ID\")').simulateDragDrop({ dropTarget: 'div[data-testid=\"selected-drop-area\"]'});";//a[rel="nofollow self"]
      ((JavascriptExecutor) getWebDriver()).executeScript(javaScript);


    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}