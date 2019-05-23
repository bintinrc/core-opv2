package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.driver.RejectReservationRequest;
import co.nvqa.operator_v2.model.ReservationRejectionEntity;
import co.nvqa.operator_v2.selenium.page.ReservationRejectionPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;

/**
 * @author Kateryna Skakunova
 */
public class ReservationRejectionSteps extends AbstractSteps
{
    private ReservationRejectionPage reservationRejectionPage;

    public ReservationRejectionSteps()
    {
    }

    @Override
    public void init()
    {
        reservationRejectionPage = new ReservationRejectionPage(getWebDriver());
    }

    @Then("^Operator verifies the Reservation is listed on the table with correct information$")
    public void operatorVerifiesTheReservationIsListedOnTheTableWithCorrectInformation()
    {
        RejectReservationRequest rejectReservationRequest = get(KEY_REJECT_RESERVATION_REQUEST);
        Address address = get(KEY_CREATED_ADDRESS);
        String address2 = address.getAddress2().isEmpty() ? "" : " " + address.getAddress2();
        String pickupInfo = address.getAddress1() + address2 + " " + address.getCountry() + " " + address.getPostcode();

        ReservationRejectionEntity entity = reservationRejectionPage
                .filterTableByReasonForRejection(rejectReservationRequest.getRejectionReason());
        reservationRejectionPage.validateReservationInTable(pickupInfo, rejectReservationRequest, entity);
    }

    @And("^Operator fails the pickup$")
    public void operatorFailsThePickup()
    {
        Address address = get(KEY_CREATED_ADDRESS);
        String address2 = address.getAddress2().isEmpty() ? "" : " " + address.getAddress2();
        String pickupInfo = address.getAddress1() + address2 + " " + address.getCountry() + " " + address.getPostcode();

        reservationRejectionPage.filterTableByPickup(pickupInfo);
        reservationRejectionPage.clickActionFailPickupForRow(1);
        reservationRejectionPage.failPickUpInPopup();
    }

    @Then("^Operator verifies pickup failed successfully$")
    public void operatorVerifiesPickupFailedSuccessfully()
    {
        Address address = get(KEY_CREATED_ADDRESS);
        String address2 = address.getAddress2().isEmpty()? "" : " " + address.getAddress2();
        String pickupInfo = address.getAddress1() + address2 + " " + address.getCountry() + " " + address.getPostcode();

        reservationRejectionPage.verifyToastAboutFailedPickupIsPresent();
        reservationRejectionPage.verifyRecordIsNotPresentInTableByPickup(pickupInfo);
    }
}