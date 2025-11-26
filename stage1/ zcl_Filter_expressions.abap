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

    TYPES: tty_carrier_db TYPE STANDARD TABLE OF ty_carrier_db WITH DEFAULT KEY.
    DATA: it_carrier_db TYPE  STANDARD TABLE OF  ty_carrier_db WITH NON-UNIQUE SORTED KEY carrier COMPONENTS carrier_id.

    SELECT
    FROM /dmo/connection
    FIELDS carrier_id, connection_id, distance
    WHERE carrier_id IN ( 'LH', 'UA' , 'AA' ) "selects the row only with this range of values
    INTO TABLE @it_carrier_db
    UP TO 15 ROWS.     "only 15 rows of the master table can be selected for this operation.

    IF sy-subrc IS INITIAL.
      out->write( data = it_carrier_db name = 'iternal table from main table connection' ).

      "filter operation

      DATA(it_carrier_lh) =
  FILTER tty_carrier_db( it_carrier_db
     USING KEY carrier
     WHERE carrier_id = CONV /DMO/carrier_id( 'LH' ) ).
      out->write( data = it_carrier_lh name = 'filtered table from standard table connection' ).
    ENDIF.

**********************************************************************
*title : filter expression  with sorted table
**********************************************************************

    TYPES: tty_carrier_db_sorted TYPE STANDARD TABLE OF ty_carrier_db WITH DEFAULT KEY.
    DATA: it_carrier_db_sorted TYPE  SORTED TABLE OF  ty_carrier_db WITH NON-UNIQUE KEY carrier_id.

    SELECT
    FROM /dmo/connection
    FIELDS carrier_id, connection_id, distance
    WHERE carrier_id IN ( 'LH', 'UA' , 'AA' ) "selects the row only with this range of values
    INTO TABLE @it_carrier_db_sorted
    UP TO 15 ROWS.     "only 15 rows of the master table can be selected for this operation.

    IF sy-subrc IS INITIAL.
      out->write( data = it_carrier_db_sorted name = 'iternal table from main standard table connection' ).

      "filter operation

      DATA(it_carrier_lh_sorted) =
  FILTER tty_carrier_db_sorted( it_carrier_db_sorted
     WHERE carrier_id = CONV /DMO/carrier_id( 'LH' ) ).
      out->write( data = it_carrier_lh_sorted name = 'filtered table from main sorted table connection' ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.