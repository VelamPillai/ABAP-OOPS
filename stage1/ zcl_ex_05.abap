CLASS zcl_ex_05_vp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ex_05_vp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TYPES:BEGIN OF ty_db_person,
            id    TYPE i,
            fname TYPE string,
            lname TYPE string,
            age   TYPE i,
            insurance type string,

          END OF ty_db_person.
    DATA db TYPE HASHED TABLE OF ty_db_person WITH UNIQUE KEY id.

    db = VALUE #(
                                ( id = 1 fname = 'ana' lname = 'jegan' age = 21 insurance = 'true' )
                                ( id = 2 fname = 'ashu' lname = 'jegan' age = 31   insurance = 'false' )
                                ( id = 3 fname = 'jegan' lname = 'pillai' age = 21 insurance = 'true' ) ).

    TYPES: BEGIN OF ty_dto_person,
             person_id TYPE i,
             first     TYPE string,
             last      TYPE string,
             age       TYPE i,
             salary    TYPE i,
           END OF ty_dto_person.
    DATA dto TYPE HASHED TABLE OF ty_dto_person WITH UNIQUE KEY person_id.
    dto = CORRESPONDING #( db
                          MAPPING  person_id = id
                                   first    = fname
                                   last    = lname  " age matches by name automatically
                          EXCEPT salary ).

    LOOP AT dto INTO DATA(wa_dto).
      out->write( | id : { wa_dto-person_id } , firstname : { wa_dto-first } , lastname : {  wa_dto-last } , age : {  wa_dto-age } , salary : { wa_dto-salary }| ).
    ENDLOOP.



  ENDMETHOD.

ENDCLASS.