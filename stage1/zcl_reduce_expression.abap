CLASS zcl_reduce_expression_vp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_reduce_expression_vp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES:BEGIN OF ty_price,
            price TYPE i,
          END OF ty_price.

    DATA it_price TYPE SORTED TABLE OF ty_price WITH UNIQUE KEY price.
    data total_price type i.


    it_price = value #( ( price = 23 ) ( price = 56 ) ( price = 123 ) ( price = 223 ) ( price = 213 ) ( price = 523 ) ).


*    out->write( data = it_price name = 'price table' ).

    total_price = REDUCE i( INIT  total = 0
                                         FOR <fs> in it_price
                                         next total = total + <fs>-price  ).

*    out->write( total_price ).


**********************************************************************
*title : using demo table
**********************************************************************

 TYPES:BEGIN OF ty_price_db,
            price TYPE /dmo/supplement_price,
          END OF ty_price_db.

    DATA it_price_db TYPE standard TABLE OF ty_price .
    data total_price_db type i.

    SELECT
    FROM /dmo/a_bksuppl_d
    FIELDS price
    Where price < 15
    INTO TABLE @it_price_db
    UP TO 20 ROWS.


    out->write( data = it_price_db name = 'price table' ).


    total_price_db = REDUCE i( INIT  total = 0
                                         FOR <fs> IN it_price_db
                                         NEXT total = total + <fs>-price  ).

    out->write( total_price_db ).





  ENDMETHOD.
ENDCLASS.