package com.nv.qa.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class SamedayRouteEnginePage extends SimplePage
{
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
        click("//md-select[@aria-label='Select Routing Algorithm']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", routingAlgorithm));
    }

    public void selectHub(String hubName)
    {
        click("//md-select[@aria-label='Select Hub']");
        pause100ms();
        click(String.format("//md-option/div[contains(text(), '%s')]", hubName));
    }

    public void clickRunRouteEngineButton()
    {
        click("//button[@aria-label='Run Route Engine']");
        pause100ms();
    }

    public void selectFleetType1OperatingHoursFrom(String operatingHoursFrom)
    {
        click("//md-select[contains(@aria-label,'Operating Hours')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", operatingHoursFrom));
    }

    public void selectFleetType1OperatingHoursTo(String operatingHoursTo)
    {
        click("(//md-select[contains(@aria-label,'To')])[1]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", operatingHoursTo));
    }

    public void selectFleetType1BreakHoursFrom(String breakingHoursFrom)
    {
        click("//md-select[contains(@aria-label,'Break Hours')]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", breakingHoursFrom));
    }

    public void selectFleetType1BreakHoursTo(String breakingHoursTo)
    {
        click("(//md-select[contains(@aria-label,'To')])[2]");
        pause100ms();
        click(String.format("//div[@aria-hidden='false']/md-select-menu/md-content/md-option/div[contains(text(), '%s')]", breakingHoursTo));
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
        pause200ms();
    }
}
