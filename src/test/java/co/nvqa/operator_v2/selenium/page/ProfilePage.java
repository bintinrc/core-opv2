package co.nvqa.operator_v2.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.WebDriver;

public class ProfilePage extends OperatorV2SimplePage
{

    private static final String PROFILE_BUTTON = "//button[@aria-label=\"Profile\"]";
    private static final String COUNTRY_BUTTON = "//md-select[@ng-model='domain.current']/md-select-value/span/div/div/span";
    private static final String APP_SIDENAV = "//app-sidenav";

    public ProfilePage(WebDriver webDriver) {
        super(webDriver);
    }

    public void clickProfileButton() {
        click(PROFILE_BUTTON);
    }

    public void clickCountryButton() {
        click(COUNTRY_BUTTON);
    }

    public void closeProfile() {
        click(APP_SIDENAV);
    }

    public void pickCountry(String country) {
        click("//md-option[@ng-repeat='d in domain.all']/div/div/span[text()='" + country + "']");
    }

    private String getCurrentCountry() {
        return findElementByXpath(COUNTRY_BUTTON).getText();
    }

    public void changeCountry(String newCountry) {
        String currentCountry = getCurrentCountry();

        if (currentCountry.equalsIgnoreCase(newCountry)) {
            closeProfile();
        } else {
            clickCountryButton();
            pickCountry(newCountry);
        }
    }

    public void currentCountryIs(String country) {
        clickProfileButton();
        String currentCountry = getCurrentCountry();
        closeProfile();
        Assert.assertTrue(String.format("Current country is %s not %s", currentCountry, country), currentCountry.equalsIgnoreCase(country));
    }
}
