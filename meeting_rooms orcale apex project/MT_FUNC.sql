created on
created by
updated on
updated by

1-idention : display only
--------------------------------------------

created by

DEFUALT
1-pl/sql exp

:APP_USER;

--------------
HIDE DURING CREATIONS

updated on
updated by 



SERVER SIDE

IN NOT NULL
ID_RESQUEST 
-------------------------------

CERATED ON

DEFULT 
EXPERSION PL/SQL
SYSDATE;
----------------------------------

SHARED COMP
GOLOALIZTION SET DATES -------DD MM YYYY

-----------------------------------
TO MAKE IT UPDATE AFTER USER SUMBIT
updated on
updated by
CREATE PROCESS
AFTER SUMBIT PROCESS

IN SOURCE CHOOSE PL EXPERSION

TYPE 
p12_UPDATED_BY := :APP_USER;
p12_UPDATED_ON = SYSDATE;
---------------------plsql process for updated on ----------------
DECLARE
    v_fullname users.firstname%TYPE;
BEGIN

    -- GET
    SELECT FIRSTNAME || ' ' || LASTNAME INTO v_fullname
    FROM users 
    WHERE ID = :APP_USER;

    -- ASSIGN
    :P15_UPDATED_BY := :APP_USER || ' - ' || v_fullname;
    :P15_UPDATED_ON := SYSDATE;
END;


------------------cascading lov-------------------
SELECT MEETING_ROOM_ID d, MEETING_ROOM_ID r
FROM MEETING_ROOMS where MEETING_ROOM_LOCATION= :P15_MEETING_ROOM_LOCATION

ERROR secuitry checksum Session State Protection ---> unrestricted //to avoid error
-----------------------------------------id auto list---------------------------------
SELECT MEETING_ROOM_ID d,MEETING_ROOM_ID r 
FROM MEETING_ROOMS where ROOM_NAME = :P15_MEETING_ROOM_NAME;

-------------------in defult ---------------------------------
select FIRSTNAME ||||" "|| lastname  from users where ID = :APP_USER;
------------------------------constraint for dat check----------------


ALTER TABLE BOOKING_REQUESTS
ADD CONSTRAINT Meeting_booking_for_one_day
CHECK (TRUNC(MEETING_START_TIME) = TRUNC(MEETING_END_TIME));


------------------pl/sql--process----insert automatic roomid ---

BEGIN
    INSERT INTO booking_requests (MEETING_ROOM_ID)
    SELECT MEETING_ROOM_ID
    FROM MEETING_ROOMS 
    WHERE MEETING_ROOM_LOCATION = :P15_MEETING_ROOM_LOCATION
    AND ROOM_NAME = :P15_MEETING_ROOM_NAME;
    
    -- Commit the transaction if needed
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if necessary
        NULL;
END;
-------------------------------


CREATE OR REPLACE FUNCTION USER_AUTH_FUNC (
    P_USERNAME IN VARCHAR2,
    P_PASSWORD IN VARCHAR2
)
RETURN BOOLEAN
AS
    MVAL NUMBER := 0;
BEGIN
    
    SELECT 1 INTO MVAL
    FROM USERS A
    WHERE UPPER(A.ID) = UPPER(P_USERNAME) -- Ensuring case-insensitivity by converting to upper case
          AND A.PASSWORD = P_PASSWORD     -- Checking if password matches
          AND A.USER_STATUS = 'Y';        -- Check if user is active

    
    RETURN TRUE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        
        RETURN FALSE;
END;



--------------------------------

CHECK (status IN ('Pending', 'Manager_Approved', 'Rejected', 'Admin_Approved')),

-----------updated by ------

DECLARE
    v_fullname users.firstname%TYPE;
BEGIN

    -- GET
    SELECT FIRSTNAME || ' ' || LASTNAME INTO v_fullname
    FROM users 
    WHERE ID = :APP_USER;

    -- ASSIGN
    :P15_UPDATED_BY := :APP_USER || ' - ' || v_fullname;
    :P15_UPDATED_ON := SYSDATE;
END;



:P15_UPDATED_ON := SYSDATE;

-----------DRAG AND DROP PL---------

begin

   update BOOKING_REQUESTS

     set "MEETING_START_TIME" =  to_date(:APEX$NEW_START_DATE, 'YYYYMMDDHH24MISS'),
         "MEETING_END_TIME" = to_date(:APEX$NEW_END_DATE, 'YYYYMMDDHH24MISS')
   where REQUEST_ID = :APEX$PK_VALUE;

end;

-----------DRAG AND DROP PL---------only admens--------------
BEGIN
    UPDATE BOOKING_REQUESTS
    SET MEETING_START_TIME = TO_DATE(:APEX$NEW_START_DATE, 'YYYYMMDDHH24MISS'),
        MEETING_END_TIME = TO_DATE(:APEX$NEW_END_DATE, 'YYYYMMDDHH24MISS')
    WHERE REQUEST_ID = :APEX$PK_VALUE
    AND 'ID' IN (SELECT Id FROM users WHERE ROLE = 'Admin' AND ID = v('APP_USER'));
END;


=======================================================================================
-----groups roles in database view right  change second line (Role>>>>to admin or Manager or user)------------------

select v('APP_USER') from dual

where v('APP_USER') in (select Id from users where Role ='Admin');

===========================================================================
where username=v('APP_USER')
Edit1: for performance constraints, it is always recommended that you do it like this:

where username=(select v('APP_USER') from dual)

---------------------------------calendar updates only or admins and developers--plS-------------------------
BEGIN
    UPDATE BOOKING_REQUESTS
    SET MEETING_START_TIME = TO_DATE(:APEX$NEW_START_DATE, 'YYYYMMDDHH24MISS'),
        MEETING_END_TIME = TO_DATE(:APEX$NEW_END_DATE, 'YYYYMMDDHH24MISS')
    WHERE REQUEST_ID = :APEX$PK_VALUE
    AND EXISTS (
        SELECT 1 
        FROM users 
        WHERE (ROLE = 'Admin' OR ROLE = 'Developer') 
        AND ID = v('APP_USER')
    );
END;
-------------------------------------graph colours name appearance with ----------------------------------------------------------

SELECT 
    STATUS,
    COUNT(*) AS COUNT,
    CASE
        WHEN STATUS = 'Pending' THEN 'blue'
        WHEN STATUS = 'Manager_Approved' THEN 'orange'
        WHEN STATUS = 'Admin_Approved' THEN 'green'
        WHEN STATUS = 'Rejected' THEN 'red'
    END AS css_classs
FROM 
    BOOKING_REQUESTS
GROUP BY 
    STATUS

--------------------booking overlap validation no rows return ---*ture*validation will not run------------------

SELECT 1
FROM booking_requests
WHERE status = 'Admin_Approved'
  AND meeting_room_name = :P15_MEETING_ROOM_NAME
  AND meeting_room_location = :P15_MEETING_ROOM_LOCATION
  AND :P15_STATUS = 'Admin_Approved'
  AND (
      TO_TIMESTAMP(:P15_MEETING_START_TIME, 'DD-MON-YYYY HH:MI PM') BETWEEN meeting_start_time AND meeting_end_time
      OR TO_TIMESTAMP(:P15_MEETING_END_TIME, 'DD-MON-YYYY HH:MI PM') BETWEEN meeting_start_time AND meeting_end_time
      OR meeting_start_time BETWEEN TO_TIMESTAMP(:P15_MEETING_START_TIME, 'DD-MON-YYYY HH:MI PM') AND TO_TIMESTAMP(:P15_MEETING_END_TIME, 'DD-MON-YYYY HH:MI PM')
      OR meeting_end_time BETWEEN TO_TIMESTAMP(:P15_MEETING_START_TIME, 'DD-MON-YYYY HH:MI PM') AND TO_TIMESTAMP(:P15_MEETING_END_TIME, 'DD-MON-YYYY HH:MI PM') )


---------------------user calender update pending and roles user or manager or developer-----
BEGIN
    UPDATE BOOKING_REQUESTS br
    SET MEETING_START_TIME = TO_DATE(:APEX$NEW_START_DATE, 'YYYYMMDDHH24MISS'),
        MEETING_END_TIME = TO_DATE(:APEX$NEW_END_DATE, 'YYYYMMDDHH24MISS')
    WHERE br.REQUEST_ID = :APEX$PK_VALUE
    AND (br.STATUS = 'Pending')
    AND EXISTS (
        SELECT 1
        FROM users u
        WHERE (u.ROLE = 'User' OR u.ROLE = 'Developer' OR u.ROLE = 'Manager')
        AND u.ID = v('APP_USER')
        AND u.ID = br.USER_ID
    );
END;

----------------available slots report query-----------------------
WITH all_slots AS (
    SELECT 
        ts AS time_slot,
        mr.MEETING_ROOM_ID,
        mr.ROOM_NAME,
        mr.MEETING_ROOM_LOCATION
    FROM (
        SELECT
            (TRUNC(SYSDATE) + (LEVEL - 1) / 48) AS ts
        FROM 
            DUAL
        CONNECT BY 
            LEVEL <= (TO_DATE('04-01-2024', 'MM-DD-YYYY') - TO_DATE('01-01-2024', 'MM-DD-YYYY')) * 48
    )
    CROSS JOIN MEETING_ROOMS mr
    WHERE 
        TO_CHAR(ts, 'HH24:MI') BETWEEN '09:00' AND '17:30'
),
booked_slots AS (
    SELECT 
        MEETING_START_TIME,
        MEETING_END_TIME,
        MEETING_ROOM_ID
    FROM 
        BOOKING_REQUESTS
    WHERE 
        STATUS = 'Admin_Approved' OR STATUS = 'Manager_Approved'
),
available_slots AS (
    SELECT 
        s.time_slot,
        s.MEETING_ROOM_ID,
        s.ROOM_NAME,
        s.MEETING_ROOM_LOCATION
    FROM 
        all_slots s
    LEFT JOIN 
        booked_slots b 
    ON 
        s.time_slot BETWEEN b.MEETING_START_TIME AND b.MEETING_END_TIME
        AND s.MEETING_ROOM_ID = b.MEETING_ROOM_ID
    WHERE 
        b.MEETING_START_TIME IS NULL
)
SELECT 
    TO_CHAR(time_slot, 'DD-MON-YYYY HH:MI PM') AS formatted_time_slot,
    ROOM_NAME,
    MEETING_ROOM_LOCATION
FROM 
    available_slots
WHERE 
    (:P31_MEETING_ROOM_LOCATION IS NULL OR MEETING_ROOM_LOCATION = :P31_MEETING_ROOM_LOCATION)
    
    AND (:P31_ROOM_NAME IS NULL OR ROOM_NAME = :P31_ROOM_NAME)


-----


 