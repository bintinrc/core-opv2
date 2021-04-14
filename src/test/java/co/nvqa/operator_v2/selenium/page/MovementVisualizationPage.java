package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.stream.IntStream;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Tristania Siagian
 */
public class MovementVisualizationPage extends OperatorV2SimplePage {

  @FindBy(xpath = "//button[.='Add Another Movement']")
  public Button addAnotherMovementEditModal;

  private static final String ELEMENT_USING_ID_XPATH = "//%s[contains(@id,'%s')]";
  private static final String MOVEMENT_VISUALIZATION_LOADED_XPATH = "//div[contains(@class,'MovementVisualizationSidebar')]";
  private static final String SELECT_HUB_TYPE_XPATH = "//input[@value='%s']";

  private static final String HUB_SELECTED_XPATH = "//div[contains(@class,'ant-select-dropdown')]//li[text()='%s']";
  private static final String HUB_TAG_XPATH = "//div[contains(@class,'HubTagContainer')]/div[contains(@class,'HubTag')]";
  private static final String FILTER_CLEARED_XPATH = "//div[div[a[contains(@id,'clear-filter-btn')]]]/following-sibling::div/span[contains(text(),'0')]";
  private static final String ACTUAL_HUB_SHOWN_XPATH = "//ul[contains(@class,'RelationList')]/li";
  private static final String INDEX_HUB_SHOWN_XPATH = "//ul[contains(@class,'RelationList')]/li[%d]";
  private static final String VIEW_SCHEDULE_BUTTON_INSIDE_MAP_XPATH = "//div[@class='mapboxgl-popup-content']/button";
  private static final String EDIT_BUTTON_ON_VIEW_SCHEDULE_XPATH = "//button[i[contains(@class,'anticon-edit')]]";
  private static final String RANDOM_CLICK_EDIT_MOVEMENT_MODAL_XPATH = "//div[contains(@class,'modal-title')]";
  private static final String SAVE_BUTTON_EDIT_MOVEMENT_MODAL_XPATH = "//button[contains(@class,'ant-btn')]/following-sibling::button[contains(@class,'btn-primary')]";
  //    private static final String INPUT_TIME_EDIT_MOVEMENT_MODAL_XPATH = "//input[contains(@class,'ant-time-picker-panel-input')]";
  private static final String INPUT_TIME_EDIT_MOVEMENT_MODAL_XPATH = "//div[contains(@class,'time-picker-panel-select')]//li[text()='13']";
  private static final String NOTIFICATION_EDIT_MOVEMENT_MODAL_XPATH = "//div[contains(@class,'notification-notice-message')]";
  private static final String CLOSE_BUTTON_VIEW_SCHEDULE_MODAL_XPATH = "//button[@aria-label='Close']";
  private static final String REMOVE_HREF_EDIT_MOVEMENT_MODAL_XPATH = "//div[contains(@class,'ScheduleMovementContainer')][3]//a[contains(@class,'RemoveLink')]";
  private static final String IFRAME_XPATH_MOVEMENT_VISUALIZATION = "//iframe[contains(@src,'movement-visualization')]";
  private static final String IFRAME_XPATH_MOVEMENT_MANAGEMENT = "//iframe[contains(@src,'movement')]";

  private static final String ASSERTION_EDITED_START_TIME_XPATH = "//tr[5]/td[contains(.,'13')][1]";
  private static final String ASSERTION_EDITED_DURATION_TIME_XPATH = "//tr[6]/td[contains(.,'00:13')][1]";

  private static final String HUB_ID = "hub";
  private static final String CLEAR_FILTER_BUTTON_ID = "clear-filter-btn";
  private static final String DIALOG_ID = "rcDialogTitle";
  private static final String START_TIME_EDIT_MOVEMENT_ID = "schedule[1][Movement 3].startTime";
  private static final String SELECT_TIME_EDIT_MOVEMENT_ID = "schedule[1][Movement 3].duration";

  private static final String ORIGIN_VALUE = "origin";
  private static final String DESTINATION_VALUE = "destination";

  private static final String A_ELEMENT = "a";
  private static final String DIV_ELEMENT = "div";
  private static final String INPUT_ELEMENT = "input";

  public MovementVisualizationPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectHubType(String hubType) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    waitUntilVisibilityOfElementLocated(MOVEMENT_VISUALIZATION_LOADED_XPATH);

    if ("origin".equalsIgnoreCase(hubType)) {
      click(f(SELECT_HUB_TYPE_XPATH, ORIGIN_VALUE));
    } else if ("destination".equalsIgnoreCase(hubType)) {
      click(f(SELECT_HUB_TYPE_XPATH, DESTINATION_VALUE));
    }
    pause1s();
    getWebDriver().switchTo().parentFrame();
  }

  public void selectHub(String hubName) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    click(f(ELEMENT_USING_ID_XPATH, DIV_ELEMENT, HUB_ID));
    sendKeys(f(ELEMENT_USING_ID_XPATH, INPUT_ELEMENT, HUB_ID), hubName);
    waitUntilVisibilityOfElementLocated(f(HUB_SELECTED_XPATH, hubName));
    click(f(HUB_SELECTED_XPATH, hubName));
    pause1s();
    verifiesSelectedHubBecomeHubTag();
    getWebDriver().switchTo().parentFrame();
  }

  public void clickOnHubName() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    click(HUB_TAG_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void clearFilter() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    click(f(ELEMENT_USING_ID_XPATH, A_ELEMENT, CLEAR_FILTER_BUTTON_ID));
    isElementExist(FILTER_CLEARED_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void verifiesHubShownIsTheSameToApi(List<String> apiHubRelation) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    List<String> actualHubRelationStorage = new ArrayList<>();
    List<WebElement> actualHubRelation = findElementsByXpath(ACTUAL_HUB_SHOWN_XPATH);
    for (WebElement hubRelationWe : actualHubRelation) {
      actualHubRelationStorage.add(hubRelationWe.getText());
    }

    Collections.sort(apiHubRelation);
    Collections.sort(actualHubRelationStorage);
    System.out.println(apiHubRelation.equals(actualHubRelationStorage));
    getWebDriver().switchTo().parentFrame();
  }

  public void clickIndexResult(int index) {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    click(f(INDEX_HUB_SHOWN_XPATH, index));
    waitUntilVisibilityOfElementLocated(VIEW_SCHEDULE_BUTTON_INSIDE_MAP_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void clickIndexResult() {
    clickIndexResult(1);
  }

  public void clickViewScheduleButtonAndVerifiesScheduleIsOpened() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    click(VIEW_SCHEDULE_BUTTON_INSIDE_MAP_XPATH);
    waitUntilVisibilityOfElementLocated(f(ELEMENT_USING_ID_XPATH, DIV_ELEMENT, DIALOG_ID));
    getWebDriver().switchTo().parentFrame();
  }

  public void clickEditButtonOnViewScheduleModal() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    click(EDIT_BUTTON_ON_VIEW_SCHEDULE_XPATH);
    pause100ms();
    switchToOtherWindow();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_MANAGEMENT));
    waitUntilVisibilityOfElementLocated(f(ELEMENT_USING_ID_XPATH, DIV_ELEMENT, DIALOG_ID));
    getWebDriver().switchTo().parentFrame();
  }

  public void editMovement() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_MANAGEMENT));

    Random random = new Random();
    IntStream hr = random.ints(10, 23);

    addAnotherMovementEditModal.click();
    click(f(ELEMENT_USING_ID_XPATH, INPUT_ELEMENT, START_TIME_EDIT_MOVEMENT_ID));
    pause1s();
    click(INPUT_TIME_EDIT_MOVEMENT_MODAL_XPATH);
//        sendKeys(INPUT_TIME_EDIT_MOVEMENT_MODAL_XPATH, "13:00");
    click(f(ELEMENT_USING_ID_XPATH, INPUT_ELEMENT, SELECT_TIME_EDIT_MOVEMENT_ID));
    pause1s();
    click(INPUT_TIME_EDIT_MOVEMENT_MODAL_XPATH);
//        sendKeys(INPUT_TIME_EDIT_MOVEMENT_MODAL_XPATH, "13 h 00 m");
    click(RANDOM_CLICK_EDIT_MOVEMENT_MODAL_XPATH);
    pause1s();
    click(SAVE_BUTTON_EDIT_MOVEMENT_MODAL_XPATH);
    waitUntilVisibilityOfElementLocated(NOTIFICATION_EDIT_MOVEMENT_MODAL_XPATH);
    waitUntilInvisibilityOfElementLocated(NOTIFICATION_EDIT_MOVEMENT_MODAL_XPATH);
    Set<String> handlesSet = getWebDriver().getWindowHandles();
    List<String> handlesList = new ArrayList<String>(handlesSet);
    getWebDriver().close();
    getWebDriver().switchTo().window(handlesList.get(0));
  }

  public void closeViewScheduleModal() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    pause1s();
    click(CLOSE_BUTTON_VIEW_SCHEDULE_MODAL_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void verifiesScheduleIsEdited() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_VISUALIZATION));
    isElementExist(ASSERTION_EDITED_START_TIME_XPATH);
    isElementExist(ASSERTION_EDITED_DURATION_TIME_XPATH);
    getWebDriver().switchTo().parentFrame();
  }

  public void deleteMovementChanging() {
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH_MOVEMENT_MANAGEMENT));
    click(REMOVE_HREF_EDIT_MOVEMENT_MODAL_XPATH);
    pause1s();
    click(SAVE_BUTTON_EDIT_MOVEMENT_MODAL_XPATH);
    waitUntilVisibilityOfElementLocated(NOTIFICATION_EDIT_MOVEMENT_MODAL_XPATH);
    waitUntilInvisibilityOfElementLocated(NOTIFICATION_EDIT_MOVEMENT_MODAL_XPATH);
    Set<String> handlesSet = getWebDriver().getWindowHandles();
    List<String> handlesList = new ArrayList<String>(handlesSet);
    getWebDriver().close();
    getWebDriver().switchTo().window(handlesList.get(0));
    getWebDriver().close();
  }

  private void verifiesSelectedHubBecomeHubTag() {
    waitUntilVisibilityOfElementLocated(HUB_TAG_XPATH);
  }

  private void switchToOtherWindow() {
    waitUntilNewWindowOrTabOpened();
    Set<String> windowHandles = getWebDriver().getWindowHandles();

    for (String windowHandle : windowHandles) {
      getWebDriver().switchTo().window(windowHandle);
    }
  }
}
