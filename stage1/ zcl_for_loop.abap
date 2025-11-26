CLASS zcl_for_loop_vp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_for_loop_vp IMPLEMENTATION.



  METHOD if_oo_adt_classrun~main.

**********************************************************************
* title: like MAP in jS
*description: copy entire tale to another table
**********************************************************************

    DATA it_connection_copy_map TYPE TABLE OF /dmo/connection.

    SELECT
    FROM /dmo/connection
    FIELDS *
    INTO TABLE @DATA(it_connection_map).


    it_connection_copy_map = VALUE #( FOR <fs> IN it_connection_map (  <fs> ) ).

*    out->write( data = it_connection_copy_map name = 'flight info table' ).

**********************************************************************
* title: copy some of the fields from one internal table to another internal table
**********************************************************************

    TYPES: BEGIN OF ty_flight_info,
             airport_from_id TYPE /DMO/airport_from_id,
             airport_to_id   TYPE /DMO/airport_to_id,
             arrival_time    TYPE /dmo/flight_arrival_time,
             carrier_id      TYPE /DMO/carrier_id,
           END OF ty_flight_info.

    DATA:lt_flight_info TYPE TABLE OF ty_flight_info.

    SELECT
    FROM /dmo/connection
    FIELDS *
    INTO TABLE @DATA(lt_connection).

    lt_flight_info = VALUE #(  FOR <fs> IN lt_connection   ( airport_from_id =  <fs>-airport_from_id
                                                             airport_to_id = <fs>-airport_to_id
                                                             arrival_time = <fs>-airport_from_id
                                                             carrier_id = <fs>-carrier_id ) ).
*    out->write( data = lt_flight_info name = 'flight info table' ).

**********************************************************************
* title: copy some of the fields from one internal table to another internal table based on some conditions
**********************************************************************



*    SELECT
*    FROM /dmo/connection
*    FIELDS *
*    INTO TABLE @DATA(lt_connection).
*
*    lt_flight_info = VALUE #(  FOR <fs> IN lt_connection where ( airport_from_id = 'NRT' ) ( airport_from_id =  <fs>-airport_from_id
*                                                                     airport_to_id = <fs>-airport_to_id
*                                                                     arrival_time = <fs>-airport_from_id
*                                                                     carrier_id = <fs>-carrier_id ) ).
*
*   out->write( data = lt_flight_info name = 'flight info table' ).


**********************************************************************
* title : using corresponding instead of writing all field names
**********************************************************************
    TYPES: BEGIN OF ty_tab_corresponding,
             airport_from_id TYPE /DMO/airport_from_id,
             arrival_time    TYPE /DMO/flight_arrival_time,
             connection_id   TYPE /DMO/connection_id,
             carrier_id      TYPE /DMO/carrier_id,
           END OF ty_tab_corresponding.

    DATA: it_tab_corresponding TYPE STANDARD TABLE OF ty_tab_corresponding.


    SELECT
    FROM /dmo/connection
    FIELDS airport_from_id,arrival_time,connection_id,carrier_id
    INTO TABLE @DATA(it_connection_corresponding).

    it_tab_corresponding = VALUE #(  FOR <fs1> IN it_connection_corresponding
                                     WHERE (  airport_from_id = 'NRT' )
                                     ( CORRESPONDING #( <fs1> ) ) ).
*   out->write( data = it_tab_corresponding name = 'flight info table' ).

**********************************************************************
* title: field order are different
**********************************************************************
    TYPES: BEGIN OF ty_tab_corresponding1,
             arrival_time    TYPE /DMO/flight_arrival_time,
             carrier_id      TYPE /DMO/carrier_id,
             airport_from_id TYPE /DMO/airport_from_id,
             connection_id   TYPE /DMO/connection_id,
           END OF ty_tab_corresponding1.

    DATA: it_tab_corresponding1 TYPE STANDARD TABLE OF ty_tab_corresponding1.


*   it_tab_corresponding1 = value #(  FOR <fs1> IN it_connection_corresponding
*                                     WHERE (  airport_from_id = 'NRT' )
*                                     ( CORRESPONDING #( <fs1> ) ) ).

    it_tab_corresponding1 = VALUE #(  FOR <fs1> IN it_connection_corresponding
                                     ( CORRESPONDING #( <fs1> ) ) ).
*    out->write( data = it_tab_corresponding1 name = 'flight info table' ).
**********************************************************************
* title :preparing range table from internal table
**********************************************************************
    DATA it_range_connectioid TYPE RANGE OF /DMO/connection_id.
    SORT it_tab_corresponding1 BY connection_id.
    DELETE ADJACENT DUPLICATES FROM it_tab_corresponding1 COMPARING connection_id.

    it_range_connectioid = VALUE #( FOR <fs2> IN it_tab_corresponding1 (  sign = 'I' option = 'LT'   low = <fs2>-connection_id ) ).

*    out->write( data = it_range_connectioid name = 'range of connection id' ).
**********************************************************************
*title : adding additional field along with the field extracted from the internal table
**********************************************************************

    types :BEGIN OF ty_connection_db,
                    connection_id type /DMO/connection_id,
                    carrier_id type /dmo/carrier_id,
                    date type d,
                    EnD OF ty_connection_db.


    data : it_connection_db type stANDARD TABLE OF ty_connection_db.

    it_connection_db = value #( for <fs3> in it_connection_copy_map
                                let ls_base = value ty_connection_db( date = sy-datum )
                                in ( CORRESPONDING #( base ( ls_base ) <fs3> ) ) ).

*    out->write( data = it_connection_db name = 'adding date field' ).


**********************************************************************
*title : normal for loop
**********************************************************************
    tyPES: BEGIN OF ty_tab,
           number type i,
           square type i,
           cube type i,
           END OF ty_tab.
    data : it_tab type staNDARD TABLE OF ty_tab.

    it_tab = value #( for i = 0 then i + 1  while i lt 10
                       ( number = i  square = i * i cube = i * i * i ) ).

    out->write( data = it_tab name = 'normal for loop' ).


  ENDMETHOD.
ENDCLASS. 