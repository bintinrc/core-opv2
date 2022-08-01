package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.hub.Shipments;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commons.util.StandardTestUtils;
import co.nvqa.operator_v2.model.MovementEvent;
import co.nvqa.operator_v2.model.ShipmentEvent;
import co.nvqa.operator_v2.model.ShipmentInfo;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.assertj.core.api.SoftAssertions;
import org.assertj.core.util.Strings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.ACTION_CANCEL;
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.NewShipmentManagementPage.ShipmentsTable.COLUMN_SHIPMENT_ID;
import static co.nvqa.operator_v2.util.TestConstants.COUNTRY_CODE;
import static co.nvqa.operator_v2.util.TestConstants.OPERATOR_PORTAL_BASE_URL;

/**
 * Modified by Daniel Joi Partogi Hutapea. Modified by Sergey Mishanin.
 *
 * @author Lanang Jati
 */
@SuppressWarnings("WeakerAccess")
@ScenarioScoped
public class NewShipmentManagementSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(NewShipmentManagementSteps.class);

  private NewShipmentManagementPage page;
  public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS = "KEY_SHIPMENT_MANAGEMENT_FILTERS";
  public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID = "KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID";
  public static final String KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME = "KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME";

  public NewShipmentManagementSteps() {
  }

  @Override
  public void init() {
    page = new NewShipmentManagementPage(getWebDriver());
  }

  @When("^Operator click \"Load All Selection\" on Shipment Management page$")
  public void listAllShipment() {
    page.inFrame(() -> {
      page.loadSelection.click();
      pause5s();
    });
  }

  @When("Operator apply filters on Shipment Management Page:")
  public void operatorFilerWithData(Map<String, String> mapOfData) {
    Map<String, String> data = resolveKeyValues(mapOfData);
    page.inFrame(() -> {
      page.waitUntilLoaded(1);
      if (data.containsKey("shipmentStatus")) {
        page.shipmentStatusFilter.clearAll();
        page.shipmentStatusFilter.selectFilter(splitAndNormalize(data.get("shipmentStatus")));
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "Shipment Status", data.get("shipmentStatus"));
      }
      if (data.containsKey("shipmentDate")) {
        List<String> values = splitAndNormalize(data.get("shipmentDate"));
        String[] fromValues = values.get(0).split(":");
        page.shipmentDateFilter.setFromDate(fromValues[0].trim());
        page.shipmentDateFilter.setFromHours(fromValues[1].trim());
        page.shipmentDateFilter.setFromMinutes(fromValues[2].trim());
        String[] toValues = values.get(1).split(":");
        page.shipmentDateFilter.setToDate(toValues[0].trim());
        page.shipmentDateFilter.setToHours(toValues[1].trim());
        page.shipmentDateFilter.setToMinutes(toValues[2].trim());
      }
      if (data.containsKey("shipmentCompletionDate")) {
        if (!page.shipmentCompletionDateFilter.isDisplayedFast()) {
          page.AddFilterWithValue("Shipment Completion Date");
        }
        List<String> values = splitAndNormalize(data.get("shipmentCompletionDate"));
        String[] fromValues = values.get(0).split(":");
        page.shipmentCompletionDateFilter.setFromDate(fromValues[0].trim());
        page.shipmentCompletionDateFilter.setFromHours(fromValues[1].trim());
        page.shipmentCompletionDateFilter.setFromMinutes(fromValues[2].trim());
        String[] toValues = values.get(1).split(":");
        page.shipmentCompletionDateFilter.setToDate(toValues[0].trim());
        page.shipmentCompletionDateFilter.setToHours(toValues[1].trim());
        page.shipmentCompletionDateFilter.setToMinutes(toValues[2].trim());
      }
      if (data.containsKey("transitDateTime")) {
        if (!page.transitDateTimeFilter.isDisplayedFast()) {
          page.AddFilterWithValue("Transit Date Time");
        }
        List<String> values = splitAndNormalize(data.get("transitDateTime"));
        String[] fromValues = values.get(0).split(":");
        page.transitDateTimeFilter.setFromDate(fromValues[0].trim());
        page.transitDateTimeFilter.setFromHours(fromValues[1].trim());
        page.transitDateTimeFilter.setFromMinutes(fromValues[2].trim());
        String[] toValues = values.get(1).split(":");
        page.transitDateTimeFilter.setToDate(toValues[0].trim());
        page.transitDateTimeFilter.setToHours(toValues[1].trim());
        page.transitDateTimeFilter.setToMinutes(toValues[2].trim());
      }
      if (data.containsKey("shipmentType")) {
        page.shipmentTypeFilter.clearAll();
        page.shipmentTypeFilter.selectFilter(splitAndNormalize(data.get("shipmentType")));
      }
      if (data.containsKey("originHub")) {
        if (!page.originHubFilter.isDisplayedFast()) {
          page.AddFilterWithValue("Origin Hub");
        } else {
          page.originHubFilter.clearAll();
        }
        page.originHubFilter.selectFilter(splitAndNormalize(data.get("originHub")));
      }
      if (data.containsKey("destinationHub")) {
        if (!page.destinationHubFilter.isDisplayedFast()) {
          page.AddFilterWithValue("Destination Hub");
        } else {
          page.destinationHubFilter.clearAll();
        }
        page.destinationHubFilter.selectFilter(splitAndNormalize(data.get("destinationHub")));
      }
      if (data.containsKey("lastInboundHub")) {
        if (!page.lastInboundHubFilter.isDisplayedFast()) {
          page.AddFilterWithValue("Last Inbound Hub");
        } else {
          page.lastInboundHubFilter.clearAll();
        }

        page.lastInboundHubFilter.selectFilter(splitAndNormalize(data.get("lastInboundHub")));
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "Last Inbound Hub", data.get("lastInboundHub"));
      }
      if (data.containsKey("mawb")) {
        if (!page.mawbFilter.isDisplayedFast()) {
          page.AddFilterWithValue("MAWB");
        } else {
          page.mawbFilter.clearAll();
        }
        page.mawbFilter.selectFilter(splitAndNormalize(data.get("mawb")));
      }
    });
  }

  @When("Operator search shipments by given Ids on Shipment Management page:")
  public void fillSearchShipmentsByIds(List<String> ids) {
    enterShipmentIds(ids);
    clickSearchByShipmentId();
  }

  @When("Operator click Search by shipment id on Shipment Management page")
  public void clickSearchByShipmentId() {
    page.inFrame(() -> {
      page.searchByShipmentIds.waitUntilClickable();
      page.searchByShipmentIds.click();
    });
  }

  @When("Operator enters shipment ids on Shipment Management page:")
  public void enterShipmentIds(List<String> ids) {
    String shipmentIds = Strings.join(resolveValues(ids)).with("\n");
    page.inFrame(() -> {
      page.shipmentIds.waitUntilVisible();
      page.shipmentIds.setValue(shipmentIds);
    }
    );
  }

  @When("Operator enters next shipment ids on Shipment Management page:")
  public void enterNextShipmentIds(List<String> ids) {
    String shipmentIds = Strings.join(resolveValues(ids)).with("\n");
    page.inFrame(() -> page.shipmentIds.sendKeys("\n" + shipmentIds));
  }

  @Given("Operator click Edit filter on Shipment Management page")
  public void operatorClickEditFilterOnShipmentManagementPage() {
    page.inFrame(() -> page.editFilters.click());
  }

  @When("^Operator clear all filters on Shipment Management page$")
  public void operatorClearAllFiltersOnShipmentManagementPage() {
    page.inFrame(() -> page.clearAllFilters.click());
  }

  @When("^Operator create Shipment on Shipment Management page:$")
  public void operatorCreateShipmentOnShipmentManagementPageUsingDataBelow(
      Map<String, String> mapOfData) {
    retryIfRuntimeExceptionOccurred(() -> {
      page.inFrame(page -> {
        page.waitUntilLoaded();
        try {
          final Map<String, String> finalData = resolveKeyValues(mapOfData);
          List<Order> listOfOrders;
          boolean isNextOrder = false;

          if (get("isNextOrder") != null) {
            isNextOrder = get("isNextOrder");
          }

          if (containsKey(KEY_LIST_OF_CREATED_ORDER)) {
            listOfOrders = get(KEY_LIST_OF_CREATED_ORDER);
          } else if (containsKey(KEY_CREATED_ORDER)) {
            listOfOrders = Arrays.asList(get(KEY_CREATED_ORDER));
          } else {
            listOfOrders = new ArrayList<>();
          }

          ShipmentInfo shipmentInfo = new ShipmentInfo();
          shipmentInfo.fromMap(finalData);
          shipmentInfo.setOrdersCount((long) listOfOrders.size());

          page.createShipment(shipmentInfo, isNextOrder);

          if (StringUtils.isBlank(shipmentInfo.getShipmentType())) {
            shipmentInfo.setShipmentType("AIR_HAUL");
          }

          put(KEY_SHIPMENT_INFO, shipmentInfo);
          put(KEY_CREATED_SHIPMENT, shipmentInfo);
          put(KEY_CREATED_SHIPMENT_ID, shipmentInfo.getId());
          putInList(KEY_LIST_OF_CREATED_SHIPMENT_ID,shipmentInfo.getId());

          if (isNextOrder) {
            Long secondShipmentId = page.createAnotherShipment();
            shipmentInfo.setId(secondShipmentId);
            Long shipmentIdBefore = get(KEY_CREATED_SHIPMENT_ID);
            List<Long> listOfShipmentId = new ArrayList<>();
            listOfShipmentId.add(shipmentIdBefore);
            listOfShipmentId.add(secondShipmentId);
            page.createShipmentDialog.close();
            page.createShipmentDialog.waitUntilInvisible();
            put(KEY_LIST_OF_CREATED_SHIPMENT_ID, listOfShipmentId);
          }
        } catch (Throwable ex) {
          LOGGER.debug("Searched element is not found, retrying after 2 seconds...");
          page.refreshPage();
          throw new NvTestRuntimeException(ex);
        }
      });
    }, 1);
  }

  @When("^Operator create Shipment without confirm on Shipment Management page:$")
  public void operatorCreateShipmentOnShipmentManagementPageWithoutConfirmUsingDataBelow(
          Map<String, String> mapOfData) {
    page.inFrame(page -> {
      page.waitUntilLoaded();
      try {
        final Map<String, String> finalData = resolveKeyValues(mapOfData);
        List<Order> listOfOrders;
        boolean isNextOrder = false;

        if (get("isNextOrder") != null) {
          isNextOrder = get("isNextOrder");
        }

        if (containsKey(KEY_LIST_OF_CREATED_ORDER)) {
          listOfOrders = get(KEY_LIST_OF_CREATED_ORDER);
        } else if (containsKey(KEY_CREATED_ORDER)) {
          listOfOrders = Arrays.asList(get(KEY_CREATED_ORDER));
        } else {
          listOfOrders = new ArrayList<>();
        }

        ShipmentInfo shipmentInfo = new ShipmentInfo();
        shipmentInfo.fromMap(finalData);
        shipmentInfo.setOrdersCount((long) listOfOrders.size());

        page.createShipmentWithoutConfirm(shipmentInfo, isNextOrder);

        if (StringUtils.isBlank(shipmentInfo.getShipmentType())) {
          shipmentInfo.setShipmentType("AIR_HAUL");
        }

        put(KEY_SHIPMENT_INFO, shipmentInfo);
        put(KEY_CREATED_SHIPMENT, shipmentInfo);
        put(KEY_CREATED_SHIPMENT_ID, shipmentInfo.getId());
        putInList(KEY_LIST_OF_CREATED_SHIPMENT_ID,shipmentInfo.getId());

        if (isNextOrder) {
          Long secondShipmentId = page.createAnotherShipment();
          shipmentInfo.setId(secondShipmentId);
          Long shipmentIdBefore = get(KEY_CREATED_SHIPMENT_ID);
          List<Long> listOfShipmentId = new ArrayList<>();
          listOfShipmentId.add(shipmentIdBefore);
          listOfShipmentId.add(secondShipmentId);
          page.createShipmentDialog.close();
          page.createShipmentDialog.waitUntilInvisible();
          put(KEY_LIST_OF_CREATED_SHIPMENT_ID, listOfShipmentId);
        }
      } catch (Throwable ex) {
        LOGGER.debug("Searched element is not found, retrying after 2 seconds...");
        page.refreshPage();
        throw new NvTestRuntimeException(ex);
      }
    });
  }

  @When("Operator edit Shipment on Shipment Management page:")
  public void operatorEditShipment(Map<String, String> data) {
    Map<String, String> resolvedData = resolveKeyValues(data);
    String shipmentId = resolvedData.get("shipmentId");
    page.inFrame(() -> {
      page.shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, shipmentId);
      page.shipmentsTable.clickActionButton(1, ACTION_EDIT);
      page.editShipmentDialog.waitUntilVisible();
      if (resolvedData.containsKey("origHubName")) {
        page.editShipmentDialog.startHub.selectValue(resolvedData.get("origHubName"));
      }
      if (resolvedData.containsKey("destHubName")) {
        page.editShipmentDialog.endHub.selectValue(resolvedData.get("destHubName"));
      }
      if (resolvedData.containsKey("shipmentType")) {
        page.editShipmentDialog.type.selectValue(resolvedData.get("shipmentType"));
      }
      if (resolvedData.containsKey("comments")) {
        page.editShipmentDialog.comments.setValue(resolvedData.get("comments"));
      }
      page.editShipmentDialog.saveChanges.click();
    });
  }

  @Then("^Operator verify parameters of shipment on Shipment Management page:$")
  public void operatorVerifyParametersShipmentOnShipmentManagementPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    data = StandardTestUtils.replaceDataTableTokens(data);
    ShipmentInfo shipmentInfo = new ShipmentInfo();
    shipmentInfo.fromMap(data);
    page.inFrame(() -> page.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo));
  }

  @Then("^Operator verify search results contains exactly shipments on Shipment Management page:$")
  public void operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(
      List<String> shipmentIds) {
    page.inFrame(() -> {
      List<String> actual = page.shipmentsTable.readColumn(COLUMN_SHIPMENT_ID);
      Assertions.assertThat(actual).as("List of Shipment IDs")
          .containsExactlyInAnyOrderElementsOf(resolveValues(shipmentIds));
    });
  }

  @And("^Operator open the shipment detail for the created shipment on Shipment Management Page$")
  public void operatorOpenShipmentDetailsPageForCreatedShipmentOnShipmentManagementPage() {
    ShipmentInfo shipmentInfo;

    if (get(KEY_SHIPMENT_INFO) == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    } else {
      shipmentInfo = get(KEY_SHIPMENT_INFO);
    }
    put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
    page.inFrame(() -> page.openShipmentDetailsPage(shipmentInfo.getId()));
  }

  @And("Operator open the shipment detail for the shipment {string} on Shipment Management Page")
  public void operatorOpenShipmentDetailOnShipmentManagementPage(String shipmentIdAsString) {
    Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
    page.inFrame(() -> page.openShipmentDetailsPage(shipmentId));
  }

  @And("^Operator cancel the created shipment on Shipment Management page$")
  public void operatorCancelTheCreatedShipmentOnShipmentManagementPage() {
    Long shipmentId;
    if (containsKey(KEY_CREATED_SHIPMENT_ID)) {
      shipmentId = get(KEY_CREATED_SHIPMENT_ID);
    } else {
      ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
      shipmentId = shipmentInfo.getId();
    }
    Long finalShipmentId = shipmentId;
    page.inFrame(() -> page.cancelShipment(finalShipmentId));
  }

  @When("Operator edits and verifies that the cancelled shipment cannot be edited")
  public void operatorEditsAndVerifiesThatTheCancelledShipmentCannotBeEdited() {
    page.inFrame(() -> page.editCancelledShipment());
  }

  @And("^Operator verify the Shipment Details Page opened is for the created shipment$")
  public void operatorVerifyShipmentDetailsPageOpenedIsForTheCreatedShipment() {
    Order order = get(KEY_CREATED_ORDER);
    ShipmentInfo shipmentInfo;

    if (get(KEY_SHIPMENT_INFO) == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    } else {
      shipmentInfo = get(KEY_SHIPMENT_INFO);
    }
    page.switchTo();
    page.verifyOpenedShipmentDetailsPageIsTrue(shipmentInfo.getId(), order.getTrackingId());
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
  }

  @Then("^Operator verify shipment event on Shipment Details page:$")
  public void operatorVerifyShipmentEventOnEditOrderPage(Map<String, String> data) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> page.inFrame(() -> {
      try {
        ShipmentEvent expectedEvent = new ShipmentEvent(resolveKeyValues(data));
        page.shipmentEventsTable.readAllEntities().stream()
            .filter(expectedEvent::matchedTo)
            .findFirst().orElseThrow(
                () -> new AssertionError("Shipment Event was not found:\n" + expectedEvent));
      } catch (Throwable ex) {
        LOGGER.error(ex.getLocalizedMessage(), ex);
        page.refreshPage();
        throw ex;
      }
    }), "retry shipment details", 1000, 3);
  }

  @Then("Operator opens Shipment Details page for shipment {value}")
  public void openShipmentDetailsPage(String shipmentId) {
    navigateTo(
        f("%s/%s/new-shipment-details/%s", OPERATOR_PORTAL_BASE_URL, COUNTRY_CODE, shipmentId));
    page.inFrame(() -> page.waitUntilLoaded());
    pause3s();
  }

  @Then("Operator verify movement event on Shipment Details page:")
  public void operatorVerifyMovementEventOnEditOrderPage(Map<String, String> mapOfData) {
    retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> page.inFrame(() -> {
      MovementEvent expectedEvent = new MovementEvent(resolveKeyValues(mapOfData));
      try {
        page.movementEventsTable.readAllEntities().stream()
            .filter(expectedEvent::matchedTo)
            .findFirst()
            .orElseThrow(
                () -> new AssertionError("Movement Event was not found:\n" + expectedEvent));
      } catch (Throwable ex) {
        LOGGER.error(ex.getLocalizedMessage(), ex);
        page.refreshPage();
        throw ex;
      }
    }), "retry shipment details", 1000, 3);
  }

  @And("^Operator save current filters as preset on Shipment Management page$")
  public void operatorSaveCurrentFiltersAsPresetWithNameOnShipmentManagementPage() {
    String presetName = "Test" + TestUtils.generateDateUniqueString();
    page.inFrame(() -> {
      page.waitUntilLoaded(2);
      page.presetActionsMenu.selectOption("Save Current As Preset");
      page.savePresetDialog.waitUntilVisible();
      page.savePresetDialog.name.setValue(presetName);
      page.savePresetDialog.save.click();
      page.waitUntilVisibilityOfToastReact("1 preset filter created");
      String presetId = page.selectFiltersPreset.getValue();
      Pattern p = Pattern.compile("(\\d+) (-) (.+)");
      Matcher m = p.matcher(presetId);
      if (m.matches()) {
        presetId = m.group(1);
        assertThat("created preset is selected", m.group(3), equalTo(presetName));
      }
      put(KEY_SHIPMENTS_FILTERS_PRESET_ID, presetId);
      put(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID, presetId);
      put(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME, presetName);
    });
  }

  @And("^Operator select created filters preset on Shipment Management page$")
  public void operatorSelectCreatedFiltersPresetOnShipmentManagementPage() {
    String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + " - " + get(
        KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
    operatorSelectGivenFiltersPresetOnShipmentManagementPage(presetName);
  }

  @And("Operator select {value} filters preset on Shipment Management page")
  public void operatorSelectGivenFiltersPresetOnShipmentManagementPage(String filterPresetName) {
    page.inFrame(() -> page.selectFiltersPreset.selectValue(filterPresetName));
  }

  @And("Operator verify selected filters on Shipment Management page:")
  public void verifySelectedFilters(Map<String, String> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      if (data.containsKey("shipmentStatus")) {
        List<String> actual = page.shipmentStatusFilter.getSelectedValues();
        assertions.assertThat(actual).as("Shipment Status")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipmentStatus")));
      }
      if (data.containsKey("shipmentType")) {
        List<String> actual = page.shipmentTypeFilter.getSelectedValues();
        assertions.assertThat(actual).as("Shipment Type")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipmentType")));
      }
      if (data.containsKey("originHub")) {
        if (!page.originHubFilter.isDisplayedFast()) {
          assertions.fail("Origin Hub filter is not displayed");
        } else {
          List<String> actual = page.originHubFilter.getSelectedValues();
          assertions.assertThat(actual).as("Origin Hub")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("originHub")));
        }
      }
      if (data.containsKey("destinationHub")) {
        if (!page.destinationHubFilter.isDisplayedFast()) {
          assertions.fail("Destination Hub filter is not displayed");
        } else {
          List<String> actual = page.destinationHubFilter.getSelectedValues();
          assertions.assertThat(actual).as("Destination Hub")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("destinationHub")));
        }
      }
      if (data.containsKey("lastInboundHub")) {
        if (!page.lastInboundHubFilter.isDisplayedFast()) {
          assertions.fail("Last Inbound Hub filter is not displayed");
        } else {
          List<String> actual = page.lastInboundHubFilter.getSelectedValues();
          assertions.assertThat(actual).as("Last Inbound Hub")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("lastInboundHub")));
        }
      }
    });
    assertions.assertAll();
  }

  @And("^Operator delete created filters preset on Shipment Management page$")
  public void operatorDeleteCreatedFiltersPresetOnShipmentManagementPage() {
    String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + " - " + get(
        KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
    page.inFrame(() -> {
      page.presetActionsMenu.selectOption("Delete Preset");
      page.deletePresetDialog.waitUntilVisible();
      page.deletePresetDialog.name.selectValue(presetName);
      page.deletePresetDialog.delete.click();
      page.waitUntilVisibilityOfToastReact("1 preset filter deleted");
    });
  }

  @Then("^Operator verify filters preset was deleted$")
  public void operatorVerifyFiltersPresetWasDeleted() {
    String presetName = get(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID) + " - " + get(
        KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_NAME);
    page.inFrame(() -> {
      List<String> presets = page.selectFiltersPreset.getValues();
      if (!presets.isEmpty()) {
        Assertions.assertThat(presets).as("Available filters presets").doesNotContain(presetName);
      }
    });
    remove(KEY_SHIPMENTS_FILTERS_PRESET_ID);
    remove(KEY_SHIPMENT_MANAGEMENT_FILTERS_PRESET_ID);
  }

  @Given("Operator intends to create a new Shipment directly from the Shipment Toast")
  public void operatorIntendsToCreateANewShipmentDirectlyFromTheShipmentToast() {
    boolean isNextOrder = true;
    put("isNextOrder", isNextOrder);
  }

  @And("^Operator create CSV \"([^\"]*)\" file which has multiple valid Tracking ID in it and upload the CSV$")
  public void createAndUploadCsvMultipleTrackingId(String fileName) throws FileNotFoundException {
    List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    }
    int numberOfOrder = orders.size();
    ShipmentInfo finalShipmentInfo = shipmentInfo;
    page.inFrame(() -> {
      try {
        page.createAndUploadCsv(orders, fileName, numberOfOrder, finalShipmentInfo);
      } catch (FileNotFoundException e) {
        throw new RuntimeException(e);
      }
    });
  }

  @And("^Operator create CSV \"([^\"]*)\" file which has duplicated Tracking ID in it and upload the CSV$")
  public void createAndUploadCsvDuplicatedTrackingId(String fileName) throws FileNotFoundException {
    List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    }
    int numberOfOrder = orders.size();
    ShipmentInfo finalShipmentInfo = shipmentInfo;
    page.inFrame(() -> {
      try {
        page.createAndUploadCsv(orders, fileName, true, true, numberOfOrder, finalShipmentInfo);
      } catch (FileNotFoundException e) {
        throw new RuntimeException(e);
      }
    });
  }

  @And("^Operator create CSV \"([^\"]*)\" file which has invalid Tracking ID in it and upload the CSV$")
  public void createAndUploadCsvInvalidTrackingId(String fileName) throws FileNotFoundException {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    }
    ShipmentInfo finalShipmentInfo = shipmentInfo;
    page.inFrame(() -> {
      try {
        page.createAndUploadCsv(fileName, finalShipmentInfo);
      } catch (FileNotFoundException e) {
        throw new RuntimeException(e);
      }
    });
  }

  @When("Operator clicks on reopen shipment button under the Apply Action")
  public void operatorClicksOnReopenShipmentButtonUnderTheApplyAction() {
    page.inFrame(() -> {
      page.shipmentsTable.selectRow(1);
      page.actionsMenu.selectOption("Reopen Shipments");
    });
  }

  @When("Operator clicks on reopen shipment button under the Apply Action for multiple shipments")
  public void operatorClicksOnReopenShipmentButtonUnderTheApplyActionForMultipleShipments() {
    page.inFrame(() -> {
      page.tableActionsMenu.selectOption("Select All Shown");
      page.actionsMenu.selectOption("Reopen Shipments");
    });
  }

  @Then("Operator verifies that the Reopen Shipment Button is disabled")
  public void operatorVerifiesThatTheReopenShipmentButtonIsDisabled() {
    page.inFrame(() -> Assertions.assertThat(
            page.actionsMenu.getItemElement("Reopen Shipments").getAttribute("class"))
        .withFailMessage("Reopen Shipments option is enabled")
        .contains("ant-dropdown-menu-item-disabled"));
  }

  @When("Operator enters multiple shipment ids in the Shipment Management Page")
  public void operatorEntersMultipleShipmentIdsInTheShipmentManagementPage() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    enterShipmentIds(shipmentIds.stream().map(Objects::toString).collect(Collectors.toList()));
  }

  @Then("Operator verifies that search error modal shown with shipment ids:")
  public void operatorVerifiesThatThereIsASearchErrorModalShownWith(List<String> shipmentIds) {
    List<String> finalShipmentIds = resolveValues(shipmentIds);
    page.inFrame(() -> {
      page.searchErrorDialog.waitUntilVisible();
      List<String> lines = page.searchErrorDialog.messageLines.stream().map(PageElement::getText)
          .collect(Collectors.toList());
      Assertions.assertThat(lines.get(0)).as("Error message")
          .isEqualTo("We cannot find the following " + finalShipmentIds.size() + " shipment ids:");

      lines.remove(0);
      Assertions.assertThat(lines).as("Invalid shipment ids")
          .containsExactlyInAnyOrderElementsOf(finalShipmentIds);
    });
  }

  @Then("Operator click Show Shipments button in Search Error dialog on Shipment Management Page")
  public void clickShowShipments() {
    page.inFrame(() -> {
      page.searchErrorDialog.waitUntilVisible();
      page.searchErrorDialog.show.click();
    });
  }

  @Then("Operator verify {string} action button is disabled on shipment Management page")
  public void operatorVerifyActionButtonIsDisabled(String actionButton) {
    page.inFrame(() -> {
      if ("Cancel".equals(actionButton)) {
        Assertions.assertThat(page.shipmentsTable.getActionButton(1, ACTION_CANCEL).isEnabled())
            .as("Cancel button is enabled").isFalse();
      }
    });
  }

  @Then("Operator selects all shipments and click bulk update button under the apply action")
  public void operatorSelectsAllShipmentsAndClickBulkUpdateButtonUnderTheApplyAction() {
    page.inFrame(() -> {
      page.tableActionsMenu.selectOption("Select All Shown");
      page.actionsMenu.selectOption("Bulk Update");
    });
  }

  @Then("Operator selects shipments and click bulk update button:")
  public void selectAndBulkUpdate(List<String> shipmentIds) {
    List<String> ids = resolveValues(shipmentIds);
    page.inFrame(() -> {
      ids.forEach(id -> {
        page.shipmentsTable.filterByColumn(COLUMN_SHIPMENT_ID, id);
        page.shipmentsTable.selectRow(1);
      });
      page.actionsMenu.selectOption("Bulk Update");
    });
  }

  @When("Operator bulk update shipment with data below:")
  public void operatorBulkUpdateShipmentWithDataBelow(Map<String, String> mapOfData) {
    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);

    page.inFrame(() -> {
      page.bulkUpdateShipment(resolvedMapOfData);
      page.verifyShipmentToBeUpdatedData(shipmentIds, resolvedMapOfData);
      page.confirmUpdateBulk(resolvedMapOfData);
    });
  }

  @Then("Operator verify the following parameters of all created shipments on Shipment Management page:")
  public void operatorVerifyTheFollowingParametersOfAllTheCreatedShipmentOnShipmentManagementPage(
      Map<String, String> mapOfData) {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    Map<String, String> data = new HashMap<>(mapOfData);
    for (Long shipmentId : shipmentIds) {
      data.put("id", shipmentId.toString());
      page.inFrame(
          () -> operatorVerifyParametersShipmentOnShipmentManagementPage(data));
    }
  }

  @Then("Operator verify it highlight selected shipment and it can select another shipment")
  public void operatorVerifyItHighlightSelectedShipmentAndItCanSelectAnotherShipment() {
    page.inFrame(() -> page.selectAnotherShipmentAndVerifyCount());
  }

  @Then("Operator verify error message exist")
  public void operatorVerifyErrorMessageExist() {
    page.inFrame(() -> {
      Assertions.assertThat(page.createShipmentDialog.startHubError.isDisplayedFast())
          .withFailMessage("Error Message in Origin Hub Form is not displayed").isTrue();
      Assertions.assertThat(page.createShipmentDialog.endHubError.isDisplayedFast())
          .withFailMessage("Error Message in Destination Hub Form is not displayed").isTrue();
    });
  }

  @And("Operator verify {string} is disable")
  public void operatorVerifyCreateButtonIsDisable(String disabledButton) {
    Button button;
    switch (disabledButton.toLowerCase()) {
      case "create button":
        button = page.createShipmentDialog.create;
        break;
      case "create another button":
        button = page.createShipmentDialog.createAnother;
        break;
      default:
        throw new IllegalStateException("Unknown button name " + disabledButton);
    }
    page.inFrame(() -> Assertions.assertThat(button.isEnabled())
        .withFailMessage(disabledButton + " is enabled").isFalse());
  }

  @And("Operator verifies number of entered shipment ids on Shipment Management page:")
  public void verifyNumberOfShipmentIDs(Map<String, String> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      if (data.containsKey("entered")) {
        assertions.assertThat(page.enteredUniqueShipmentIds.getText())
            .as("Entered unique shipment ids").isEqualTo(data.get("entered") + " entered");
      }
      if (data.containsKey("duplicate")) {
        if (!page.enteredDuplicateShipmentIds.isDisplayedFast()) {
          assertions.fail("Number of duplicated shipment ids is not displayed");
        } else {
          assertions.assertThat(page.enteredDuplicateShipmentIds.getText())
              .as("Entered duplicate shipment ids")
              .isEqualTo("(" + data.get("duplicate") + " duplicate)");
        }
      }
    });
    assertions.assertAll();
  }
}