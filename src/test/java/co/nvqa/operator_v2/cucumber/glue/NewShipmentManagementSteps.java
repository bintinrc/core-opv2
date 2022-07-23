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
import co.nvqa.operator_v2.util.KeyConstants;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
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

  @When("^Operator filter ([^\"]*) = ([^\"]*) on Shipment Management page$")
  public void fillSearchFilter(String filter, String value) {
    String resolvedValue = resolveValue(value);
    putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, filter, resolvedValue);
    page.inFrame(() -> {

    });
  }

  @When("Operator apply filters on Shipment Management Page:")
  public void operatorFilerWithData(Map<String, String> mapOfData) {
    Map<String, String> data = resolveKeyValues(mapOfData);
    page.inFrame(() -> {
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
          page.addFilter.selectValue("Shipment Completion Date");
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
          page.addFilter.selectValue("transit Date Time");
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
          page.addFilter.selectValue("Origin Hub");
        } else {
          page.originHubFilter.clearAll();
        }
        page.originHubFilter.selectFilter(splitAndNormalize(data.get("originHub")));
      }
      if (data.containsKey("destinationHub")) {
        if (!page.destinationHubFilter.isDisplayedFast()) {
          page.addFilter.selectValue("Destination Hub");
        } else {
          page.destinationHubFilter.clearAll();
        }
        page.destinationHubFilter.selectFilter(splitAndNormalize(data.get("destinationHub")));
      }
      if (data.containsKey("lastInboundHub")) {
        if (!page.lastInboundHubFilter.isDisplayedFast()) {
          page.addFilter.selectValue("Last Inbound Hub");
        } else {
          page.lastInboundHubFilter.clearAll();
        }
        page.lastInboundHubFilter.selectFilter(splitAndNormalize(data.get("lastInboundHub")));
        putInMap(KEY_SHIPMENT_MANAGEMENT_FILTERS, "Last Inbound Hub", data.get("lastInboundHub"));
      }
      if (data.containsKey("mawb")) {
        if (!page.mawbFilter.isDisplayedFast()) {
          page.addFilter.selectValue("MAWB");
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
      page.searchByShipmentIds.click();
    });
  }

  @When("Operator enters shipment ids on Shipment Management page:")
  public void enterShipmentIds(List<String> ids) {
    String shipmentIds = Strings.join(resolveValues(ids)).with("\n");
    page.inFrame(() -> {
      page.shipmentIds.setValue(shipmentIds);
    });
  }

  @When("Operator enters next shipment ids on Shipment Management page:")
  public void enterNextShipmentIds(List<String> ids) {
    String shipmentIds = Strings.join(resolveValues(ids)).with("\n");
    page.inFrame(() -> {
      page.shipmentIds.sendKeys("\n" + shipmentIds);
    });
  }

  @Given("Operator click Edit filter on Shipment Management page")
  public void operatorClickEditFilterOnShipmentManagementPage() {
    page.inFrame(() -> page.editFilters.click());
  }

  @When("^Operator clear all filters on Shipment Management page$")
  public void operatorClearAllFiltersOnShipmentManagementPage() {
    page.inFrame(() -> page.clearAllFilters.click());
  }

  @When("^Operator create Shipment on Shipment Management page using data below:$")
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

  @When("Operator edit Shipment on Shipment Management page based on {string} using data below:")
  public void operatorEditShipmentOnShipmentManagementPageBasedOnTypeUsingDataBelow(String editType,
      Map<String, String> mapOfData) {
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    if (shipmentInfo == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    }

    Map<String, String> resolvedMapOfData = resolveKeyValues(mapOfData);
    switch (editType) {
      case "Start Hub":
        shipmentInfo.setOrigHubName(resolvedMapOfData.get("origHubName"));
        break;
      case "End Hub":
        shipmentInfo.setDestHubName(resolvedMapOfData.get("destHubName"));
        break;
      case "Comments":
        shipmentInfo.setComments(resolvedMapOfData.get("comments"));
        break;
      case "EDA & ETA":
        shipmentInfo.setArrivalDatetime(
            resolvedMapOfData.get("EDA") + " " + resolvedMapOfData.get("ETA"));
        break;
      case "mawb":
        shipmentInfo.setMawb(
            "12" + resolvedMapOfData.get("mawb").charAt(0) + "-" + resolvedMapOfData.get(
                "mawb").substring(1));
        break;
      case "non-mawb":
        shipmentInfo.setOrigHubName(resolvedMapOfData.get("origHubName"));
        shipmentInfo.setDestHubName(resolvedMapOfData.get("destHubName"));
        shipmentInfo.setComments(resolvedMapOfData.get("comments"));
        break;
    }
    ShipmentInfo finalShipmentInfo = shipmentInfo;
    page.inFrame(() -> {
      page.editShipmentBy(editType, finalShipmentInfo, resolvedMapOfData);
    });
    put(KEY_SHIPMENT_INFO, shipmentInfo);
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

  @When("^Operator edit Shipment on Shipment Management page including MAWB using data below:$")
  public void operatorEditShipmentOnShipmentManagementPageIncludingMawbUsingDataBelow(
      Map<String, String> mapOfData) {
    mapOfData = resolveKeyValues(mapOfData);
    ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
    shipmentInfo.fromMap(mapOfData);
    page.editShipment(shipmentInfo);
    put(KeyConstants.KEY_MAWB, shipmentInfo.getMawb());
  }

  @Then("^Operator verify parameters of the created shipment on Shipment Management page$")
  public void operatorVerifyParametersOfTheCreatedShipmentOnShipmentManagementPage() {
    ShipmentInfo shipmentInfo;

    if (get(KEY_SHIPMENT_INFO) == null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentInfo = new ShipmentInfo(shipments);
    } else {
      shipmentInfo = get(KEY_SHIPMENT_INFO);
    }

    page.inFrame(() -> page.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo));
  }

  @Then("^Operator verify parameters of shipment on Shipment Management page using data below:$")
  public void operatorVerifyParametersShipmentOnShipmentManagementPage(Map<String, String> data) {
    data = resolveKeyValues(data);
    data = StandardTestUtils.replaceDataTableTokens(data);
    ShipmentInfo shipmentInfo = new ShipmentInfo();
    shipmentInfo.fromMap(data);
    page.inFrame(() -> page.validateShipmentInfo(shipmentInfo.getId(), shipmentInfo));
  }

  @Then("Operator verify parameters of the created multiple shipment on Shipment Management page")
  public void operatorVerifyParametersOfTheCreatedMultipleShipmentOnShipmentManagementPage() {
    List<Long> shipmentId = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    page.inFrame(() -> {
      for (Long shipmentIds : shipmentId) {
        page.validateShipmentId(shipmentIds);
      }
    });
  }

  @Then("^Operator verify the following parameters of the created shipment on Shipment Management page:$")
  public void operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(
      Map<String, String> mapOfData) {
    Long shipmentId;

    if (get(KEY_CREATED_SHIPMENT_ID) != null) {
      shipmentId = get(KEY_CREATED_SHIPMENT_ID);
    } else if (get(KEY_SHIPMENT_INFO) != null) {
      ShipmentInfo shipmentInfo = get(KEY_SHIPMENT_INFO);
      shipmentId = shipmentInfo.getId();
    } else if (get(KEY_CREATED_SHIPMENT) != null) {
      Shipments shipments = get(KEY_CREATED_SHIPMENT);
      shipmentId = shipments.getShipment().getId();
    } else {
      throw new IllegalArgumentException("Shipper id was not defined");
    }

    ShipmentInfo expectedShipmentInfo = new ShipmentInfo(resolveKeyValues(mapOfData));
    page.inFrame(() -> page.validateShipmentInfo(shipmentId, expectedShipmentInfo));
  }

  @Then("^Operator verify search results contains exactly shipments on Shipment Management page:$")
  public void operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(
      List<String> shipmentIds) {
    page.inFrame(() -> {
      List<String> actual = page.shipmentsTable.readColumn(COLUMN_SHIPMENT_ID);
      Assertions.assertThat(actual)
          .as("List of Shipment IDs")
          .containsExactlyInAnyOrderElementsOf(resolveValues(shipmentIds));
    });
  }

  @Then("Operator verify the following parameters of all created shipments status is pending")
  public void operatorVerifyTheFollowingParametersOfTheAllCreatedShipmentsStatusIsPending() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    for (Long shipmentId : shipmentIds) {
      page.validateShipmentStatusPending(shipmentId);
    }
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
    page.verifyOpenedShipmentDetailsPageIsTrue(shipmentInfo.getId(), order.getTrackingId());
    getWebDriver().switchTo().window(get(KEY_MAIN_WINDOW_HANDLE));
  }

  @Then("^Operator verify shipment event on Shipment Details page using data below:$")
  public void operatorVerifyShipmentEventOnEditOrderPage(Map<String, String> mapOfData) {
    retryIfRuntimeExceptionOccurred(() -> {
      try {
        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
        page.switchTo();
        ShipmentEvent actualEvent = new ShipmentEvent(
            page.shipmentEventsTable.readShipmentEventsTable(
                finalMapOfData.get("source")));
        expectedEvent.compareWithActual(actualEvent);
      } catch (Throwable ex) {
        LOGGER.error(ex.getLocalizedMessage(), ex);
        page.refreshPage();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, "retry shipment details", 1000, 3);
  }

  @Then("Operator verifies event is present for shipment on Shipment Detail page")
  public void operatorVerifiesEventIsPresentForShipmentOnShipmentDetailPage(
      Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    List<Shipments> lists = get(KEY_LIST_OF_CREATED_SHIPMENT);

    lists.forEach(shipment -> {
      retryIfAssertionErrorOccurred(() -> {
        verifyShipmentEventData(shipment.getShipment().getId(), finalMapOfData);
      }, "retry shipment details event", 5000, 10);
    });
  }

  private void verifyShipmentEventData(Long shipmentId, Map<String, String> finalMapOfData) {
    try {
      ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
      navigateTo(f("%s/%s/shipment-details/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
          TestConstants.COUNTRY_CODE, shipmentId));
      page.waitUntilPageLoaded();
      List<ShipmentEvent> events = page.shipmentEventsTable.readFirstEntities(1);
      ShipmentEvent actualEvent = events.stream().filter(
              event -> StringUtils.equalsIgnoreCase(event.getSource(), expectedEvent.getSource()))
          .findFirst().orElseThrow(() -> new AssertionError(
              f("There is no [%s] shipment event on Shipment Details page",
                  expectedEvent.getSource())));
      expectedEvent.compareWithActual(actualEvent);
    } catch (Throwable ex) {
      LOGGER.error(ex.getMessage(), ex);
      throw ex;
    }
  }

  @Then("Operator verifies event is present for shipment id {string} on Shipment Detail page")
  public void operatorVerifiesEventIsPresentForShipmentIdOnShipmentDetailPage(
      String shipmentIdAsString, Map<String, String> mapOfData) {
    final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
    Long shipmentId = Long.valueOf(resolveValue(shipmentIdAsString));
    retryIfAssertionErrorOccurred(() -> {
      try {
        ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
        navigateTo(f("%s/%s/shipment-details/%d", TestConstants.OPERATOR_PORTAL_BASE_URL,
            TestConstants.COUNTRY_CODE, shipmentId));
        page.waitUntilPageLoaded();
        List<ShipmentEvent> events = page.shipmentEventsTable.readFirstEntities(
            1);
        ShipmentEvent actualEvent = events.stream().filter(
                event -> StringUtils.equalsIgnoreCase(event.getSource(), expectedEvent.getSource()))
            .findFirst().orElseThrow(() -> new AssertionError(
                f("There is no [%s] shipment event on Shipment Details page",
                    expectedEvent.getSource())));
        expectedEvent.compareWithActual(actualEvent);
      } catch (Throwable ex) {
        LOGGER.error(ex.getMessage(), ex);
        throw ex;
      }
    }, "retry shipment details event", 5000, 10);
  }

  @Then("^Operator open shipment detail and verify shipment event on Shipment Details page using data below:$")
  public void operatorOpenShipmentDetailAndVerifyShipmentEventOnEditOrderPage(
      Map<String, String> mapOfData) {
    retryIfAssertionErrorOccurred(() -> {
      try {
        ShipmentInfo shipmentInfo;

        if (get(KEY_SHIPMENT_INFO) == null) {
          Shipments shipments = get(KEY_CREATED_SHIPMENT);
          shipmentInfo = new ShipmentInfo(shipments);
        } else {
          shipmentInfo = get(KEY_SHIPMENT_INFO);
        }
        put(KEY_MAIN_WINDOW_HANDLE, getWebDriver().getWindowHandle());
        page.openShipmentDetailsPage(shipmentInfo.getId());

        final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
        ShipmentEvent expectedEvent = new ShipmentEvent(finalMapOfData);
        page.switchTo();
        ShipmentEvent actualEvent = new ShipmentEvent(
            page.shipmentEventsTable.readShipmentEventsTable(
                finalMapOfData.get("source")));
        expectedEvent.compareWithActual(actualEvent);
      } catch (Throwable ex) {
        LOGGER.error(ex.getLocalizedMessage(), ex);
        page.refreshPage();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, "retry shipment details", 5000, 10);
  }

  @Then("Operator verify movement event on Shipment Details page using data below:")
  public void operatorVerifyMovementEventOnEditOrderPage(Map<String, String> mapOfData) {
    retryIfRuntimeExceptionOccurred(() -> {
      final Map<String, String> finalMapOfData = resolveKeyValues(mapOfData);
      MovementEvent expectedEvent = new MovementEvent(finalMapOfData);
      try {
        page.switchTo();
        MovementEvent actualEvent = new MovementEvent(
            page.movementEventsTable.readMovementEventsTable(
                finalMapOfData.get("source")));
        expectedEvent.compareWithActual(actualEvent);
      } catch (Throwable ex) {
        LOGGER.error(ex.getLocalizedMessage(), ex);
        page.refreshPage();
        throw new NvTestRuntimeException(ex.getCause());
      }
    }, "retry shipment details", 1000, 3);
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
    Map<String, String> finalData = resolveKeyValues(data);
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      if (data.containsKey("shipmentStatus")) {
        List<String> actual = page.shipmentStatusFilter.getSelectedValues();
        assertions.assertThat(actual)
            .as("Shipment Status")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipmentStatus")));
      }
      if (data.containsKey("shipmentType")) {
        List<String> actual = page.shipmentTypeFilter.getSelectedValues();
        assertions.assertThat(actual)
            .as("Shipment Type")
            .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("shipmentType")));
      }
      if (data.containsKey("originHub")) {
        if (!page.originHubFilter.isDisplayedFast()) {
          assertions.fail("Origin Hub filter is not displayed");
        } else {
          List<String> actual = page.originHubFilter.getSelectedValues();
          assertions.assertThat(actual)
              .as("Origin Hub")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("originHub")));
        }
      }
      if (data.containsKey("destinationHub")) {
        if (!page.destinationHubFilter.isDisplayedFast()) {
          assertions.fail("Destination Hub filter is not displayed");
        } else {
          List<String> actual = page.destinationHubFilter.getSelectedValues();
          assertions.assertThat(actual)
              .as("Destination Hub")
              .containsExactlyInAnyOrderElementsOf(splitAndNormalize(data.get("destinationHub")));
        }
      }
      if (data.containsKey("lastInboundHub")) {
        if (!page.lastInboundHubFilter.isDisplayedFast()) {
          assertions.fail("Last Inbound Hub filter is not displayed");
        } else {
          List<String> actual = page.lastInboundHubFilter.getSelectedValues();
          assertions.assertThat(actual)
              .as("Last Inbound Hub")
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
        Assertions.assertThat(presets)
            .as("Available filters presets")
            .doesNotContain(presetName);
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
        page.createAndUploadCsv(orders, fileName, true, true, numberOfOrder,
            finalShipmentInfo);
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
    page.inFrame(() ->
        Assertions.assertThat(
                page.actionsMenu.getItemElement("Reopen Shipments").getAttribute("class"))
            .withFailMessage("Reopen Shipments option is enabled")
            .contains("ant-dropdown-menu-item-disabled")
    );
  }

  @When("Operator searches multiple shipment ids in the Shipment Management Page")
  public void operatorSearchesMultipleShipmentIdsInTheShipmentManagementPage() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    fillSearchShipmentsByIds(
        shipmentIds.stream().map(Objects::toString).collect(Collectors.toList()));
  }

  @When("Operator enters multiple shipment ids in the Shipment Management Page")
  public void operatorEntersMultipleShipmentIdsInTheShipmentManagementPage() {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    enterShipmentIds(
        shipmentIds.stream().map(Objects::toString).collect(Collectors.toList()));
  }

  @Then("Operator verifies that search error modal shown with shipment ids:")
  public void operatorVerifiesThatThereIsASearchErrorModalShownWith(List<String> shipmentIds) {
    List<String> finalShipmentIds = resolveValues(shipmentIds);
    page.inFrame(() -> {
      page.searchErrorDialog.waitUntilVisible();
      List<String> lines = page.searchErrorDialog.messageLines.stream()
          .map(PageElement::getText)
          .collect(Collectors.toList());
      Assertions.assertThat(lines.get(0))
          .as("Error message")
          .isEqualTo("We cannot find the following " + finalShipmentIds.size() + " shipment ids:");

      lines.remove(0);
      Assertions.assertThat(lines)
          .as("Invalid shipment ids")
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
            .as("Cancel button is enabled")
            .isFalse();
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

  @Then("Operator verify the following parameters of shipment with id {string} on Shipment Management page:")
  public void operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(
      String shipmentIdAsString, Map<String, String> mapOfData) {
    String resolvedShipmentId = resolveValue(shipmentIdAsString);
    Long shipmentId = Long.valueOf(resolvedShipmentId);
    Map<String, String> resolvedKeyValues = resolveKeyValues(mapOfData);
    page.inFrame(() -> page.validateShipmentUpdated(shipmentId, resolvedKeyValues));
  }

  @Then("Operator verify the following parameters of all created shipments on Shipment Management page:")
  public void operatorVerifyTheFollowingParametersOfAllTheCreatedShipmentOnShipmentManagementPage(
      Map<String, String> mapOfData) {
    List<Long> shipmentIds = get(KEY_LIST_OF_CREATED_SHIPMENT_ID);
    for (Long shipmentId : shipmentIds) {
      page.inFrame(() ->
          operatorVerifyTheFollowingParametersOfTheCreatedShipmentOnShipmentManagementPage(
              String.valueOf(shipmentId), mapOfData)
      );
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
        .withFailMessage(disabledButton + " is enabled")
        .isFalse()
    );
  }

  @And("Operator verifies number of entered shipment ids on Shipment Management page:")
  public void verifyNumberOfShipmentIDs(Map<String, String> data) {
    SoftAssertions assertions = new SoftAssertions();
    page.inFrame(() -> {
      if (data.containsKey("entered")) {
        assertions.assertThat(page.enteredUniqueShipmentIds.getText())
            .as("Entered unique shipment ids")
            .isEqualTo(data.get("entered") + " entered");
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