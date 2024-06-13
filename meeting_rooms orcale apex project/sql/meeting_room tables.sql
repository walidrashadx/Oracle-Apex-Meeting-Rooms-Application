  CREATE TABLE "BOOKING_REQUESTS" 
   (	"USER_ID" NVARCHAR2(10) NOT NULL ENABLE, 
	"MEETING_ROOM_ID" NUMBER(3,0), 
	"STATUS" VARCHAR2(20), 
	"CREATED_BY" VARCHAR2(80), 
	"CREATED_ON" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp NOT NULL ENABLE, 
	"UPDATED_BY" VARCHAR2(80), 
	"UPDATED_ON" TIMESTAMP (6) WITH LOCAL TIME ZONE, 
	"MANAGER_APPROVED_ID" NUMBER(5,0), 
	"ADMIN_APPROVED_ID" NUMBER(5,0), 
	"REQUIRED_NUMBER_SEAT" NUMBER(3,0), 
	"MEETING_ROOM_LOCATION" NVARCHAR2(150) NOT NULL ENABLE, 
	"PERIORTY" NUMBER(2,0) NOT NULL ENABLE, 
	"REASON" NVARCHAR2(300), 
	"REQUEST_ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"MEETING_ROOM_NAME" NVARCHAR2(40) NOT NULL ENABLE, 
	"MEETING_START_TIME" TIMESTAMP (9) NOT NULL ENABLE, 
	"MEETING_END_TIME" TIMESTAMP (9) NOT NULL ENABLE, 
	 CONSTRAINT "BOOKING_REQUESTS_CON" PRIMARY KEY ("REQUEST_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "STATUS_CK" CHECK ( "STATUS" IN ('Pending','Manager_Approved','Rejected','Admin_Approved')

 ) ENABLE, 
	 CONSTRAINT "CHECK_TIME_CK" CHECK (MEETING_START_TIME < MEETING_END_TIME) ENABLE, 
	 CONSTRAINT "MEETING_BOOKING_FOR_ONE_DAY" CHECK (TRUNC(MEETING_START_TIME) = TRUNC(MEETING_END_TIME)) ENABLE
   ) ;

  ALTER TABLE "BOOKING_REQUESTS" ADD CONSTRAINT "MEETING_ROOM_ID_FK" FOREIGN KEY ("MEETING_ROOM_ID")
	  REFERENCES "MEETING_ROOMS" ("MEETING_ROOM_ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "BOOKING_REQUESTS" ADD CONSTRAINT "USER_ID_FK" FOREIGN KEY ("USER_ID")
	  REFERENCES "USERS" ("ID") ON DELETE CASCADE ENABLE;

  CREATE TABLE "MEETING_ROOMS" 
   (	"MEETING_ROOM_ID" NUMBER(3,0), 
	"ROOM_NAME" NVARCHAR2(40), 
	"MEETING_ROOM_LOCATION" NVARCHAR2(150), 
	"ROOM_CAPACITY" NUMBER(5,0), 
	 CONSTRAINT "MEETING_ROOMS_PK" PRIMARY KEY ("MEETING_ROOM_ID")
  USING INDEX  ENABLE
   ) ;


  CREATE TABLE "USERS" 
   (	"FIRSTNAME" NVARCHAR2(29) NOT NULL ENABLE, 
	"LASTNAME" NVARCHAR2(20) NOT NULL ENABLE, 
	"EMAIL" NVARCHAR2(70) NOT NULL ENABLE, 
	"USER_LOCATION" NVARCHAR2(150) NOT NULL ENABLE, 
	"JOB_TITLE" NVARCHAR2(100) NOT NULL ENABLE, 
	"ROLE" VARCHAR2(10), 
	"ID" NVARCHAR2(10), 
	"PASSWORD" NVARCHAR2(128) NOT NULL ENABLE, 
	"USER_STATUS" CHAR(1), 
	"MANAGER_ID" NUMBER(5,0), 
	"ADMIN_ID" NUMBER(5,0), 
	 CONSTRAINT "USERS_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "EMAIL_UNI" UNIQUE ("EMAIL")
  USING INDEX  ENABLE
   ) ;
