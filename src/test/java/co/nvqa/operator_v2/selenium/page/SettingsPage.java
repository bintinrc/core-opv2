package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Veera
 */
public class SettingsPage extends OperatorV2SimplePage {

  public SettingsPage(WebDriver webDriver) {
    super(webDriver);
  }

  @FindBy(css = "md-select[aria-label*='Language'] div.md-text")
  public PageElement selectedLanguage;

  @FindBy(css = "[aria-label*='Language']")
  public MdSelect language;

  public void selectLanguageAs(String lang) {
    waitUntilVisibilityOfElementLocated(language.getWebElement());
    language.selectValue(lang);
    pause2s();
    String chosenLang = selectedLanguage.getText().trim();
    Assert.assertTrue(f("Assert that the language chosen is %s", lang),
        chosenLang.equalsIgnoreCase(lang));
  }

}