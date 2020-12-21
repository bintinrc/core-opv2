package co.nvqa.operator_v2.selenium.page;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.openqa.selenium.WebDriver;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class PrinterTemplatesPage extends OperatorV2SimplePage {

  public PrinterTemplatesPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectTemplate(String templateName) {
    selectValueFromMdSelectByAriaLabel("Select the template", templateName);
  }

  public void verifyTemplateIsLoadedAndAllNeededFieldsIsShownOnRightPanel() {
    String labelTemplate = getText("//div[@class='template-container']");
    assertNotNull("Label template not loaded.", labelTemplate);

    String regex = "\\{\\{(.*?)}}";
    Pattern pattern = Pattern.compile(regex);
    Matcher matcher = pattern.matcher(labelTemplate);
    List<String> expectedFields = new ArrayList<>();

    while (matcher.find()) {
      String expectedField = matcher.group(1);

      if (expectedField.equals(
          "tracking_id")) // I don't know why tracking_id became quantity. This is based on the source code that Rizaq show to me.
      {
        expectedField = "quantity";
      }

      expectedFields.add(expectedField);
    }

    for (String expectedField : expectedFields) {
      assertTrue(f("Field '%s' not found.", expectedField), isElementExist(
          f("//div[./h5[text()='Fields']]/following-sibling::div//label[text()='%s']",
              expectedField)));
    }
  }
}
