package com.nv.qa.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class SamedayRouteEnginePage extends SimplePage
{
    private static final int SAVE_BUTTON_LOADING_TIMEOUT_IN_SECONDS = 30;

    public SamedayRouteEnginePage(WebDriver driver)
    {
        super(driver);
    }

    public void selectRouteGroup(String routeGroupName)
    {
        click("//md-select[@aria-label='Select Route Group']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routeGroupName));
    }

    public void selectRoutingAlgorithm(String routingAlgorithm)
    {
        click("//md-select[@aria-label='Routing Algorithm']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routingAlgorithm));
    }

    public void selectHub(String hubName)
    {
        click("//md-select[@aria-label='Hub']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", hubName));
    }

    public void clickRunRouteEngineButton()
    {
        click("//button[@aria-label='Run Route Engine']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Run Route Engine']//md-progress-circular", SAVE_BUTTON_LOADING_TIMEOUT_IN_SECONDS);
    }

    public void selectFleetType1OperatingHoursStart(String operatingHoursStart)
    {
        click("//md-select[contains(@aria-label,'Operating Start')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", operatingHoursStart));
    }

    public void selectFleetType1OperatingHoursEnd(String operatingHoursTo)
    {
        click("//md-select[contains(@aria-label,'Operating End')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", operatingHoursTo));
    }

    public void selectFleetType1BreakDurationStart(String breakDurationStart)
    {
        click("//md-select[contains(@aria-label,'Break Start')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", breakDurationStart));
    }

    public void selectFleetType1BreakDurationEnd(String breakDurationEnd)
    {
        click("//md-select[contains(@aria-label,'Break End')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", breakDurationEnd));
    }

    public void selectDriverOnRouteSettingsPage(String driverName)
    {
        sendKeys("//input[@aria-label='Search Driver']", driverName);
        pause500ms();
        click(String.format("//li[@md-virtual-repeat='item in $mdAutocompleteCtrl.matches']/md-autocomplete-parent-scope/span/span[text()='%s']", driverName));
        pause100ms();
    }

    public void clickCreate1RoutesButton()
    {
        click("//button[@aria-label='Create 1 Route(s)']");
        waitUntilInvisibilityOfElementLocated("//button[@aria-label='Create 1 Route(s)']//md-progress-circular", SAVE_BUTTON_LOADING_TIMEOUT_IN_SECONDS);
    }
}
