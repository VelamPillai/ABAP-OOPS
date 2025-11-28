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
    TYPES tty_connection TYPE STANDARD TABLE OF ty_connection WITH DEFAULT KEY.
    DATA it_connection TYPE STANDARD TABLE OF ty_connection WITH NON-UNIQUE SORTED KEY distance COMPONENTS distance.

    TRY.

        SELECT
        FROM /dmo/connection
        FIELDS carrier_id, connection_id,distance
        INTO TABLE @it_connection.

        out->write( | source rows : { lines( it_connection ) }| ). "lines(table name) gives no of rows in the table
      CATCH cx_root INTO DATA(lx_any1).
        out->write(  | error : { lx_any1->get_text(  ) }| ).
        out->write( | error : { lx_any1->get_longtext( )  } | ).
    ENDTRY.



**********************************************************************
*title : Filter connection lesser than 1000 km
**********************************************************************

    "here distance is a secondary key .that key we have declared to speed up the searching process .the control will go directly to the corresponding row.,which field we are using , same field we have choose as a key for filter constructor.


    TRY.
        DATA(it_carrier_lh) = FILTER #( it_connection
                                                 USING KEY distance
                                                 WHERE distance < CONV /DMO/flight_distance( 4000 ) ).

        IF sy-subrc IS INITIAL.
          out->write( data = it_carrier_lh name = 'flight details which distance less than 1000km' ).
        ELSE.
          out->write( 'no row selected' ).
        ENDIF.

      CATCH cx_root INTO DATA(lx_any).
        out->write(  | error : { lx_any->get_text(  ) }| ).
        out->write( | error : { lx_any->get_longtext( )  } | ).
    ENDTRY.

**********************************************************************
*title : make table of lower case carrier id
**********************************************************************
    TRY.

        DATA(it_carrier_lower) = VALUE tty_connection( FOR <fs> IN it_carrier_lh ( carrier_id = to_lower( <fs>-carrier_id )
                                                                      connection_id = <fs>-connection_id
                                                                      distance = <fs>-distance  ) ).
        IF sy-subrc IS INITIAL.
          out->write( data = it_carrier_lower name = 'flight details with lower case carrier id' ).
        ELSE.
          out->write( 'no row selected' ).
        ENDIF.

      CATCH cx_root INTO DATA(lx_any2).
        out->write(  | error : { lx_any2->get_text(  ) }| ).
        out->write( | error : { lx_any2->get_longtext( )  } | ).
    ENDTRY.
**********************************************************************
*title:reduce sume of distance
**********************************************************************

    TRY.

        DATA(total_distance) = REDUCE i( INIT total = 0
                                     FOR <fs1> IN it_carrier_lower
                                     NEXT total += <fs1>-distance   ).
        IF sy-subrc IS INITIAL.
          out->write( data =  total_distance name = 'total flight distance' ).
        ELSE.
          out->write( 'no row selected' ).
        ENDIF.

      CATCH cx_root INTO DATA(lx_any3).
        out->write(  | error : { lx_any3->get_text(  ) }| ).
        out->write( | error : { lx_any3->get_longtext( )  } | ).
    ENDTRY.
**********************************************************************
*title : combine reduce , filter , for in .
**********************************************************************
    TRY.
        DATA(total_dist) =  REDUCE i(
                                 INIT total_1 = 0
                                 FOR <fs2> IN VALUE tty_connection(
                                     FOR <fs3> IN FILTER #( it_connection USING KEY distance WHERE distance > 6000 )
                                        ( carrier_id = to_lower( <fs3>-carrier_id )
                                        connection_id = <fs3>-connection_id
                                        distance = <fs3>-distance )  )
                                 NEXT total_1 += total_1 + <fs2>-distance ).
        out->write( data =  total_dist name = 'total flight distance' ).


      CATCH cx_root INTO DATA(lx_any4).
        out->write(  | error : { lx_any4->get_text(  ) }| ).
        out->write( | error : { lx_any4->get_longtext( )  } | ).
    ENDTRY.

**********************************************************************
*title : filter the name start with particular character
**********************************************************************

    TYPES:BEGIN OF ty_airport,
            airport_id TYPE /dmo/airport_id,
            name       TYPE /dmo/airport_name,
            city       TYPE /dmo/city,
          END OF ty_airport.
    TYPES tty_airport TYPE STANDARD TABLE OF ty_airport WITH DEFAULT KEY.
    DATA it_airport TYPE STANDARD TABLE OF ty_airport WITH NON-UNIQUE SORTED KEY city COMPONENTS city.

    TRY.
        SELECT
        FROM /dmo/airport
        FIELDS airport_id,name,city
        INTO TABLE @it_airport.

        out->write( data = it_airport name = 'airport list' ).
      CATCH cx_sy_ITAB_LINE_NOT_FOUND.
        out->write( 'line not found' ).
    ENDTRY.

    FIELD-SYMBOLS <fs_airport> TYPE ty_airport.

*    ASSIGN it_airport[ airport_id = 'vko'  ] TO <fs_airport>.
     ASSIGN it_airport[ airport_id = 'VKO'  ] TO <fs_airport>.
    IF <fs_airport> IS ASSIGNED.
      out->write( data = <fs_airport>-name name = 'airport info' ).
    ELSE.
      out->write( 'Airport VKO not found' ).
    ENDIF.


   "DATA(it_airport_name) = FILTER #( it_airport USING KEY city  WHERE  city = CONV /dmo/city( 'London' ) ).
   DATA(it_airport_name) = FILTER #( it_airport USING KEY city  WHERE  city  =  value #( ( 'London' ) ( 'Newark, New Jersey' ) ) ).
    IF it_airport_name IS NOT INITIAL.
      out->write( data = it_airport_name name = 'airport info only with char A' ).
    ELSE.
      out->write( 'Airports  not found' ).
    ENDIF.


     LOOP AT it_airport INTO DATA(ls_air).
        IF to_lower( ls_air-city ) CP 'L*'.
            out->write( data = ls_air name = 'airport info only with char A' ).
        ENDIF.
    ENDLOOP.


*   




























  ENDMETHOD.
ENDCLASS.