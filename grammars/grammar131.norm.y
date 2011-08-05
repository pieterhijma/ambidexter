
%token   PLUS_TK         MINUS_TK        MULT_TK         DIV_TK    REM_TK
%token   LS_TK           SRS_TK          ZRS_TK
%token   AND_TK          XOR_TK          OR_TK
%token   BOOL_AND_TK BOOL_OR_TK
%token   EQ_TK NEQ_TK GT_TK GTE_TK LT_TK LTE_TK


%token   MODIFIER_TK


%token   DECR_TK INCR_TK



%token   DEFAULT_TK      IF_TK              THROW_TK
%token   BOOLEAN_TK      DO_TK              IMPLEMENTS_TK
%token   THROWS_TK       BREAK_TK           IMPORT_TK
%token   ELSE_TK         INSTANCEOF_TK      RETURN_TK
%token   VOID_TK         CATCH_TK           INTERFACE_TK
%token   CASE_TK         EXTENDS_TK         FINALLY_TK
%token   SUPER_TK        WHILE_TK           CLASS_TK
%token   SWITCH_TK       TRY_TK
%token   FOR_TK          NEW_TK             CONTINUE_TK
%token   PACKAGE_TK         THIS_TK
%token   ASSERT_TK

%token   INTEGRAL_TK

%token   FP_TK

%token   ID_TK

%token   REL_QM_TK         REL_CL_TK NOT_TK  NEG_TK

%token   ASSIGN_ANY_TK   ASSIGN_TK
%token   OP_TK  CP_TK  OCB_TK  CCB_TK  OSB_TK  CSB_TK  SC_TK  C_TK DOT_TK

%token   STRING_LIT_TK   CHAR_LIT_TK        INT_LIT_TK        FP_LIT_TK
%token   BOOL_LIT_TK       NULL_TK

%%


goal:  compilation_unit
		
;


literal:
	INT_LIT_TK
|	FP_LIT_TK
|	BOOL_LIT_TK
|	CHAR_LIT_TK
|       STRING_LIT_TK
|       NULL_TK
;


type:
	primitive_type
|	reference_type
;

primitive_type:
	INTEGRAL_TK
|	FP_TK
|	BOOLEAN_TK
;

reference_type:
	class_or_interface_type
|	array_type
;

class_or_interface_type:
	name
;

class_type:
	class_or_interface_type	
;

interface_type:
	 class_or_interface_type
;

array_type:
	primitive_type dims
		
|	name dims
		
;


name:
	simple_name		
|	qualified_name		
;

simple_name:
	identifier		
;

qualified_name:
	name DOT_TK identifier
		
;

identifier:
	ID_TK
;


compilation_unit:
		
|	package_declaration
|	import_declarations
|	type_declarations
|       package_declaration import_declarations
|       package_declaration type_declarations
|       import_declarations type_declarations
|       package_declaration import_declarations type_declarations
;

import_declarations:
	import_declaration
		
|	import_declarations import_declaration
		
;

type_declarations:
	type_declaration
| 	type_declarations type_declaration
;

package_declaration:
	PACKAGE_TK name SC_TK
		
;

import_declaration:
	single_type_import_declaration
|	type_import_on_demand_declaration
;

single_type_import_declaration:
	IMPORT_TK name SC_TK
		
;

type_import_on_demand_declaration:
	IMPORT_TK name DOT_TK MULT_TK SC_TK
		
;

type_declaration:
	class_declaration
		
|	interface_declaration
		
|	empty_statement
;


modifiers:
	MODIFIER_TK
		
|	modifiers MODIFIER_TK
		
;


class_declaration:
	modifiers CLASS_TK identifier super interfaces
		
	class_body
		
|	CLASS_TK identifier super interfaces
		
	class_body
		
;

super:
		
|	EXTENDS_TK class_type
		
;

interfaces:
		
|	IMPLEMENTS_TK interface_type_list
		
;

interface_type_list:
	interface_type
		
|	interface_type_list C_TK interface_type
		
;

class_body:
	OCB_TK CCB_TK

|	OCB_TK class_body_declarations CCB_TK

;

class_body_declarations:
	class_body_declaration
|	class_body_declarations class_body_declaration
;

class_body_declaration:
	class_member_declaration
|	static_initializer
|	constructor_declaration
|	block			
		
;

class_member_declaration:
	field_declaration
|	method_declaration
|	class_declaration	
		
|	interface_declaration	
		
|	empty_statement
;


field_declaration:
	type variable_declarators SC_TK
		
|	modifiers type variable_declarators SC_TK
		
;

variable_declarators:
	
	variable_declarator	
|	variable_declarators C_TK variable_declarator
		
;

variable_declarator:
	variable_declarator_id
		
|	variable_declarator_id ASSIGN_TK variable_initializer
		
;

variable_declarator_id:
	identifier
|	variable_declarator_id OSB_TK CSB_TK
		
;

variable_initializer:
	expression
|	array_initializer
;


method_declaration:
	method_header
		
	method_body
		
;

method_header:
	type method_declarator throws
		
|	VOID_TK method_declarator throws
		
|	modifiers type method_declarator throws
		
|	modifiers VOID_TK method_declarator throws
		
;

method_declarator:
	identifier OP_TK CP_TK
		
|	identifier OP_TK formal_parameter_list CP_TK
		
|	method_declarator OSB_TK CSB_TK
		
;

formal_parameter_list:
	formal_parameter
		
|	formal_parameter_list C_TK formal_parameter
		
;

formal_parameter:
	type variable_declarator_id
		
|	final type variable_declarator_id 
		
;

final:
	modifiers
		
;

throws:
		
|	THROWS_TK class_type_list
		
;

class_type_list:
	class_type
		
|	class_type_list C_TK class_type
		
;

method_body:
	block
|	SC_TK 
;


static_initializer:
	static_ block
		
;

static_:				
	modifiers
		
;


constructor_declaration:
	constructor_header
		
	constructor_body
		
;

constructor_header:
	constructor_declarator throws
		
|	modifiers constructor_declarator throws
		
;

constructor_declarator:
	simple_name OP_TK CP_TK
		
|	simple_name OP_TK formal_parameter_list CP_TK
		
;

constructor_body:
	
	block_begin constructor_block_end
		
|	block_begin explicit_constructor_invocation constructor_block_end
		
|	block_begin block_statements constructor_block_end
		
|       block_begin explicit_constructor_invocation block_statements constructor_block_end
		
;

constructor_block_end:
	block_end
;


explicit_constructor_invocation:
	this_or_super OP_TK CP_TK SC_TK
		
|	this_or_super OP_TK argument_list CP_TK SC_TK
		
        
|	name DOT_TK SUPER_TK OP_TK argument_list CP_TK SC_TK
		
|	name DOT_TK SUPER_TK OP_TK CP_TK SC_TK
		
;

this_or_super:			
	THIS_TK
		
|	SUPER_TK
		
;



interface_declaration:
	INTERFACE_TK identifier
		
	interface_body
		
|	modifiers INTERFACE_TK identifier
		
	interface_body
		
|	INTERFACE_TK identifier extends_interfaces
		
	interface_body
		
|	modifiers INTERFACE_TK identifier extends_interfaces
		
	interface_body
		
;

extends_interfaces:
	EXTENDS_TK interface_type
		
|	extends_interfaces C_TK interface_type
		
;

interface_body:
	OCB_TK CCB_TK
		
|	OCB_TK interface_member_declarations CCB_TK
		
;

interface_member_declarations:
	interface_member_declaration
|	interface_member_declarations interface_member_declaration
;

interface_member_declaration:
	constant_declaration
|	abstract_method_declaration
|	class_declaration	
		
|	interface_declaration	
		
;

constant_declaration:
	field_declaration
;

abstract_method_declaration:
	method_header SC_TK
		
;


array_initializer:
	OCB_TK CCB_TK
		
|	OCB_TK C_TK CCB_TK
		
|	OCB_TK variable_initializers CCB_TK
		
|	OCB_TK variable_initializers C_TK CCB_TK
		
;

variable_initializers:
	variable_initializer
		
|	variable_initializers C_TK variable_initializer
		
;


block:
	block_begin block_end
		
|	block_begin block_statements block_end
		
;

block_begin:
	OCB_TK
		
;

block_end:
	CCB_TK

;

block_statements:
	block_statement
|	block_statements block_statement
;

block_statement:
	local_variable_declaration_statement
|	statement
		
|	class_declaration	
		
;

local_variable_declaration_statement:
	local_variable_declaration SC_TK 
;

local_variable_declaration:
	type variable_declarators
		
|	final type variable_declarators 
		
;

statement:
	statement_without_trailing_substatement
|	labeled_statement
|	if_then_statement
|	if_then_else_statement
|	while_statement
|	for_statement
		
;

statement_nsi:
	statement_without_trailing_substatement
|	labeled_statement_nsi
|	if_then_else_statement_nsi
|	while_statement_nsi
|	for_statement_nsi
		
;

statement_without_trailing_substatement:
	block
|	empty_statement
|	expression_statement
|	switch_statement
|	do_statement
|	break_statement
|	continue_statement
|	return_statement
|	synchronized_statement
|	throw_statement
|	try_statement
|	assert_statement
;

empty_statement:
	SC_TK
		
;

label_decl:
	identifier REL_CL_TK
		
;

labeled_statement:
	label_decl statement
		
;

labeled_statement_nsi:
	label_decl statement_nsi
		
;


expression_statement:
	statement_expression SC_TK
		
;

statement_expression:
	assignment
|	pre_increment_expression
|	pre_decrement_expression
|	post_increment_expression
|	post_decrement_expression
|	method_invocation
|	class_instance_creation_expression
;

if_then_statement:
	IF_TK OP_TK expression CP_TK statement
		
;

if_then_else_statement:
	IF_TK OP_TK expression CP_TK statement_nsi ELSE_TK statement
		
;

if_then_else_statement_nsi:
	IF_TK OP_TK expression CP_TK statement_nsi ELSE_TK statement_nsi
		
;

switch_statement:
	switch_expression
		
	switch_block
		
;

switch_expression:
	SWITCH_TK OP_TK expression CP_TK
		
;



switch_block:
	OCB_TK CCB_TK
		
|	OCB_TK switch_labels CCB_TK
		
|	OCB_TK switch_block_statement_groups CCB_TK
		
|	OCB_TK switch_block_statement_groups switch_labels CCB_TK
		
;

switch_block_statement_groups:
	switch_block_statement_group
|	switch_block_statement_groups switch_block_statement_group
;

switch_block_statement_group:
	switch_labels block_statements
;

switch_labels:
	switch_label
|	switch_labels switch_label
;

switch_label:
	CASE_TK constant_expression REL_CL_TK
		
|	DEFAULT_TK REL_CL_TK
		
;

while_expression:
	WHILE_TK OP_TK expression CP_TK
		
;

while_statement:
	while_expression statement
		
;

while_statement_nsi:
	while_expression statement_nsi
		
;

do_statement_begin:
	DO_TK
		
	
;

do_statement:
	do_statement_begin statement WHILE_TK OP_TK expression CP_TK SC_TK
		
;

for_statement:
	for_begin SC_TK expression SC_TK for_update CP_TK statement
		
|	for_begin SC_TK SC_TK for_update CP_TK statement
		
;

for_statement_nsi:
	for_begin SC_TK expression SC_TK for_update CP_TK statement_nsi
		
|	for_begin SC_TK SC_TK for_update CP_TK statement_nsi
		
;

for_header:
	FOR_TK OP_TK
		
;

for_begin:
	for_header for_init
		
;
for_init:			
		
|	statement_expression_list
		
|	local_variable_declaration
		
;

for_update:			
		
|	statement_expression_list
		
;

statement_expression_list:
	statement_expression
		
|	statement_expression_list C_TK statement_expression
		
;

break_statement:
	BREAK_TK SC_TK
		
|	BREAK_TK identifier SC_TK
		
;

continue_statement:
	CONTINUE_TK SC_TK
		
|       CONTINUE_TK identifier SC_TK
		
;

return_statement:
	RETURN_TK SC_TK
		
|	RETURN_TK expression SC_TK
		
;

throw_statement:
	THROW_TK expression SC_TK
		
;

assert_statement:
	ASSERT_TK expression REL_CL_TK expression SC_TK
		
|	ASSERT_TK expression SC_TK
		
;

synchronized_statement:
	synchronized OP_TK expression CP_TK block
		
;

synchronized:
	modifiers
		
;

try_statement:
	TRY_TK block catches
		
|	TRY_TK block finally
		
|	TRY_TK block catches finally
		
;

catches:
	catch_clause
|	catches catch_clause
		
;

catch_clause:
	catch_clause_parameter block
		
;

catch_clause_parameter:
	CATCH_TK OP_TK formal_parameter CP_TK
		
;

finally:
	FINALLY_TK block
		
;


primary:
	primary_no_new_array
|	array_creation_expression
;

primary_no_new_array:
	literal
|	THIS_TK
		
|	OP_TK expression CP_TK
		
|	class_instance_creation_expression
|	field_access
|	method_invocation
|	array_access
|	type_literals
        
|	name DOT_TK THIS_TK
		
;

type_literals:
	name DOT_TK CLASS_TK
		
|	array_type DOT_TK CLASS_TK
		
|	primitive_type DOT_TK CLASS_TK
                
|	VOID_TK DOT_TK CLASS_TK
                
;

class_instance_creation_expression:
	NEW_TK class_type OP_TK argument_list CP_TK
		
|	NEW_TK class_type OP_TK CP_TK
		
|	anonymous_class_creation
        
|	something_dot_new identifier OP_TK CP_TK
		
|	something_dot_new identifier OP_TK CP_TK class_body
|	something_dot_new identifier OP_TK argument_list CP_TK
		
|	something_dot_new identifier OP_TK argument_list CP_TK class_body
;



anonymous_class_creation:
	NEW_TK class_type OP_TK argument_list CP_TK
		
        class_body
		
|	NEW_TK class_type OP_TK CP_TK
		
        class_body
		
;

something_dot_new:		
	name DOT_TK NEW_TK
		
|	primary DOT_TK NEW_TK
		
;

argument_list:
	expression
		
|	argument_list C_TK expression
		
;

array_creation_expression:
	NEW_TK primitive_type dim_exprs
		
|	NEW_TK class_or_interface_type dim_exprs
		
|	NEW_TK primitive_type dim_exprs dims
		
|	NEW_TK class_or_interface_type dim_exprs dims
		
        
|	NEW_TK class_or_interface_type dims array_initializer
		
|	NEW_TK primitive_type dims array_initializer
		
;

dim_exprs:
	dim_expr
		
|	dim_exprs dim_expr
		
;

dim_expr:
	OSB_TK expression CSB_TK
		
;

dims:
	OSB_TK CSB_TK
		
|	dims OSB_TK CSB_TK
		
;

field_access:
	primary DOT_TK identifier
		
		
|	SUPER_TK DOT_TK identifier
		
;

method_invocation:
	name OP_TK CP_TK
		
|	name OP_TK argument_list CP_TK
		
|	primary DOT_TK identifier OP_TK CP_TK
		
|	primary DOT_TK identifier OP_TK argument_list CP_TK
		
|	SUPER_TK DOT_TK identifier OP_TK CP_TK
		
|	SUPER_TK DOT_TK identifier OP_TK argument_list CP_TK
		
        
;

array_access:
	name OSB_TK expression CSB_TK
		
|	primary_no_new_array OSB_TK expression CSB_TK
		
;

postfix_expression:
	primary
|	name
|	post_increment_expression
|	post_decrement_expression
;

post_increment_expression:
	postfix_expression INCR_TK
		
;

post_decrement_expression:
	postfix_expression DECR_TK
		
;

trap_overflow_corner_case:
	pre_increment_expression
|	pre_decrement_expression
|	PLUS_TK unary_expression
		
|	unary_expression_not_plus_minus
;

unary_expression:
	trap_overflow_corner_case
		
|	MINUS_TK trap_overflow_corner_case
		
;

pre_increment_expression:
	INCR_TK unary_expression
		
;

pre_decrement_expression:
	DECR_TK unary_expression
		
;

unary_expression_not_plus_minus:
	postfix_expression
|	NOT_TK unary_expression
		
|	NEG_TK unary_expression
 		
|	cast_expression
;

cast_expression:		
	OP_TK primitive_type dims CP_TK unary_expression
		
|	OP_TK primitive_type CP_TK unary_expression

|	OP_TK primitive_type CP_TK unary_expression C_TK
		
|	OP_TK expression CP_TK unary_expression_not_plus_minus
		
|	OP_TK name dims CP_TK unary_expression_not_plus_minus
		
;

multiplicative_expression:
	unary_expression
|	multiplicative_expression MULT_TK unary_expression
		
|	multiplicative_expression DIV_TK unary_expression
		
|	multiplicative_expression REM_TK unary_expression
		
;

additive_expression:
	multiplicative_expression
|	additive_expression PLUS_TK multiplicative_expression
		
|	additive_expression MINUS_TK multiplicative_expression
		
;

shift_expression:
	additive_expression
|	shift_expression LS_TK additive_expression
		
|	shift_expression SRS_TK additive_expression
		
|	shift_expression ZRS_TK additive_expression
		
;

relational_expression:
	shift_expression
|	relational_expression LT_TK shift_expression
		
|	relational_expression GT_TK shift_expression
		
|	relational_expression LTE_TK shift_expression
		
|	relational_expression GTE_TK shift_expression
		
|	relational_expression INSTANCEOF_TK reference_type
		
;

equality_expression:
	relational_expression
|	equality_expression EQ_TK relational_expression
		
|	equality_expression NEQ_TK relational_expression
		
;

and_expression:
	equality_expression
|	and_expression AND_TK equality_expression
		
;

exclusive_or_expression:
	and_expression
|	exclusive_or_expression XOR_TK and_expression
		
;

inclusive_or_expression:
	exclusive_or_expression
|	inclusive_or_expression OR_TK exclusive_or_expression
		
;

conditional_and_expression:
	inclusive_or_expression
|	conditional_and_expression BOOL_AND_TK inclusive_or_expression
		
;

conditional_or_expression:
	conditional_and_expression
|	conditional_or_expression BOOL_OR_TK conditional_and_expression
		
;

conditional_expression:		
	conditional_or_expression
|	conditional_or_expression REL_QM_TK expression REL_CL_TK conditional_expression
		
;

assignment_expression:
	conditional_expression
|	assignment
;

assignment:
	left_hand_side assignment_operator assignment_expression
		
;

left_hand_side:
	name
|	field_access
|	array_access
;

assignment_operator:
	ASSIGN_ANY_TK
|	ASSIGN_TK
;

expression:
	assignment_expression
;

constant_expression:
	expression
;
