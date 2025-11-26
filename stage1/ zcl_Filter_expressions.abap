CLASS zcl_modern_expressions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_modern_expressions IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
**********************************************************************
*title : filter expression  with standard table
**********************************************************************

    TYPES :BEGIN OF ty_carrier_db,
             carrier_id    TYPE /DMO/carrier_id,
             connection_id TYPE /DMO/connection_id,
             distance      TYPE /dmo/flight_distance,
           END OF ty_carrier_db.

    types: tty_carrier_db tyPE staNDARD TABLE OF ty_carrier_db with DEFAULT KEY.
    DATA: it_carrier_db type  stanDARD TABLE OF  ty_carrier_db WITH NON-UNIQUE SORTED KEY carrier components carrier_id.

    SELECT
    FROM /dmo/connection
    FIELDS carrier_id, connection_id, distance
    WhERE carrier_id iN ( 'LH', 'UA' , 'AA' ) "selects the row only with this range of values
    INTO TABLE @it_carrier_db
    uP TO 15 rOWS.     "only 15 rows of the master table can be selected for this operation.

    if sy-subrc is INITIAL.
*        out->write( data = it_carrier_db name = 'iternal table from main table connection' ).

    "filter operation

        DATA(it_carrier_lh) =
    FILTER tty_carrier_db( it_carrier_db
       USING KEY carrier
       WHERE carrier_id = CONV /DMO/carrier_id( 'LH' ) ).
*         out->write( data = it_carrier_lh name = 'iternal table from main table connection' ).
    EndIF.

**********************************************************************
*title : filter expression  with sorted table
**********************************************************************

types: tty_carrier_db_sorted tyPE staNDARD TABLE OF ty_carrier_db with DEFAULT KEY.
    DATA: it_carrier_db_sorted type  soRTED TABLE OF  ty_carrier_db WITH NON-UNIQUE KEY carrier_id.

    SELECT
    FROM /dmo/connection
    FIELDS carrier_id, connection_id, distance
    WhERE carrier_id iN ( 'LH', 'UA' , 'AA' ) "selects the row only with this range of values
    INTO TABLE @it_carrier_db_sorted
    uP TO 15 rOWS.     "only 15 rows of the master table can be selected for this operation.

    if sy-subrc is INITIAL.
        out->write( data = it_carrier_db_sorted name = 'iternal table from main table connection' ).

    "filter operation

        DATA(it_carrier_lh_sorted) =
    FILTER tty_carrier_db_sorted( it_carrier_db_sorted
       WHERE carrier_id = CONV /DMO/carrier_id( 'LH' ) ).
         out->write( data = it_carrier_lh_sorted name = 'iternal table from main table connection' ).
    EndIF.


  ENDMETHOD.
ENDCLASS.