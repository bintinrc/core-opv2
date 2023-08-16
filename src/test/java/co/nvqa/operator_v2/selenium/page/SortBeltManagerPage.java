package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commonsort.model.sort_vendor.FilterForm;
import co.nvqa.commonsort.model.sort_vendor.LogicForm;
import co.nvqa.commonsort.model.sort_vendor.RuleForm;
import co.nvqa.operator_v2.model.ArmCombination;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntButton;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.VirtualSelect;
import co.nvqa.operator_v2.selenium.elements.md.MdSwitch;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.common.collect.ImmutableMap;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class SortBeltManagerPage extends OperatorV2SimplePage {

  public static final String ARM_LIST_XPATH = "//div[contains(@class,'arm-combination-unit-content')][.//div[contains(@class,'arm-output')][.//.='%d']]";
  public static final String SUMMARY_XPATH = "//div[@class='section summary-section']";
  public static final String CREATE_COPY_DIALOG_XPATH = "//div[@class='ant-modal-header']/div[text()='Create a copy']";
  public static final String SEARCH_LOGIC_RESULT_XPATH = "//div[@class='title' and text()='%s']";
  public static final String CAN_NOT_SAVE_POPUP_XPATH = "//div[contains(@class,'ant-notification-notice-message') and text()='Incomplete Form Submission']";
  public static final String ACTIVATED_LOGIC_POPUP_XPATH = "//div[contains(@class,'ant-notification-notice-message') and text()='Logic Activated']";
  public static final String SUB_PAGE_HEADER_XPATH = "//div[@class='section-header']//div[text()='%s']";
  public static final String DROPDOWN_SELECTIONS_XPATH = "//div[@class='ant-select-item-option-content' and text()='%s']";
  public static final String DROPDOWN_SELECTIONS_LIST_XPATH = "//div[@class='ant-select-item-option-content']";
  public static final String LOGIC_MAPPING_COLUMN_XPATH = "//div[contains(@class, 'logic-mapping-table')]//span[text()='%s']";
  public static final String COLUMN_MAPPING_XPATH = "((//div[contains(@class, 'logic-mapping-table')]//div[@class='logic-mapping-rule'])[%d])//div[contains(@class, 'editable-cell')][%d]";
  public static final String ARM_FILTERS_DISABLED_XPATH = "//div[contains(@class,'ant-select-item-option-disabled')]";

  public static final String ADD_RULE_XPATH = "//button[@data-testid='add-rule-button']";
  public static final String NO_RULE_XPATH = "//div[contains(text(),'No rules attached: %d arm(s)')]";
  public static final String MULTIPLE_RULE_XPATH = "//div[contains(text(),'Multiple arms with the same rules: %d rule(s) across %d arm(s)')]";

  public static final String UNIQUE_RULE_XPATH = "//div[contains(text(),'Unique rules and arms: %d Results')]";
  public static final String CONFLICTING_SHIPMENT_DESTINATION_RULE_XPATH = "//div[contains(text(),'Conflicting shipment destination & type: %d rule(s) across %d arm(s)')]";

  public static final String DELETE_RULE_XPATH = "//span[contains(@data-testid,'delete-icon')]";
  public static final String DELETE_RULE_SPECIFIC_XPATH = "//span[@data-testid='delete-icon-%d']";
  public static final String FORM_LOGIC_NAME_VALUE_XPATH = "//input[@data-testid='logic-name-input']";
  public static final String FORM_LOGIC_DESCRIPTION_VALUE_XPATH = "//input[@data-testid='logic-description-input']";
  public static final String FORM_LOGIC_ARM_FILTERS_VALUE_XPATH = "//div[@data-testid='arm-filters-selection']//span[@class='ant-select-selection-item-content']";
  public static final String FORM_LOGIC_UNASSIGNED_ARM_VALUE_XPATH = "//input[@id='unassignedParcelArm']/parent::span/following-sibling::span";
  public static final String FORM_RULE_ALL_XPATH = "//div[contains(@class, 'logic-mapping-table')]//span[@class='rule-number']";
  public static final String FORM_RULE_NUMBER_VALUE_XPATH = "(//div[contains(@class, 'logic-mapping-table')]//span[@class='rule-number'])[%d]";
  public static final String FORM_RULE_ARM_VALUE_XPATH = "(//div[@class='editable-cell-holder arm_ids']//div)[%d]";
  public static final String FORM_RULE_DESCRIPTION_VALUE_XPATH = "(//div[@class='editable-cell-holder description']//div)[%d]";
  public static final String FORM_RULE_FILTERS_VALUE_XPATH = "((//div[contains(@class, 'logic-mapping-table')]//div[@class='logic-mapping-rule'])[%d])//div[contains(@class, 'editable-cell')][%d]";
  public static final String FORM_RULE_SHIPMENT_DESTINATION_VALUE_XPATH = "(//div[@class='editable-cell-holder shipment_destination_hub_id']//div)[%d]";
  public static final String FORM_RULE_SHIPMENT_TYPE_VALUE_XPATH = "(//div[@class='editable-cell-holder shipment_type']//div)[%d]";

  public static final String FORM_RULE_RTS_VALUE_XPATH = "(//div[@class='editable-cell-holder rts']//div)[%d]";
  public static final String FORM_RULE_GRANULAR_STATUSES_VALUE_XPATH = "(//div[@class='editable-cell-holder granular_statuses']//div)[%d]";
  public static final String FORM_RULE_SERVICE_LEVELS_VALUE_XPATH = "(//div[@class='editable-cell-holder service_levels']//div)[%d]";
  public static final String FORM_RULE_TAGS_VALUE_XPATH = "(//div[@class='editable-cell-holder tags']//div)[%d]";

  public static final String CHECK_LOGIC_NAME_VALUE_XPATH = "//div[@class='section-content']//div[@class='summary']//div[@class='text-block category-title']";
  public static final String CHECK_LOGIC_DESCRIPTION_VALUE_XPATH = "//div[@class='section-content']//div[@class='summary']//div[@class='text-block info'][1]";
  public static final String CHECK_LOGIC_ARM_FILTERS_VALUE_XPATH = "//div[@class='section-content']//div[@class='summary']//div[@class='text-block info'][2]";
  public static final String CHECK_LOGIC_UNASSIGNED_ARM_VALUE_XPATH = "//div[@class='section-content']//div[@class='summary']//div[@class='text-block info'][3]";
  public static final String CHECK_LOGIC_ARMS_IN_USE_COUNT_VALUE_XPATH = "//div[@class='section-content']//div[@class='summary']//div[@class='text-block info'][4]";
  public static final String CHECK_LOGIC_ARMS_NOT_IN_USE_COUNT_VALUE_XPATH = "//div[@class='section-content']//div[@class='details-holder'][1]/div[@class='category-title']";
  public static final String CHECK_LOGIC_ARM_LIST_NOT_IN_USE_VALUE_XPATH = "//div[@class='section-content']//div[@class='details-holder'][1]/div[@class='details']";

  public static final String CHECK_LOGIC_MULTIPLE_ARMS_SUMMARY_XPATH = "//div[contains(text(),'Multiple arms with the same rules')]";
  public static final String CHECK_LOGIC_MULTIPLE_ARMS_TABLE_XPATH = "//div[contains(text(),'Multiple arms with the same rules')]/following-sibling::div//table";
  public static final String CHECK_LOGIC_UNIQUE_RULES_SUMMARY_XPATH = "//div[contains(text(),'Unique rules and arms')]";
  public static final String CHECK_LOGIC_UNIQUE_RULES_TABLE_XPATH = "//div[contains(text(),'Unique rules and arms')]/following-sibling::div//table";
  public static final String CHECK_LOGIC_DUPLICATE_RULES_SUMMARY_XPATH = "//div[contains(text(),'Multiple rules with the same filters')]";
  public static final String CHECK_LOGIC_DUPLICATE_RULES_TABLE_XPATH = "//div[contains(text(),'Multiple rules with the same filters')]/following-sibling::div//table";
  public static final String CHECK_LOGIC_CONFLICTING_RULES_SUMMARY_XPATH = "//div[contains(text(),'Conflicting shipment destination & type')]";

  public String DUPLICATE_KEY = "DUPLICATE_KEY";
  public static final String CANCEL_CREATE_DIALOG_XPATH = "//div[text()='Leave this page?']";
  public static final String LOGIC_DETAIL_NAME_VALUE_XPATH = "//div[@class='section-header']//div[contains(@class,'title')]";
  public static final String LOGIC_DETAIL_DESC_VALUE_XPATH = "//div[@class='section-header']//div[contains(@class,'title')]";
  public static final String LOGIC_DETAIL_ARM_FILTERS_VALUE_XPATH = "//div[@class='ant-row'][2]//div[contains(@class,'logic-details')][2]";

  @FindBy(xpath = "(//div[contains(@class,'ant-select-selector')])[1]")
  public VirtualSelect selectHub;

  @FindBy(xpath = "(//div[contains(@class,'ant-select-selector')])[2]")
  public VirtualSelect selectDeviceId;

  @FindBy(xpath = "(//div[@class='sort-belt-manager-filter']//input)[1]")
  public PageElement hubSelector;

  @FindBy(xpath = "(//div[@class='sort-belt-manager-filter']//input)[2]")
  public PageElement deviceSelector;

  @FindBy(xpath = "//button[.//span[contains(., 'Proceed')]]")
  public AntButton proceed;

  @FindBy(xpath = "//div[./label/span[.='Active Configuration']]")
  public PageElement activeConfiguration;

  @FindBy(xpath = "//div[./label/span[.='Previous Configuration']]")
  public PageElement previousConfiguration;

  @FindBy(xpath = "//div[./label/span[.='Last changed at']]")
  public PageElement lastChangedAt;

  @FindBy(xpath = "//button[.//span[.='Change']]")
  public Button change;

  @FindBy(xpath = "//button[@data-testid='create-logic-button']")
  public Button create;

  @FindBy(xpath = "//li[@data-testid='create-new-menu-item']")
  public PageElement createNew;

  @FindBy(xpath = "//li[@data-testid='create-a-copy-menu-item']")
  public PageElement createCopy;

  @FindBy(xpath = "//input[@placeholder='Search Name or Description']")
  public TextBox searchLogicInput;

  @FindBy(xpath = "//div[@class='ant-modal-header']/div[text()='Create a copy']/parent::div/following-sibling::div//input")
  public TextBox copyLogicInput;

  @FindBy(xpath = "//div[@class='ant-modal-footer']/button[@data-testid='confirm-button']")
  public Button copyLogicConfirm;

  @FindBy(xpath = "//button[.//span[contains(., 'Edit Configuration')]]")
  public Button editConfiguration;

  @FindBy(css = "a[class*='EditButton']")
  public Button editUnassignedParcelsArm;

  @FindBy(xpath = "//button[.//span[.='Confirm']]")
  public Button confirm;

  @FindBy(xpath = "(//input[@class='ant-input'])[1]")
  public TextBox nameInput;

  @FindBy(xpath = "(//input[@class='ant-input'])[2]")
  public TextBox descriptionInput;

  @FindBy(xpath = "//input[@data-testid='logic-name-input']")
  public TextBox logicNameInput;

  @FindBy(xpath = "//input[@data-testid='logic-description-input']")
  public TextBox logicDescriptionInput;

  @FindBy(xpath = "//div[@data-testid='arm-filters-selection']")
  public PageElement logicArmFiltersInput;

  @FindBy(xpath = "//input[@id='unassignedParcelArm']")
  public TextBox logicUnassignedArmInput;

  @FindBy(xpath = "//div[contains(@class,'NoResult')]/span")
  public PageElement noResult;

  @FindBy(xpath = "//label[.='Unassigned Parcel Arm']/following-sibling::span")
  public PageElement unassignedParcelArm;

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(className = "ant-modal-wrap")
  public CreateConfigurationModal createConfigurationModal;

  @FindBy(className = "ant-modal-wrap")
  public ChangeUnassignedParcelArmModal changeUnassignedParcelArmModal;

  @FindBy(className = "ant-modal-wrap")
  public ChangeActiveConfigurationModal changeActiveConfigurationModal;

  @FindBy(xpath = "//button[@data-testid='add-rule-button']")
  public Button addRule;

  @FindBy(xpath = "//button[@data-testid='next-button']")
  public Button nextCreateLogic;

  @FindBy(xpath = "//button[@data-testid='save-button']")
  public Button saveLogic;

  @FindBy(xpath = "//button[@data-testid='close-button']")
  public Button closeLogicDetail;

  @FindBy(xpath = "//button[@data-testid='edit-button']")
  public Button editLogicDetail;

  @FindBy(xpath = "//button[@data-testid='cancel-button']")
  public Button cancelCreateLogic;

  @FindBy(xpath = "//button[@data-testid='activate-button']")
  public Button activateLogic;

  @FindBy(xpath = "//span[@data-testid='leave-text']/parent::button")
  public Button cancelConfirmCreateLogic;

  @FindBy(xpath = "//div[@class='active-logic-name']")
  public PageElement activeLogicNameSummary;

  @FindBy(xpath = "//div[@class='active-logic-desc']")
  public PageElement activeLogicDescSummary;

  @FindBy(xpath = "//span[@class='sub-headers']/span[not(@class)]")
  public PageElement activeLogicArmFiltersSummary;

  @FindBy(xpath = "//div[@class='section-header']//div[contains(@class,'title')]")
  public PageElement logicDetailName;

  @FindBy(xpath = "//div[contains(@class,'logic-description')]")
  public PageElement logicDetailDesc;

  @FindBy(xpath = "//div[@class='ant-row'][2]//div[contains(@class,'logic-details')][2]")
  public PageElement logicDetailArmFilters;

  @FindBy(xpath = "//*[text()='No Data']")
  public PageElement noDataElement;

  public DuplicatedCombinationsTable duplicatedCombinationsTable;
  public UniqueCombinationsTable uniqueCombinationsTable;

  public SortBeltManagerPage(WebDriver webDriver) {
    super(webDriver);
    duplicatedCombinationsTable = new DuplicatedCombinationsTable(webDriver);
    uniqueCombinationsTable = new UniqueCombinationsTable(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void selectHubAndDevice(String hub, String device) {
    hubSelector.waitUntilClickable();
    hubSelector.click();
    hubSelector.sendKeys(hub);
    hubSelector.sendKeys(Keys.ENTER);
    deviceSelector.waitUntilClickable();
    deviceSelector.click();
    deviceSelector.sendKeys(device);
    deviceSelector.sendKeys(Keys.ENTER);
  }

  public void fillLogicBasicInformation(Map<String, String> info, boolean isEdit) {
    String name = info.get("name").equals("GENERATED") ? "AUTO-LOGIC-" + generateAlphaNumericString(
        6).toUpperCase() : info.get("name");
    String description =
        info.get("description").equals("GENERATED") ? "Desc " + generateAlphaNumericString(
            6).toUpperCase() : info.get("description");
    String[] armFilters = info.get("armFilters").split(",");
    String unassignedArm = info.get("unassignedArm");

    // Input name
    logicNameInput.click();
    if (isEdit) {
      emptyInputField(logicNameInput.getWebElement(), true);
    }
    logicNameInput.sendKeys(name);
    pause100ms();
    // Input description
    logicDescriptionInput.click();
    if (isEdit) {
      emptyInputField(logicDescriptionInput.getWebElement(), true);
    }
    logicDescriptionInput.sendKeys(description);
    if (!isEdit) {
      logicArmFiltersInput.click();
      // Loop through given arm filters, and input them
      for (String armFilter : armFilters) {
        logicArmFiltersInput.scrollIntoView(String.format(DROPDOWN_SELECTIONS_XPATH, armFilter));
        waitUntilVisibilityOfElementLocated(String.format(DROPDOWN_SELECTIONS_XPATH, armFilter));
        click(String.format(DROPDOWN_SELECTIONS_XPATH, armFilter));
        pause100ms();
        // Check if a new column appears when selecting filter
        waitUntilVisibilityOfElementLocated(String.format(LOGIC_MAPPING_COLUMN_XPATH, armFilter));
        Assertions.assertThat(isElementExist(String.format(LOGIC_MAPPING_COLUMN_XPATH, armFilter)))
            .as(String.format("Column %s exists", armFilter))
            .isTrue();
        pause100ms();
      }
    }
    // Input unassigned arm
    logicUnassignedArmInput.click();
    if (isEdit) {
      emptyInputField(logicUnassignedArmInput.getWebElement(), false);
    }
    logicUnassignedArmInput.sendKeys(unassignedArm);
    logicUnassignedArmInput.sendKeys(Keys.ENTER);
    pause100ms();
  }

  private void emptyInputField(WebElement filterInput, boolean isText) {
    // Use this function to empty input field
    if (isText) {
      filterInput.sendKeys(Keys.chord(Keys.CONTROL, "a"));
      pause200ms();
      filterInput.sendKeys(Keys.BACK_SPACE);
      if (!filterInput.getAttribute("value").equals("")) {
        filterInput.sendKeys(Keys.chord(Keys.COMMAND, "a"));
        pause200ms();
        filterInput.sendKeys(Keys.BACK_SPACE);
      }
    } else {
      for (int x = 0; x < 5; x++) {
        filterInput.sendKeys(Keys.BACK_SPACE);
        pause200ms();
      }
    }
    pause200ms();
  }

  public void fillLogicRules(List<Map<String, String>> ruleAsList) {
    fillLogicRules(ruleAsList, false);
  }

  public void fillLogicRules(List<Map<String, String>> ruleAsList, boolean isEdit) {
    // Loop through given rules
    webDriver.manage().window().fullscreen();
    for (int i = 0; i < ruleAsList.size(); i++) {
      List<String> keyList = new ArrayList<>(ruleAsList.get(i).keySet());
      // Loop through filters
      for (int j = 0; j < keyList.size(); j++) {

        String columnXpath = String.format(COLUMN_MAPPING_XPATH, i + 1, j + 2);
        doWithRetry(() -> {
          waitUntilElementIsClickable(columnXpath);
          click(columnXpath);
          Assertions.assertThat(isElementExist(columnXpath + "//input")).isTrue();
        }, "Clicking until input field exists", 1000, 5);

        pause1s();
        WebElement filterInput = findElementByXpath(columnXpath + "//input");
        if (isEdit) {
          emptyInputField(filterInput, j == 1);
        }
        List<String> filterValueList = Arrays.asList(
            ruleAsList.get(i).get(keyList.get(j)).split(","));
        // Loop through filter values
        for (int k = 0; k < filterValueList.size(); k++) {
          if (k == 0) {
            filterInput.sendKeys(Keys.BACK_SPACE);
          }
          filterInput.sendKeys(filterValueList.get(k));
          filterInput.sendKeys(Keys.ENTER);
          pause500ms();
          if (j != 1 && k == filterValueList.size() - 1) {
            filterInput.sendKeys(Keys.TAB);
            pause500ms();
            pause200ms();
          }
        }
      }

      // Add new rule if given more than 1
      if (i < ruleAsList.size() - 1) {
        addRule.click();
        pause200ms();
        pause200ms();
      }
    }
  }

  public LogicForm getUpdatedFormState() {
    // Use this function to get updated values of the create/edit logic form
    // Get logic values
    String logicName = findElementByXpath(FORM_LOGIC_NAME_VALUE_XPATH).getAttribute("value");
    String logicDescription = findElementByXpath(FORM_LOGIC_DESCRIPTION_VALUE_XPATH).getAttribute(
        "value");
    Integer logicUnassignedArm = Integer.parseInt(
        findElementByXpath(FORM_LOGIC_UNASSIGNED_ARM_VALUE_XPATH).getText());
    List<String> logicArmFilters = findElementsByXpath(FORM_LOGIC_ARM_FILTERS_VALUE_XPATH).stream()
        .map(
            WebElement::getText).collect(
            Collectors.toList());
    // Get rule values
    List<RuleForm> rules = new ArrayList<>();
    int rulesCount = findElementsByXpath(FORM_RULE_ALL_XPATH).size();
    for (int i = 1; i <= rulesCount; i++) {
      Integer ruleNumber = Integer.parseInt(
          findElementByXpath(String.format(FORM_RULE_NUMBER_VALUE_XPATH, i)).getText());
      List<Integer> ruleArms = Arrays.stream(
              findElementByXpath(String.format(FORM_RULE_ARM_VALUE_XPATH, i)).getText().split(", "))
          .map(
              Integer::parseInt).collect(
              Collectors.toList());
      String ruleDescription = findElementByXpath(
          String.format(FORM_RULE_DESCRIPTION_VALUE_XPATH, i)).getText();
      String ruleShipmentDestination = findElementByXpath(
          String.format(FORM_RULE_SHIPMENT_DESTINATION_VALUE_XPATH, i,
              logicArmFilters.size())).getText();
      String ruleShipmentType = findElementByXpath(
          String.format(FORM_RULE_SHIPMENT_TYPE_VALUE_XPATH, i, logicArmFilters.size())).getText();

      // Get filter values
      FilterForm filterForm = getFilterFromForm(ruleNumber, logicArmFilters);
      RuleForm ruleForm = new RuleForm();
      ruleForm.setRuleNumber(ruleNumber);
      ruleForm.setArms(ruleArms);
      ruleForm.setDescription(ruleDescription);
      ruleForm.setFilter(filterForm);
      ruleForm.setShipmentDestination(ruleShipmentDestination);
      ruleForm.setShipmentType(ruleShipmentType);

      rules.add(ruleForm);
    }

    LogicForm logic = new LogicForm();
    logic.setName(logicName);
    logic.setDescription(logicDescription);
    logic.setUnassignedParcelArm(logicUnassignedArm);
    logic.setArmFilters(logicArmFilters);
    logic.setRules(rules);
    return logic;
  }

  private FilterForm setFilterValueFromForm(FilterForm filterForm, String filterName,
      String value) {
    switch (filterName.toLowerCase()) {
      case "av statuses":
        filterForm.setAvStatuses(value);
        break;
      case "dps":
        filterForm.setDps(Arrays.stream(value.split(", ")).collect(Collectors.toList()));
        break;
      case "destination hubs":
        filterForm.setDestinationHubs(
            Arrays.stream(value.split(", ")).collect(Collectors.toList()));
        break;
      case "granular statuses":
        filterForm.setGranularStatuses(
            Arrays.stream(value.split(", ")).collect(Collectors.toList()));
        break;
      case "marketplace shippers":
        filterForm.setMarketplaceShippers(
            Arrays.stream(value.split(", ")).collect(Collectors.toList()));
        break;
      case "preset":
        filterForm.setPreset(value);
        break;
      case "rts":
        filterForm.setRts(value);
        break;
      case "service levels":
        filterForm.setServiceLevels(Arrays.stream(value.split(", ")).collect(Collectors.toList()));
        break;
      case "shippers":
        filterForm.setShippers(Arrays.stream(value.split(", ")).collect(Collectors.toList()));
        break;
      case "tags":
        filterForm.setTags(Arrays.stream(value.split(", ")).collect(Collectors.toList()));
        break;
      case "zones":
        filterForm.setZones(Arrays.stream(value.split(", ")).collect(Collectors.toList()));
        break;
      case "transaction end in days":
        int days = value.split(" ").length > 1 ? Integer.parseInt(value.split(" ")[1]) : 0;
        filterForm.setTransactionEndInDays(days);
        break;
      default:
        throw new RuntimeException("Undefined filter type.");
    }
    return filterForm;
  }

  private FilterForm getFilterFromForm(int ruleNumber, List<String> logicArmFilters) {
    FilterForm filterForm = new FilterForm();
    for (int i = 0; i < logicArmFilters.size(); i++) {
      String formValue = findElementByXpath(
          String.format(FORM_RULE_FILTERS_VALUE_XPATH, ruleNumber, i + 1)).getText();
      filterForm = setFilterValueFromForm(filterForm, logicArmFilters.get(i), formValue);
    }

    return filterForm;
  }

  public void checkLogicValuesInCheckLogicPage(LogicForm logicForm) {
    String checkName = findElementByXpath(CHECK_LOGIC_NAME_VALUE_XPATH).getText();
    String checkDescription = findElementByXpath(CHECK_LOGIC_DESCRIPTION_VALUE_XPATH).getText()
        .replaceFirst("Description", "");
    String checkArmFilters = findElementByXpath(CHECK_LOGIC_ARM_FILTERS_VALUE_XPATH).getText()
        .replaceFirst("Arm Filters", "");
    String checkUnassignedArm = findElementByXpath(CHECK_LOGIC_UNASSIGNED_ARM_VALUE_XPATH).getText()
        .replaceFirst("Unassigned Parcel Arm", "");
    String checkArmsInUse = findElementByXpath(CHECK_LOGIC_ARMS_IN_USE_COUNT_VALUE_XPATH).getText()
        .replaceFirst("In Use", "")
        .split(" ")[0];
    String checkArmsNotInUse = findElementByXpath(
        CHECK_LOGIC_ARMS_NOT_IN_USE_COUNT_VALUE_XPATH).getText()
        .replaceFirst("No rules attached: ", "")
        .split(" ")[0];
    String checkArmListNotInUse = findElementByXpath(
        CHECK_LOGIC_ARM_LIST_NOT_IN_USE_VALUE_XPATH).getText();

    // Check name
    Assertions.assertThat(checkName)
        .as(String.format("Logic name in check logic is CORRECT: %s", logicForm.getName()))
        .isEqualTo(logicForm.getName());
    // Check description
    Assertions.assertThat(checkDescription)
        .as(String.format("Logic description in check logic is CORRECT: %s",
            logicForm.getDescription()))
        .isEqualTo(logicForm.getDescription());
    // Check Arm filters
    String realCheckArmFilters = Arrays.stream(checkArmFilters.split(", "))
        .collect(Collectors.toList()).stream()
        .filter(f -> !f.equals("Shipment Destination") && !f.equals("Shipment Type"))
        .collect(Collectors.joining(", "));
    String logicArmFilters = String.join(", ", logicForm.getArmFilters());
    Assertions.assertThat(realCheckArmFilters)
        .as(String.format("Logic arm filters in check logic is CORRECT: %s", logicArmFilters))
        .isEqualTo(logicArmFilters);
    // Check Unassigned parcel arm
    Assertions.assertThat(Integer.parseInt(checkUnassignedArm))
        .as(String.format("Logic unassigned arm in check logic is CORRECT: %d",
            logicForm.getUnassignedParcelArm()))
        .isEqualTo(logicForm.getUnassignedParcelArm());
    // Check In use arm count
    List<Integer> logicArmsInUse = logicForm.getArmsInUse();
    int logicArmsInUseCount = logicArmsInUse.size();
    int sbmArmsCount = TestConstants.SORT_BELT_MANAGER_DEVICE_ARMS_COUNT;
    Assertions.assertThat(checkArmsInUse)
        .as(String.format("Logic arms in use in check logic is CORRECT: %d/%d", logicArmsInUseCount,
            sbmArmsCount))
        .isEqualTo(String.format("%d/%d", logicArmsInUseCount, sbmArmsCount));
    // Check no rules attached
    List<Integer> logicArmsNotInUse = logicForm.getArmsNotInUsed();
    int checkArmsNotInUseCount = Integer.parseInt(checkArmsNotInUse);
    int logicArmsNotInUseCount = logicArmsNotInUse.size();
    Assertions.assertThat(checkArmsNotInUseCount)
        .as(String.format("Logic arms not in use in check logic is CORRECT: %d",
            logicArmsNotInUseCount))
        .isEqualTo(logicArmsNotInUseCount);
    // Check arm list with no rules
    String logicArmsNotInUseAsString = logicArmsNotInUse.stream().map(Object::toString).collect(
        Collectors.joining(", "));
    Assertions.assertThat(checkArmListNotInUse)
        .as(String.format("Logic arm list not in use in check logic is CORRECT: %s",
            logicArmsNotInUseAsString))
        .isEqualTo(logicArmsNotInUseAsString);
    // Check whether save button is active
    Assertions.assertThat(saveLogic.isEnabled())
        .as("No error in logic")
        .isTrue();
  }

  public void deleteRulesExceptTheFirstOne() {
    int deleteButtonCount = getElementsCount(DELETE_RULE_XPATH);
    while (true) {
      scrollIntoView(String.format(DELETE_RULE_SPECIFIC_XPATH, deleteButtonCount));
      click(String.format(DELETE_RULE_SPECIFIC_XPATH, deleteButtonCount));
      isElementExist(
          String.format(DELETE_RULE_SPECIFIC_XPATH, deleteButtonCount));
      pause500ms();
      deleteButtonCount = getElementsCount(DELETE_RULE_XPATH);
      if (deleteButtonCount == 0) {
        break;
      }
    }
    Assertions.assertThat(deleteButtonCount)
        .as("Delete button works properly")
        .isZero();
  }

  public boolean checkAllFieldIsPrePopulated() {
    Assertions.assertThat(findElementByXpath(FORM_LOGIC_NAME_VALUE_XPATH).getAttribute("value"))
        .as("Logic name is PRE-POPULATED")
        .isNotEqualTo("");
    Assertions.assertThat(
            findElementByXpath(FORM_LOGIC_DESCRIPTION_VALUE_XPATH).getAttribute("value"))
        .as("Logic description is PRE-POPULATED")
        .isNotEqualTo("");
    Assertions.assertThat(findElementsByXpath(FORM_LOGIC_ARM_FILTERS_VALUE_XPATH).stream()
            .map(WebElement::getText)
            .collect(Collectors.joining(",")))
        .as("Logic arm filters are PRE-POPULATED")
        .isNotEqualTo("");
    Assertions.assertThat(
            findElementByXpath(FORM_LOGIC_UNASSIGNED_ARM_VALUE_XPATH).getAttribute("title"))
        .as("Logic unassigned arm is PRE-POPULATED")
        .isNotEqualTo("");
    for (int i = 1; i <= findElementsByXpath(FORM_RULE_ALL_XPATH).size() - 1; i++) {
      Assertions.assertThat(
              findElementByXpath(String.format(FORM_RULE_ARM_VALUE_XPATH, i)).getText())
          .as(String.format("Rule %d arms are PRE-POPULATED", i))
          .isNotEqualTo("");
      Assertions.assertThat(
              findElementByXpath(String.format(FORM_RULE_DESCRIPTION_VALUE_XPATH, i)).getText())
          .as(String.format("Rule %d description is PRE-POPULATED", i))
          .isNotEqualTo("");
      int j = 1;
      while (isElementExist(String.format(FORM_RULE_FILTERS_VALUE_XPATH, i, j))) {
        Assertions.assertThat(
                findElementByXpath(String.format(FORM_RULE_FILTERS_VALUE_XPATH, i, j)).getText())
            .as(String.format("Rule %d filter %d is PRE-POPULATED", i, j))
            .isNotEqualTo("");
        j++;
      }
    }

    return true;
  }

  public void searchAndSelectALogic(String logicName) {
    searchLogicInput.waitUntilClickable();
    searchLogicInput.click();
    searchLogicInput.sendKeys(logicName);
    waitUntilVisibilityOfElementLocated(String.format(SEARCH_LOGIC_RESULT_XPATH, logicName));
    click(String.format(SEARCH_LOGIC_RESULT_XPATH, logicName));
  }

  public boolean checkIfThereIsNoAvailableArm() {
    logicUnassignedArmInput.click();
    Assertions.assertThat(isElementExist(String.format(DROPDOWN_SELECTIONS_XPATH, "-")))
        .as("Only EMPTY option is available")
        .isTrue();
    Assertions.assertThat(findElementsByXpath(DROPDOWN_SELECTIONS_LIST_XPATH).size())
        .as("Selection is only containing -")
        .isOne();

    // Try to input value
    String columnXpath = String.format(COLUMN_MAPPING_XPATH, 1, 2);
    click(columnXpath);
    pause200ms();
    Assertions.assertThat(noDataElement.isDisplayed())
        .as("Arm list contains No Data")
        .isTrue();

    return true;
  }

  public Map<String, Integer> getMultipleArmsWithTheSameRulesSummary() {
    Map<String, Integer> summary = new HashMap<>();
    String[] pageSummary = findElementByXpath(CHECK_LOGIC_MULTIPLE_ARMS_SUMMARY_XPATH).getText()
        .split(": ")[1]
        .replace("rule(s) across ", "")
        .replace(" arm(s)", "")
        .split(" ");

    summary.put("rules", Integer.parseInt(pageSummary[0]));
    summary.put("arms", Integer.parseInt(pageSummary[1]));

    return summary;
  }

  public Map<String, Integer> getDuplicateRulesSummary() {
    Map<String, Integer> summary = new HashMap<>();
    String[] pageSummary = findElementByXpath(CHECK_LOGIC_DUPLICATE_RULES_SUMMARY_XPATH).getText()
        .split(": ")[1]
        .replace("rule(s) across ", "")
        .replace(" arm(s)", "")
        .split(" ");

    summary.put("rules", Integer.parseInt(pageSummary[0]));
    summary.put("arms", Integer.parseInt(pageSummary[1]));

    return summary;
  }

  public Map<String, Integer> getConflictingRulesSummary() {
    Map<String, Integer> summary = new HashMap<>();
    String[] pageSummary = findElementByXpath(CHECK_LOGIC_CONFLICTING_RULES_SUMMARY_XPATH).getText()
        .split(": ")[1]
        .replace("rule(s) across ", "")
        .replace(" arm(s)", "")
        .split(" ");

    summary.put("rules", Integer.parseInt(pageSummary[0]));
    summary.put("arms", Integer.parseInt(pageSummary[1]));

    return summary;
  }

  public int getUniqueRulesAndArmsSummary() {
    return Integer.parseInt(findElementByXpath(CHECK_LOGIC_UNIQUE_RULES_SUMMARY_XPATH).getText()
        .split(": ")[1]
        .replace(" Results", ""));
  }

  public boolean checkListOfMultipleArmsWithTheSameRules(List<RuleForm> rules) {
    for (RuleForm rule : rules) {
      String row = String.format(
          CHECK_LOGIC_MULTIPLE_ARMS_TABLE_XPATH + "//tr[@data-row-key='%d']/td",
          rule.getRuleNumber() - 1);

      Assertions.assertThat(findElementsByXpath(row).get(1).getText())
          .as(String.format("Arms in rule %d is CORRECT", rule.getRuleNumber()))
          .isEqualTo(
              rule.getArms().stream().map(String::valueOf).collect(Collectors.joining(", ")));
    }

    return true;
  }

  public boolean checkListOfUniqueRulesAndArms(List<RuleForm> rules) {
    for (RuleForm rule : rules) {
      String row = String.format(
          CHECK_LOGIC_UNIQUE_RULES_TABLE_XPATH + "//tr[@data-row-key='%d']/td",
          rule.getRuleNumber() - 1);

      Assertions.assertThat(Integer.parseInt(findElementsByXpath(row).get(1).getText()))
          .as(String.format("Arm in rule %d is CORRECT", rule.getRuleNumber()))
          .isEqualTo(rule.getArms().get(0));
    }

    return true;
  }

  public boolean checkListOfDuplicateRules(List<List<RuleForm>> duplicateRules) {
    for (List<RuleForm> rules : duplicateRules) {
      String row = String.format(
          CHECK_LOGIC_DUPLICATE_RULES_TABLE_XPATH + "//tr[@data-row-key='%d']/td",
          rules.get(0).getRuleNumber() - 1);

      String storedRuleNumbersJoined = rules.stream().map(r -> String.valueOf(r.getRuleNumber()))
          .collect(
              Collectors.joining(", "));
      String storedArmsJoined = rules.get(0).getArms().stream().map(String::valueOf).collect(
          Collectors.joining(", "));
      Assertions.assertThat(findElementsByXpath(row).get(0).getText())
          .as(String.format("Duplicate rules are CORRECT: %s", storedRuleNumbersJoined))
          .isEqualTo(storedRuleNumbersJoined);
      Assertions.assertThat(findElementsByXpath(row).get(1).getText())
          .as(String.format("Arms in rules %s are CORRECT: %s", storedRuleNumbersJoined,
              storedArmsJoined))
          .isEqualTo(storedArmsJoined);
    }

    return true;
  }

  public boolean checkIfMultipleArmsWithTheSameRulesAreCorrect(LogicForm logic) {
    List<RuleForm> rulesWithMultipleArms = logic.getRules().stream()
        .filter(r -> r.getArms().size() > 1).collect(Collectors.toList());
    int rulesWithMultipleArmsCount = rulesWithMultipleArms.size();
    int multipleArmsWithinTheSameRulesCount = logic.getRules().stream()
        .filter(r -> r.getArms().size() > 1)
        .map(r -> r.getArms().size())
        .reduce(0, Integer::sum);
    Map<String, Integer> pageSummary = getMultipleArmsWithTheSameRulesSummary();

    Assertions.assertThat(pageSummary.get("rules"))
        .as(String.format("Rules with multiple arms count is CORRECT: %d",
            rulesWithMultipleArmsCount))
        .isEqualTo(rulesWithMultipleArmsCount);
    Assertions.assertThat(pageSummary.get("arms"))
        .as(String.format("Multiple arms within the same rules count is CORRECT: %d",
            multipleArmsWithinTheSameRulesCount))
        .isEqualTo(multipleArmsWithinTheSameRulesCount);
    Assertions.assertThat(checkListOfMultipleArmsWithTheSameRules(rulesWithMultipleArms))
        .as(String.format("List of rules with multiple arms is CORRECT: %s",
            rulesWithMultipleArms.stream()
                .map(r -> String.valueOf(r.getRuleNumber()))
                .collect(Collectors.joining(", "))))
        .isTrue();

    return true;
  }

  public boolean checkIfUniqueRulesAndArmsAreCorrect(LogicForm logic) {
    List<RuleForm> uniqueRulesAndArms = logic.getRules().stream()
        .filter(r -> r.getArms().size() == 1).collect(Collectors.toList());
    int uniqueRulesAndArmsCount = uniqueRulesAndArms.size();
    int pageSummary = getUniqueRulesAndArmsSummary();

    Assertions.assertThat(pageSummary)
        .as(String.format("Unique rules and arms count is CORRECT: %d", uniqueRulesAndArmsCount))
        .isEqualTo(uniqueRulesAndArmsCount);
    Assertions.assertThat(checkListOfUniqueRulesAndArms(uniqueRulesAndArms))
        .as(String.format("List of rules with multiple arms is CORRECT: %s",
            uniqueRulesAndArms.stream()
                .map(r -> String.valueOf(r.getRuleNumber()))
                .collect(Collectors.joining(", "))))
        .isTrue();

    return true;
  }

  public boolean checkIfDuplicateRulesAreCorrect(LogicForm logic) {
    List<List<RuleForm>> listOfDuplicateRules = new ArrayList<>();
    List<RuleForm> rules = logic.getRules();
    int armsSummaryCount = 0;

    for (int i = 0; i < rules.size(); i++) {
      // If rule is already added to duplicate list, then skip
      int idx = i;
      if (listOfDuplicateRules.stream()
          .anyMatch(r -> r.contains(rules.get(idx)))) {
        continue;
      }

      // Loop through each rule
      FilterForm filter1 = rules.get(i).getFilter();
      List<RuleForm> listOfRules = new ArrayList<>();
      listOfRules.add(rules.get(i));
      for (int j = i + 1; j < rules.size(); j++) {
        FilterForm filter2 = rules.get(j).getFilter();
        if (
            filter1.getGranularStatuses().equals(filter2.getGranularStatuses()) &&
                filter1.getRts().equals(filter2.getRts()) &&
                filter1.getServiceLevels().equals(filter2.getServiceLevels()) &&
                filter1.getTags().equals(filter2.getTags())
        ) {
          listOfRules.add(rules.get(j));
        }
      }

      // If there are duplicates, add to listOfDuplicateRules
      if (listOfRules.size() > 1) {
        listOfDuplicateRules.add(listOfRules);
        armsSummaryCount += rules.get(i).getArms().size();
      }
    }

    int rulesSummaryCount = listOfDuplicateRules.stream()
        .map(List::size)
        .reduce(0, Integer::sum);

    // Assert summaries
    Map<String, Integer> rulesSummary = getDuplicateRulesSummary();
    Assertions.assertThat(rulesSummary.get("rules"))
        .as(String.format("Duplicate rules count is CORRECT: %d", rulesSummaryCount))
        .isEqualTo(rulesSummaryCount);
    Assertions.assertThat(rulesSummary.get("arms"))
        .as(String.format("Duplicate rules' arms count is CORRECT: %d", armsSummaryCount))
        .isEqualTo(armsSummaryCount);

    // Assert rule list
    Assertions.assertThat(checkListOfDuplicateRules(listOfDuplicateRules))
        .as("List of duplicate rules are CORRECT")
        .isTrue();

    return true;
  }

  public boolean checkIfConflictingShipmentRulesAreCorrect(LogicForm logic) {
    List<List<RuleForm>> listOfConflictingRules = new ArrayList<>();
    List<RuleForm> rules = logic.getRules();

    for (int i = 0; i < rules.size(); i++) {
      // If rule is already added to conflicting rule list, then skip
      int idx = i;
      if (listOfConflictingRules.stream()
          .anyMatch(r -> r.contains(rules.get(idx)))) {
        continue;
      }

      // Loop through each rule
      List<RuleForm> listOfRules = new ArrayList<>();
      listOfRules.add(rules.get(i));
      for (int j = i + 1; j < rules.size(); j++) {
        if (
            rules.get(i).getArms().equals(rules.get(j).getArms()) &&
                (!rules.get(i).getShipmentDestination()
                    .equals(rules.get(j).getShipmentDestination()) ||
                    !rules.get(i).getShipmentType().equals(rules.get(j).getShipmentType())
                )
        ) {
          listOfRules.add(rules.get(j));
        }
      }

      // If there are conflicting rules, add to listOfConflictingRules
      if (listOfRules.size() > 1) {
        listOfConflictingRules.add(listOfRules);
      }
    }

    int rulesSummaryCount = listOfConflictingRules.stream()
        .map(List::size)
        .reduce(0, Integer::sum);

    Map<String, Integer> rulesSummary = getConflictingRulesSummary();
    Assertions.assertThat(rulesSummary.get("rules"))
        .as(String.format("Duplicate rules count is CORRECT: %d", rulesSummaryCount))
        .isEqualTo(rulesSummaryCount);

    return true;
  }

  public Map<String, String> getLogicDetailFromPage() {
    String name = logicDetailName.getText();
    String desc = logicDetailDesc.getText().replace("Description", "");
    String armFilters = logicDetailArmFilters.getText().replace("Arm Filters", "");

    Map<String, String> logicDetails = new HashMap<>();
    logicDetails.put("name", name);
    logicDetails.put("desc", desc);
    logicDetails.put("armFilters", armFilters);

    return logicDetails;
  }

  /* =================================================================================== */
  /* ====================================== SBMv1 ====================================== */
  /* =================================================================================== */

  public String getActiveConfiguration() {
    return StringUtils
        .normalizeSpace(activeConfiguration.getText().replace("Active Configuration", ""));
  }

  public String getPreviousConfiguration() {
    return StringUtils
        .normalizeSpace(previousConfiguration.getText().replace("Previous Configuration", ""));
  }

  public String getLastChangedAt() {
    return StringUtils
        .normalizeSpace(lastChangedAt.getText().replace("Last changed at", ""));
  }

  public void verifyConfigNotCreated(String configName) {
    create.waitUntilClickable();
    selectHub.waitUntilClickable();
    selectHub.jsClick();
    pause1s();

    selectHub.searchInput.sendKeys(configName);
    Assertions.assertThat(noResult.getText()).as("Check result")
        .isEqualToIgnoringCase("No Results Found");
  }

  public ArmCombinationContainer getArmCombinationContainer(String armName) {
    int index = Integer.parseInt(armName.replaceAll(".*Arm\\s*", ""));
    WebElement we = findElementByXpath(f(ARM_LIST_XPATH, index));
    return new ArmCombinationContainer(webDriver, we);
  }

  public static class ArmCombinationContainer extends PageElement {

    @FindBy(xpath = ".//button[i[contains(@class, 'anticon-plus')]]")
    public Button addCombination;

    @FindBy(css = "button[class*='ArmSwitch']")
    public MdSwitch enable;

    @FindBy(css = "div.ant-select")
    public VirtualSelect sameAs;

    public ArmCombinationContainer(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    public void removeSameAs(String armName) {
      String xpath = f(".//li[contains(@class,'ant-select-selection__choice')][.//div[.='%s']]//i",
          armName.replaceAll("Arm ", ""));
      new Button(getWebDriver(), getWebElement(), xpath).click();
    }

    public int getCombinationsCount() {
      return getElementsCountFast(By.cssSelector("div[class*='StyledRow']"));
    }

    public Button getRemoveButton(int index) {
      String xpath = f("(.//button[i[contains(@class, 'anticon-close')]])[%d]", index);
      return new Button(getWebDriver(), getWebElement(), xpath);
    }

    public VirtualSelect getFilterSelect(String filterName, int index) {
      String xpath = f(
          "(.//div[contains(@class,'MultipleSelectFilterContainer')][.//span[.='%s']])[%d]",
          filterName, index);
      return new VirtualSelect(getWebDriver(), getWebElement(), xpath, true);
    }
  }

  public static class DuplicatedCombinationsTable extends AntTable<ArmCombination> {

    public DuplicatedCombinationsTable(WebDriver webDriver) {
      super(webDriver);
      setTableLocator("//div[contains(@class,'duplicate-info-holder ')]");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("armOutput", "armOutputDisplay")
          .put("destinationHub", "destinationHubDisplay")
          .put("orderTag", "orderTagDisplay")
          .build()
      );
      setEntityClass(ArmCombination.class);
    }
  }

  public static class UniqueCombinationsTable extends AntTable<ArmCombination> {

    public UniqueCombinationsTable(WebDriver webDriver) {
      super(webDriver);
      setTableLocator("//div[contains(@class,'unique-info-holder')]");
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("armOutput", "armOutputDisplay")
          .put("destinationHub", "destinationHubDisplay")
          .put("orderTag", "orderTagDisplay")
          .build()
      );
      setEntityClass(ArmCombination.class);
    }
  }

  public static class CreateConfigurationModal extends AntModal {

    public CreateConfigurationModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[1]")
    public VirtualSelect firstFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[2]")
    public VirtualSelect secondFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[3]")
    public VirtualSelect thirdFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[4]")
    public VirtualSelect unassignedParcelArm;

    @FindBy(xpath = ".//button[.//span[contains(., 'Confirm')]]")
    public AntButton confirm;
  }

  public static class ChangeUnassignedParcelArmModal extends AntModal {

    public ChangeUnassignedParcelArmModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[1]")
    public VirtualSelect unassignedParcelArm;

    @FindBy(xpath = ".//button[.//span[contains(., 'Confirm')]]")
    public AntButton confirm;

    @FindBy(css = "div.note")
    public PageElement note;

    public String getFilterValue(String filterName) {
      return findElement(By.xpath(f("//tr[.//td[contains(.,'%s')]]//td[2]", filterName))).getText();
    }
  }

  public static class ChangeActiveConfigurationModal extends AntModal {

    public ChangeActiveConfigurationModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
    }

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-enabled')])[1]")
    public VirtualSelect configuration;

    @FindBy(xpath = ".//button[.//span[contains(., 'Confirm')]]")
    public AntButton confirm;
  }
}