CLASS zcl_ex_4_1_vp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ex_4_1_vp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TYPES: BEGIN OF ty_connection,
             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             distance      TYPE /dmo/flight_distance,
           END OF ty_connection.
*    types tty_connection type staNDARD TABLE OF ty_connection with dEFAULT KEY.
    DATA it_connection TYPE STANDARD TABLE OF ty_connection WITH NON-UNIQUE SORTED KEY distance COMPONENTS distance.

    try.

        SELECT
        FROM /dmo/connection
        FIELDS carrier_id, connection_id,distance
        INTO TABLE @it_connection.

        out->write( | source rows : { lines( it_connection ) }| ). "lines(table name) gives no of rows in the table
    catch cx_root INTO daTA(lx_any1).
        out->write(  | error : { lx_any1->get_text(  ) }| ).
        out->write( | error : { lx_any1->get_longtext( )  } | ).
    ENDTRY.



**********************************************************************
*title : Filter connection lesser than 1000 km
**********************************************************************

    "here distance is a secondary key .that key we have declared to speed up the searching process .the control will go directly to the corresponding row.,which field we are using , same field we have choose as a key for filter constructor.


    try.
        DATA(it_carrier_lh) = FILTER #( it_connection
                                                 USING KEY distance
                                                 WHERE distance < CONV /DMO/flight_distance( 4000 ) ).

       IF sy-subrc IS INITIAL.
        out->write( data = it_carrier_lh name = 'flight details which distance less than 1000km' ).
       ELSE.
        out->write( 'no row selected' ).
       ENDIF.

    catch cx_root into data(lx_any).
        out->write(  | error : { lx_any->get_text(  ) }| ).
        out->write( | error : { lx_any->get_longtext( )  } | ).
    ENDTRY.


  ENDMETHOD.
ENDCLASS.