### Testing Scenarios

1. **Submit a Booking Request**:
   - Use the `SubmitBookingRequest` procedure to add a new booking request.
   - Example: `EXECUTE SubmitBookingRequest(3, 1, TIMESTAMP '2024-11-01 10:00:00', TIMESTAMP '2024-11-01 12:00:00');`

2. **Approve or Reject a Booking Request**:
   - Use the `ApproveRejectBooking` procedure to approve or reject an existing booking request.
   - Example: `EXECUTE ApproveRejectBooking(1, 1, TRUE);` (Assuming `1` is the request ID and the manager with `sesco_id` 1 approves it.)

3. **Finalize a Booking**:
   - Use the `FinalizeBooking` procedure to finalize an approved booking.
   - Example: `EXECUTE FinalizeBooking(3, 5);` (Assuming `3` is the request ID and the admin with `sesco_id` 5 finalizes it.)

These records and scenarios will help you test various functionalities and ensure that the system handles different stages of booking reservations effectively, from request submission through approval and finalization by the respective authorized roles.

============================testing2===================================


### Additional Test Cases
- Test cases where overlapping bookings occur.
- Test cases where requests are made by users with different roles and are approved/rejected by managers/admins accordingly.
- Test cases where booking requests are finalized by admins.
- Test cases where incorrect or invalid data is entered to ensure proper error handling.
