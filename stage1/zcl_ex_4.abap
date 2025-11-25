CLASS zcl_person_vp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_person_vp IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
**********************************************************************
* TITLE : table Expression , usage of field symbol
**********************************************************************





"-------------------------------
" 1️⃣ Define structure and table
"-------------------------------
TYPES: BEGIN OF ty_table,
         id   TYPE i,
         name TYPE string,
       END OF ty_table.

" SORTED TABLE with UNIQUE key → required for OPTIONAL
DATA it_table TYPE SORTED TABLE OF ty_table WITH UNIQUE KEY id.

"-------------------------------
" 2️⃣ Fill the table using VALUE
"-------------------------------
it_table = VALUE #(
  ( id = 10  name = 'kavi' )
  ( id = 2   name = 'ANA' )
  ( id = 100 name = 'vel' )
  ( id = 233 name = 'muthu' )
  ( id = 999 name = 'vela' )
).

FiELD-SYMBOLS <fs_symbol> tYPE ty_table.

"-------------------------------
" 4️⃣ Loop through IDs safely
"-------------------------------
  types: BEGIN OF ty_id, id type i , end OF ty_id.
  data it_id type standard table of ty_id with emPTY KEY .
  it_id = value #( ( id = 10 ) ( id = 999 ) ( id = 123 ) ).


  " Table expression with OPTIONAL → safe read
  LOOP AT it_id inTO data(lv_id).

  ASSIGN it_table[ id = lv_id-id ] to <fs_symbol> .

  IF <fs_symbol> IS ASSIGNED.
    out->write( |ID: { <fs_symbol>-id }, Name: { <fs_symbol>-name }| ).

  ELSE.
    out->write( |ID : { lv_id-id } not found| ).
  ENDIF.
   UNASSIGN <fs_symbol>.
  ENDLOOP.





  ENDMETHOD.
ENDCLASS.