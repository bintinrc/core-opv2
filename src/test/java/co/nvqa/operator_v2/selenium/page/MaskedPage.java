package co.nvqa.operator_v2.selenium.page;

import java.util.List;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public interface MaskedPage {

  Logger LOGGER = LoggerFactory.getLogger(MaskedPage.class);


  String MASKING_XPATH = "//span[contains(text(), 'Click to reveal (tracked)')]";


  default void operatorClickMaskingText(List<WebElement> masking) {
    masking.forEach(m -> {
      try {
        m.click();
      } catch (Exception ex) {
        LOGGER.debug("mask element not found");
      }
    });
  }

}
