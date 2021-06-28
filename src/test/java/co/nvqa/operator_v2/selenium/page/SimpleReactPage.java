package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import java.util.List;
import java.util.function.Consumer;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class SimpleReactPage extends OperatorV2SimplePage {

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(css = ".ant-notification-notice")
  public List<AntNotification> noticeNotifications;

  public SimpleReactPage(WebDriver webDriver) {
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

  public void waitUntilVisibilityOfNotification(String message) {
    waitUntil(() ->
            noticeNotifications.stream().anyMatch(notification ->
                StringUtils.equalsIgnoreCase(notification.message.getText(), message))
        , 20000);
  }

  public void inFrame(Consumer<SimpleReactPage> consumer) {
    getWebDriver().switchTo().defaultContent();
    pageFrame.waitUntilVisible();
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
    try {
      consumer.accept(this);
    } finally {
      getWebDriver().switchTo().defaultContent();
    }
  }

  public void inFrame(Runnable consumer) {
    getWebDriver().switchTo().defaultContent();
    pageFrame.waitUntilVisible();
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
    try {
      consumer.run();
    } finally {
      getWebDriver().switchTo().defaultContent();
    }
  }
}
