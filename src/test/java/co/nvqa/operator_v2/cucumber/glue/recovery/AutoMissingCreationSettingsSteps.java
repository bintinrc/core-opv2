package co.nvqa.operator_v2.cucumber.glue.recovery;

import co.nvqa.operator_v2.cucumber.glue.AbstractSteps;
import co.nvqa.operator_v2.selenium.page.recovery.AutoMissingCreationSettingsPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;


import java.util.Map;

import org.assertj.core.api.Assertions;


public class AutoMissingCreationSettingsSteps extends AbstractSteps {
    private AutoMissingCreationSettingsPage autoMissingCreationSettingsPage;

    public AutoMissingCreationSettingsSteps() {
    }

    @Override
    public void init() {
        autoMissingCreationSettingsPage = new AutoMissingCreationSettingsPage(getWebDriver());
    }

    @When("Operator Search created hub by hub id = {string} in Auto Missing Creation Settings page")
    public void searchCreatedHub(String hubId) {
        autoMissingCreationSettingsPage.inFrame((page) -> {
            page.hubTable.filterTableByHubId("hubId", resolveValue(hubId));
        });
    }

    @Then("Operator verifies new hub is available in Hub Missing Investigation Mapping table with correct details")
    public void verifyHubWithCorrectDetails(Map<String, String> dataTable) {
        Map<String, String> data = resolveKeyValues(dataTable);
        autoMissingCreationSettingsPage.inFrame((page) -> {
            Assertions.assertThat(page.hubTable.id.getText()).isEqualTo(data.get("id"));
            Assertions.assertThat(page.hubTable.name.getText()).isEqualTo(data.get("name"));
        });
    }

    @Then("Operator verifies the disabled hub not found")
    public void verifyHubIsNotFound() {
        autoMissingCreationSettingsPage.inFrame(AutoMissingCreationSettingsPage::noResultFound);
    }

    @When("Operator edit Hub Missing Investigation for specific hub")
    public void editSpecificHub() {
        autoMissingCreationSettingsPage.inFrame((page) -> {
            page.hubTable.clickActionButton(1, AutoMissingCreationSettingsPage.HubMissingInvestigationMappingTable.ACTION_EDIT);
        });
    }

    @Then("Operator verifies Edit Hub Missing Investigation Mapping dialog")
    public void verifyEditHubModal(Map<String, String> dataTable) {
        Map<String, String> data = resolveKeyValues(dataTable);
        autoMissingCreationSettingsPage.inFrame((page) -> {
            Assertions.assertThat(page.editHubDialog.title.getText()).as("edit hub dialog title").isEqualTo("Edit Hub Missing Investigation Mapping");
            Assertions.assertThat(page.hubTable.id.getText()).isEqualTo(data.get("id"));
            Assertions.assertThat(page.hubTable.name.getText()).isEqualTo(data.get("name"));

        });
    }

    @When("Operator select Assignee and Investigation dept in Edit Hub Missing Investigation Mapping dialog")
    public void selectAssigneeAndInvestigationDept() {
        autoMissingCreationSettingsPage.inFrame((page) -> {
            page.editHubDialog.selectionInput.get(0).click();
            page.editHubDialog.recoveryInvestigationDept.click();
            page.editHubDialog.selectionInput.get(1).click();
            page.editHubDialog.autoEditedAssignee.click();
            page.editHubDialog.submitChanges.click();
        });
    }

    @Then("Operator verifies that success notification displayed")
    public void doVerifiesToastDisplayed(Map<String, String> dataTable) {
        dataTable = resolveKeyValues(dataTable);
        String message = dataTable.get("message");
        autoMissingCreationSettingsPage.inFrame((page) -> {
            retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
                Assertions.assertThat(page.notificationMessage.getText())
                        .as(f("Notification Message contains: %s", message)).contains(message);
            }, 5);
        });
    }

    @When("Operator select Assignee in Edit Hub Missing Investigation Mapping dialog - ID")
    public void selectAssignee() {
        autoMissingCreationSettingsPage.inFrame((page) -> {
            page.editHubDialog.selectionInput.get(1).click();
            page.editHubDialog.autoEditedAssignee.click();
            page.editHubDialog.submitChanges.click();

        });
    }
}

