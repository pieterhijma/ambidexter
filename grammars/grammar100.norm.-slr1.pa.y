%token IS
%token BY
%token ORDER
%token DATE
%token PRECISION
%token DOUBLE
%token INTEGER
%token INT
%token VARCHAR
%token NULL_VALUE
%token DROP
%token CREATE
%token TTABLE
%token ALTER
%token NOT
%token OR
%token AND
%token SET
%token UPDATE
%token VALUES
%token INTO
%token INSERT
%token DELETE
%token WHERE
%token FROM
%token SELECT
%token EQUAL
%token COLUMN
%token ADD
%token FLOATNUM
%token INTNUM
%token STRING
%token NAME
%token COMPARISON_OPERATOR

%%

y_sql :  y_select
|  y_insert
|  y_drop
|  y_create
|  y_delete
|  y_alter
|  y_update
;

y_value_list :  NULL_VALUE
|  FLOATNUM
|  y_value_list ',' '-' FLOATNUM
|  INTNUM
|  y_value_list ',' '-' INTNUM
|  y_value_list ',' NULL_VALUE
|  STRING
|  '-' FLOATNUM
|  y_value_list ',' FLOATNUM
|  '-' INTNUM
|  y_value_list ',' INTNUM
|  y_value_list ',' STRING
;

y_assignments :  y_assignment
|  y_assignments ',' y_assignment
;

y_columndef :  NAME INT
|  NAME VARCHAR '(' INTNUM ')'
|  NAME DOUBLE PRECISION
|  NAME DATE
|  NAME DOUBLE
|  NAME INTEGER
;

y_table :  NAME
;

y_assignment :  NAME EQUAL NULL_VALUE
|  NAME EQUAL y_expression
;

y_delete :  DELETE FROM y_table
|  DELETE FROM y_table WHERE y_condition
;

y_column :  NAME
;

y_values :  VALUES '(' y_value_list ')'
;

y_column_list :  NAME
|  y_column_list ',' NAME
;

y_value :  FLOATNUM
|  INTNUM
|  STRING
;

y_update :  UPDATE y_table SET y_assignments
|  UPDATE y_table SET y_assignments WHERE y_condition
;

y_select :  SELECT y_columns FROM y_table ORDER BY y_order
|  SELECT y_columns FROM y_table
|  SELECT y_columns FROM y_table WHERE y_condition
|  SELECT y_columns FROM y_table WHERE y_condition ORDER BY y_order
;

y_comparison :  y_expression COMPARISON_OPERATOR y_expression
|  y_expression EQUAL y_expression
|  y_expression IS NULL_VALUE
|  y_expression NOT NULL_VALUE
;

y_atom :  y_column
|  y_value
|  '(' y_expression ')'
;

y_insert :  INSERT INTO y_table '(' y_columns ')' y_values
|  INSERT INTO y_table y_values
;

y_order :  NAME
;

y_boolean :  NOT y_boolean
|  y_comparison
|  '(' y_sub_condition ')'
;

y_drop :  DROP TTABLE y_table
;

y_condition :  y_sub_condition
;

y_create :  CREATE TTABLE y_table '(' y_columndefs ')'
;

y_term :  '-' y_term
|  y_atom
;

y_columns :  y_column_list
|  '*'
;

y_sub_condition2 :  y_sub_condition2 AND y_boolean
|  y_boolean
;

y_alter :  ALTER TTABLE y_table ADD COLUMN y_columndef
|  ALTER TTABLE y_table ADD y_columndef
;

y_sub_condition :  y_sub_condition2
|  y_sub_condition OR y_sub_condition2
;

y_columndefs :  y_columndef
|  y_columndefs ',' y_columndef
;

y_expression :  y_product
|  y_expression '+' y_product
|  y_expression '-' y_product
;

y_product :  y_product '/' y_term
|  y_term
|  y_product '*' y_term
;
