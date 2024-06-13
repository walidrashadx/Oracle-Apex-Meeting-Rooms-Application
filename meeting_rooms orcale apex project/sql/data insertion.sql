
Data Insertion
#### 1. Users  ####
Insert several users with different roles to test the system.

---------sql

INSERT ALL

 INTO Users (sesco_id, username, firstname, lastname, email, user_location, job_title, role) VALUES
 (1, 'w.rashad_admin', 'walid1', 'rashad1', 'waleed1600@hotmail.com', 'abo_bakr', 'jr.application_consultant', 'Admin')

INTO Users (sesco_id, username, firstname, lastname, email, user_location, job_title, role) VALUES 
(2, 'w.rashad_manager', 'walid2', 'rashad2', 'walid.rashad@sescotrans.net', 'abo_bakr', 'jr.application_consultant', 'Manager')

INTO Users (sesco_id, username, firstname, lastname, email, user_location, job_title, role) VALUES 
(3, 'w.rashad_user', 'walid3', 'rashad3', 'walidXrashad@gmail.com', 'abo_bakr', 'jr.application_consultant', 'User')

SELECT * FROM dual;
select * from users
----------------------------------------------------------------------------------------------------------------------

#### 2. Meeting Rooms
Insert several meeting rooms in various locations.


INSERT ALL
INTO Meeting_rooms (meeting_room_id, room_name, meeting_room_location, room_capacity) VALUES (1, 'Conference Room ',   '1 (S) Shahid Sayed Zakarya St., Sheraton Residence egypt', 17)
INTO Meeting_rooms (meeting_room_id, room_name, meeting_room_location, room_capacity) VALUES (2, 'marrting Room',       '89 abo_bakr el_sidyk st.,heliopolis egypt', 12)
INTO Meeting_rooms (meeting_room_id, room_name, meeting_room_location, room_capacity) VALUES (3, 'hr_room',             '89 abo_bakr el_sidyk st.,heliopolis egypt', 5)
SELECT * FROM dual;

select * from Meeting_rooms----------sql
----------------------------------------------------------------------------------------------------------------------

#### 3. Booking Requests
Insert booking requests to simulate different stages of the booking process.

```sql
-- Initial requests
INSERT INTO Booking_Requests (request_id, user_id, meeting_room_id, proposed_start_time, proposed_end_time, status) VALUES
(booking_request_seq.NEXTVAL, 3, 1, TIMESTAMP '2024-10-15 09:00:00', TIMESTAMP '2024-10-15 11:00:00', 'Requested'),
(booking_request_seq.NEXTVAL, 3, 2, TIMESTAMP '2024-10-16 14:00:00', TIMESTAMP '2024-10-16 16:00:00', 'Requested');

-- Approved request
INSERT INTO Booking_Requests (request_id, user_id, meeting_room_id, proposed_start_time, proposed_end_time, status, approved_by) VALUES
(booking_request_seq.NEXTVAL, 3, 3, TIMESTAMP '2024-10-17 13:00:00', TIMESTAMP '2024-10-17 15:00:00', 'Approved', 1);

-- Finalized booking
INSERT INTO Booking_Requests (request_id, user_id, meeting_room_id, proposed_start_time, proposed_end_time, status, approved_by, finalized_by) VALUES
(booking_request_seq.NEXTVAL, 3, 4, TIMESTAMP '2024-10-18 10:00:00', TIMESTAMP '2024-10-18 12:00:00', 'Finalized', 4, 5);
```
================================================================================================================================

