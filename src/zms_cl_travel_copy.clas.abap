CLASS zms_cl_travel_copy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zms_cl_travel_copy IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: lt_travel TYPE STANDARD TABLE OF zms_db_travel.

    SELECT client, travel_id, description, total_price, currency_code,
    CASE
      WHEN status = 'N' THEN 'O'
      WHEN status = 'P' THEN 'O'
      WHEN status = 'B' THEN 'A'
      ELSE 'X'
      END AS status
    FROM /dmo/travel
    INTO TABLE @lt_travel.
    IF lt_travel IS NOT INITIAL.
      "Refresh the existing data if any.
      DELETE zms_db_travel FROM TABLE @lt_travel.
      "Populate the new data.
      INSERT zms_db_travel FROM TABLE @lt_travel.
      IF sy-subrc IS INITIAL.
        DATA(lv_message) = |'Data inserted successfully!'- { sy-dbcnt }|.
        out->write( lv_message ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
