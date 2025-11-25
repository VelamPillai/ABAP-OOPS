CLASS zcl_counter_vp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_counter_vp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    data(lv_count) = lcl_count=>get_count(  ).
    out->write( |count : { lv_count }| ).
    lv_count = lcl_count=>get_count(  ).
    out->write( |count : { lv_count }| ).
    data(lv_count1) = lcl_count=>get_count(  ).
    out->write( |count : { lv_count1 }| ).

    lv_count = lcl_count=>get_count(  ).
    out->write( |count : { lv_count }| ).

    data(lv_count2) = lcl_count=>get_count(  ).
    out->write( |count : { lv_count2 }| ).

  ENDMETHOD.
ENDCLASS.


*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_count definition create private.

  public section.
    clasS-DATA count type i rEAD-ONLY.
    class-METHODS get_count
                    ReTURNING VALUE(r_count) type i.
  protected section.
  private section.

endclass.

class lcl_count implementation.

  method get_count.
      count += 1.
      r_count = count.

  endmethod.

endclass.