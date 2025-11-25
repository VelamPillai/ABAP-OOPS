CLASS zcl_test_vp_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: name TYPE string,
          age  TYPE i.
    CLASS-DATA: counter TYPE i VALUE 0.
    METHODS constructor
      IMPORTING i_name TYPE string OPTIONAL
                i_age  TYPE i OPTIONAL.
    METHODS show
      RETURNING VALUE(output) TYPE string.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_test_vp_1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    data lo_person type ref tO zcl_test_vp_1.
*    lo_person = NEW zcl_test_vp_1(  i_name = 'ana' i_age = 21 ).


    DATA(lo_person) = NEW zcl_test_vp_1(  i_name = 'ana' i_age = 21 ). "inline data declaration method
    IF lo_person IS BOUND.
      DATA(lv_output) = lo_person->show(  ).
      out->write( lv_output ).
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    name = i_name.
    age = i_age.

  ENDMETHOD.

  METHOD show.
    output = | name : { name } , age : { age } |.

  ENDMETHOD.

ENDCLASS.