
================= meeting_room_schema =====================

-------------------Tables Creation-------------------------

  CREATE TABLE Users 
   
  (

  sesco_id      nvarchar2(10,0),
  username      NVARCHAR2(29)   NOT NULL,
  firstname     NVARCHAR2(29)   NOT NULL,
  lastname      NVARCHAR2(20)   NOT NULL,
  email         NVARCHAR2(70)   NOT NULL,
  user_location NVARCHAR2(150)  NOT NULL,
  job_title     NVARCHAR2(100)  NOT NULL,
  role          VARCHAR2(10) CHECK (role IN ('Manager', 'Admin', 'User')),
  CONSTRAINT Users_PK       PRIMARY KEY (sesco_id),
  CONSTRAINT Username_UK    UNIQUE (username),
  CONSTRAINT Email_UK       UNIQUE (email)
);

CREATE TABLE Meeting_rooms 
(
  meeting_room_id            NUMBER(3,0),
  room_name                  NVARCHAR2(40),
  meeting_room_location      NVARCHAR2(150),
  room_capacity              NUMBER(5,0),
  CONSTRAINT Meeting_rooms_PK PRIMARY KEY (meeting_room_id)
);
---------------------------------------
CREATE SEQUENCE  "REQUEST_ID"  
MINVALUE 0 
MAXVALUE 9999999999999999999999999 
INCREMENT BY 1 
START WITH 0 
CACHE 2
NOORDER  
NOCYCLE  
NOKEEP  NOSCALE  GLOBAL ;


----------------------------------
CREATE TABLE Booking_Requests 
    
    (

    request_id          NUMBER(10,0),
    user_id             NUMBER(5,0) NOT NULL,
    meeting_room_id     NUMBER(3,0) NOT NULL,
    proposed_date       date        not null,
    proposed_start_time TIMESTAMP   NOT NULL,
    proposed_end_time   TIMESTAMP   NOT NULL,
    status              VARCHAR2(20) CHECK (status IN ('Requested', 'Manager_Approved', 'Rejected', 'Admin_Approved')),
    created_by          VARCHAR2(80),
    created_on          TIMESTAMP WITH LOCAL TIME ZONE,
    updated_by          VARCHAR2(80),
    updated_on          TIMESTAMP WITH LOCAL TIME ZONE,
    Manager_Approved_id      NUMBER(5,0),
    Admin_Approved_id        NUMBER(5,0),
    CONSTRAINT request_id_pk                PRIMARY KEY (request_id ),
    CONSTRAINT user_id_fk                   FOREIGN KEY (user_id)                   REFERENCES Users(sesco_id),
    CONSTRAINT meeting_room_id_fk           FOREIGN KEY (meeting_room_id)           REFERENCES Meeting_rooms(meeting_room_id),
    CONSTRAINT Manager_Approved_id_fk       FOREIGN KEY (Manager_Approved_id)       REFERENCES Users(sesco_id),
    CONSTRAINT Admin_Approved_id_fk         FOREIGN KEY (Admin_Approved_id)         REFERENCES Users(sesco_id),
    CONSTRAINT check_time_ck                CHECK       (proposed_start_time < proposed_end_time),
    CONSTRAINT no_overlap_uni               UNIQUE      (proposed_date, meeting_room_id, proposed_start_time, proposed_end_time)
);

CREATE SEQUENCE booking_request_seq START WITH 1;
CREATE INDEX idx_Booking_times ON Booking_Requests (meeting_room_id, proposed_start_time, proposed_end_time);

-----Procedure to Submit a Booking Request------

CREATE OR REPLACE PROCEDURE SubmitBookingRequest(
    p_user_id NUMBER,
    p_meeting_room_id NUMBER,
    p_start_time TIMESTAMP,
    p_end_time TIMESTAMP
) AS
BEGIN
  INSERT INTO Booking_Requests (
      request_id,
      user_id,
      meeting_room_id,
      proposed_start_time,
      proposed_end_time,
      status
  ) VALUES (
      booking_request_seq.NEXTVAL,
      p_user_id,
      p_meeting_room_id,
      p_start_time,
      p_end_time,
      'Requested'
  );

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/

/*Procedure for Manager to Approve or Reject Booking
This procedure now checks if the role of the person attempting to approve is 'Manager'.*/

CREATE OR REPLACE PROCEDURE ApproveRejectBooking(
    p_request_id NUMBER,
    p_manager_id NUMBER,
    p_approve NUMBER -- Using a NUMBER to represent the boolean (1 for true/approve, 0 for false/reject)
) AS
  v_role VARCHAR2(10);
BEGIN
  -- Check if the manager ID is valid and fetch the role
  SELECT role INTO v_role FROM Users WHERE sesco_id = p_manager_id;

  -- Check the role, ensure it is 'Manager'
  IF v_role != 'Manager' THEN
    RAISE_APPLICATION_ERROR(-20001, 'Only managers can approve or reject bookings.');
  END IF;
  
  -- Update the booking request with the new status and manager ID
  UPDATE Booking_Requests
  SET
    status = CASE WHEN p_approve = 1 THEN 'Manager_Approved' ELSE 'Rejected' END,
    Manager_Approved_id = p_manager_id
  WHERE request_id = p_request_id;

  -- Commit the changes
  COMMIT;
EXCEPTION
  -- Handle exceptions if no data is found or any other exception occurs
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'No such manager or request found.');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/


--Procedure for Admin to Finalize Booking
--This procedure ensures only 'Admin' roles can finalize bookings.

CREATE OR REPLACE PROCEDURE FinalizeBooking(
    p_request_id NUMBER,
    p_admin_id NUMBER
) AS
  v_role VARCHAR2(10);
BEGIN
  SELECT role INTO v_role FROM Users WHERE sesco_id = p_admin_id;
  IF v_role != 'Admin' THEN
    RAISE_APPLICATION_ERROR(-20002, 'Only admins can finalize bookings.');
  END IF;

  UPDATE Booking_Requests
  SET
    status = 'Admin_Approved',
    Admin_Approved_id = p_admin_id
  WHERE request_id = p_request_id AND status = 'Manager_Approved';

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/


/*To see the requester, approver, and finalizer's name and email, you can adjust the existing procedures to 
fetch and return this information when bookings are listed or queried.
1. Create a View to Simplify Access

First, let's create a view that joins the Booking_Requests table with the Users table to get all relevant 
information in one place. This view will be useful for both displaying and updating bookings.*/

CREATE OR REPLACE VIEW vw_BookingDetails AS
SELECT br.request_id,
       u1.username AS requester_username,
       u1.email AS requester_email,
       u2.username AS approver_username,
       u2.email AS approver_email,
       u3.username AS finalizer_username,
       u3.email AS finalizer_email,
       br.meeting_room_id,
       br.proposed_start_time,
       br.proposed_end_time,
       br.status
FROM Booking_Requests br
LEFT JOIN Users u1 ON br.user_id = u1.sesco_id
LEFT JOIN Users u2 ON br.Manager_Approved_id = u2.sesco_id
LEFT JOIN Users u3 ON br.Admin_Approved_id = u3.sesco_id;


/*This view vw_BookingDetails makes it easy to 
select booking details along with user information for requests, approvals, and finalizations.

2. Modify Existing Procedures to Utilize the View

You may want to create or modify existing procedures to leverage this view, especially for retrieval operations. 
Here, I'll show how you can use this view to fetch booking details:*/


CREATE OR REPLACE PROCEDURE ShowBookingDetails(
    p_request_id NUMBER
) AS
  v_requester_username NVARCHAR2(100);
  v_requester_email NVARCHAR2(100);
  v_approver_username NVARCHAR2(100);
  v_approver_email NVARCHAR2(100);
  v_finalizer_username NVARCHAR2(100);
  v_finalizer_email NVARCHAR2(100);
  v_status VARCHAR2(20);
BEGIN
  SELECT requester_username, requester_email,
         approver_username, approver_email,
         finalizer_username, finalizer_email, status
  INTO   v_requester_username, v_requester_email,
         v_approver_username, v_approver_email,
         v_finalizer_username, v_finalizer_email, v_status
  FROM   vw_BookingDetails
  WHERE  request_id = p_request_id;
  
  DBMS_OUTPUT.PUT_LINE('Requester: ' || v_requester_username || ', Email: ' || v_requester_email);
  DBMS_OUTPUT.PUT_LINE('Approver: ' || v_approver_username || ', Email: ' || v_approver_email);
  DBMS_OUTPUT.PUT_LINE('Finalizer: ' || v_finalizer_username || ', Email: ' || v_finalizer_email);
  DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No booking found with ID ' || p_request_id);
  WHEN OTHERS THEN
    RAISE;
END;
/

--This procedure ShowBookingDetails uses the view to retrieve and display details about a booking request including the participants' usernames and emails.

=======================================================================================================================================================================

