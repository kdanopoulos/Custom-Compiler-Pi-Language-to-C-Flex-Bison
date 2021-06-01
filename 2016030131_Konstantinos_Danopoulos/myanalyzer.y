%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"

extern int yylex(void);
extern int line_num;

%}

%union
{
	char* crepr;
  int integer;
  float real;
}


%token ASSIGN
%token ASSIGNASSIGN
%token NOTEQUAL
%token SMALLER
%token SMALLEREQUAL
%token BIGGER
%token BIGGEREQUAL
%token KW_INT
%token KW_REAL
%token KW_STRING
%token KW_BOOL
%token KW_TRUE 
%token KW_FALSE 
%token KW_VAR 
%token KW_CONST 
%token KW_IF 
%token KW_ELSE
%token KW_ELSE_IF 
%token KW_FOR 
%token KW_WHILE 
%token KW_BREAK 
%token KW_CONTINUE 
%token KW_FUNC 
%token KW_NIL 
%token KW_AND 
%token KW_OR 
%token KW_NOT 
%token KW_RETURN 
%token KW_BEGIN 
%token KW_VOID

%token KW_readString
%token KW_readInt
%token KW_readReal
%token KW_writeString
%token KW_writeInt
%token KW_writeReal

%token <crepr> IDENTIFIER 
%token <integer> INTERGER_CONSTANT 
%token <real> FLOATING_POINT 
%token <crepr> CONSTANT_STRING 

 





%start program

%type <crepr> body code decl_list predefined_functions calculation eleif call_func_var execution_body calculation_not_semicolon calc expr

//%type <crepr> total2_func_decl total_func_decl func_decl func_body return_action func_type final_var_func_decl var_func_decl single_var_func_decl
%type <crepr> total_functions single_function var_func_decl var_func_decl_2 single_var_func_decl return_action func_type

//%type <crepr> var_decl single_var_decl list_real_decl list_int_decl list_string_decl list_bool_decl real_decl int_decl string_decl bool_decl
%type <crepr> var_decl single_var_decl list_decl single_decl


%type <crepr> const_decl single_line_const_decl list_real_assign list_int_assign list_string_assign list_bool_assign real_assign_const int_assign_const string_assign_const bool_assign_const  



%left '-' '+'
%left '*' '/' '%' 
%left STARSTAR

%%



program: decl_list KW_FUNC KW_BEGIN '(' ')' '{' body '}' ';' { 
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue); 
    printf("#include \"stdbool.h\"\n\n");
    printf("/* program in c */ \n\n");
    printf("%s\n\n", $1);
    printf("int main() {%s\n} \n", $7);
  }
}
;

//decl_list:
//const_decl var_decl total_functions { $$ = template("%s\n%s\n%s",$1,$2,$3); }
//;




decl_list:
%empty { $$ = template("\n"); }
| const_decl { $$ = template("%s",$1); }
| var_decl { $$ = template("%s",$1); }
| single_function { $$ = template("%s",$1); }
| const_decl var_decl { $$ = template("%s\n%s",$1,$2); }
| const_decl single_function { $$ = template("%s\n%s",$1,$2); }
| var_decl single_function { $$ = template("%s\n%s",$1,$2); }
| const_decl var_decl single_function { $$ = template("%s\n%s\n%s",$1,$2,$3); }
;


//decl_list: 
//const_decl single_function { $$ = template("%s\n%s",$1,$2); }
//;

























body: 
%empty { $$ = template("\n"); }
| body code { $$ = template("%s\n%s",$1,$2); }
;

predefined_functions:
IDENTIFIER ASSIGN KW_readString '(' ')' ';' { $$ = template("%s = readString();",$1); }
| IDENTIFIER ASSIGN KW_readInt '(' ')' ';' { $$ = template("%s = readInt();",$1); }
| IDENTIFIER '[' calc ']' ASSIGN KW_readInt '(' ')' ';' { $$ = template("%s[%s] = readInt();",$1,$3); }
| IDENTIFIER ASSIGN KW_readReal '(' ')' ';' { $$ = template("%s = readReal();",$1); }
| IDENTIFIER '[' calc ']' ASSIGN KW_readReal '(' ')' ';' { $$ = template("%s[%s] = readReal();",$1,$3); }
| KW_writeString '(' IDENTIFIER ')' ';' { $$ = template("writeString(%s);",$3); }
| KW_writeString '(' CONSTANT_STRING ')' ';' { $$ = template("writeString(%s);",$3); }
| KW_writeInt '(' calc ')' ';' { $$ = template("writeInt(%s);",$3); }
| KW_writeReal '(' calc ')' ';' { $$ = template("writeReal(%s);",$3); }
;

code:
predefined_functions { $$ = template("%s",$1); }
| calculation { $$ = template("%s",$1); }
| KW_IF '(' expr ')' execution_body ';' { $$ = template("if(%s)%s",$3,$5); }
| KW_IF '(' expr ')' execution_body KW_ELSE '{' body '}' ';' { $$ = template("if(%s)%selse{%s\n}\n",$3,$5,$8); }
| KW_IF '(' expr ')' execution_body eleif KW_ELSE '{' body '}' ';' { $$ = template("if(%s)%s%selse{%s\n}",$3,$5,$6,$9); }
| KW_FOR '(' calculation expr ';' calculation_not_semicolon ')' execution_body { $$ = template("for(%s%s;%s)%s",$3,$4,$6,$8); }
| KW_FOR '(' calculation calculation_not_semicolon ')' execution_body { $$ = template("for(%s%s)%s",$3,$4,$6); }
| KW_WHILE '(' expr ')' execution_body ';'{ $$ = template("while(%s)%s",$3,$5); }
| KW_BREAK ';' { $$ = template("break;"); }
| KW_CONTINUE ';' { $$ = template("continue;"); }
| IDENTIFIER '(' call_func_var ')' ';' { $$ = template("%s(%s);",$1,$3); }
| IDENTIFIER ASSIGN IDENTIFIER '(' call_func_var ')' ';' { $$ = template("%s = %s(%s);",$1,$3,$5); }
| var_decl { $$ = template("%s",$1); }
| return_action { $$ = template("%s",$1); }
;

eleif:
KW_ELSE_IF '(' expr ')' execution_body { $$ = template("else if(%s)%s",$3,$5); }
| eleif KW_ELSE_IF '(' expr ')' execution_body { $$ = template("%selse if(%s)%s",$1,$4,$6); }
;

call_func_var:
%empty { $$ = template(" "); }
|calc { $$ = template("%s",$1); }
|call_func_var ',' calc { $$ = template("%s, %s",$1,$3); }
;

execution_body:
code { $$ = template("\n%s\n",$1); }
| '{' body '}' { $$ = template("{%s\n}",$2); }
; 

calculation:
IDENTIFIER ASSIGN calc ';' { $$ = template("%s = %s;",$1,$3); }
| IDENTIFIER '[' INTERGER_CONSTANT ']' ASSIGN calc ';' { $$ = template("%s[%s] = %s;",$1,$3,$6); }
;

calculation_not_semicolon:
IDENTIFIER ASSIGN calc { $$ = template("%s = %s",$1,$3); }
;

calc:
IDENTIFIER  { $$ = template("%s",$1); }
| '-' IDENTIFIER { $$ = template("-%s",$2); }
| IDENTIFIER '[' INTERGER_CONSTANT ']' { $$ = template("%s[%s]",$1,$3); }
| INTERGER_CONSTANT { $$ = template("%d",$1); }
| FLOATING_POINT { $$ = template("%.6f",$1); }
| CONSTANT_STRING { $$ = template("%s",$1); }
| KW_TRUE { $$ = template("true"); }
| KW_FALSE { $$ = template("false"); }
| KW_NOT calc { $$ = template("!%s",$2); }
| calc '+' calc { $$ = template("%s + %s",$1,$3); }
| calc '-' calc { $$ = template("%s - %s",$1,$3); }
| calc STARSTAR calc { $$ = template("pow(%s,%s)",$1,$3); }
| calc '*' calc { $$ = template("%s * %s",$1,$3); }
| calc '/' calc { $$ = template("%s / %s",$1,$3); }
| calc '%' calc { $$ = template("%s %% %s",$1,$3); }
| calc KW_AND calc { $$ = template("%s & %s",$1,$3); }
| calc KW_OR calc { $$ = template("%s | %s",$1,$3); }
| '(' calc ')' { $$ = template("(%s)",$2); }
| calc ASSIGNASSIGN calc { $$ = template("%s == %s",$1,$3); }
| calc NOTEQUAL calc { $$ = template("%s != %s",$1,$3); }
| calc SMALLER calc { $$ = template("%s < %s",$1,$3); }
| calc SMALLEREQUAL calc { $$ = template("%s <= %s",$1,$3); }
| calc BIGGER calc { $$ = template("%s > %s",$1,$3); }
| calc BIGGEREQUAL calc { $$ = template("%s >= %s",$1,$3); }
;


expr:
IDENTIFIER  { $$ = template("%s",$1); }
| '-' IDENTIFIER { $$ = template("-%s",$2); }
| INTERGER_CONSTANT { $$ = template("%d",$1); }
| FLOATING_POINT { $$ = template("%.6f",$1); }
| CONSTANT_STRING { $$ = template("%s",$1); }
| KW_TRUE { $$ = template("true"); }
| KW_FALSE { $$ = template("false"); }
| expr '+' expr { $$ = template("%s + %s",$1,$3); }
| expr '-' expr { $$ = template("%s - %s",$1,$3); }
| expr STARSTAR expr { $$ = template("pow(%s,%s)",$1,$3); }
| expr '*' expr { $$ = template("%s * %s",$1,$3); }
| expr '/' expr { $$ = template("%s / %s",$1,$3); }
| expr '%' expr { $$ = template("%s %% %s",$1,$3); }
| KW_NOT expr { $$ = template("!%s",$2); }
| expr KW_AND expr { $$ = template("%s && %s",$1,$3); }
| expr KW_OR expr { $$ = template("%s || %s",$1,$3); }
| expr ASSIGNASSIGN expr { $$ = template("%s == %s",$1,$3); }
| expr NOTEQUAL expr { $$ = template("%s != %s",$1,$3); }
| expr SMALLER expr { $$ = template("%s < %s",$1,$3); }
| expr SMALLEREQUAL expr { $$ = template("%s <= %s",$1,$3); }
| expr BIGGER expr { $$ = template("%s > %s",$1,$3); }
| expr BIGGEREQUAL expr { $$ = template("%s >= %s",$1,$3); }
| '(' expr ')' { $$ = template("(%s)",$2); }
| IDENTIFIER '(' call_func_var ')' { $$ = template("%s(%s)",$1,$3); }
;





































total_functions:
single_function { $$ = template("%s",$1); }
| total_functions single_function { $$ = template("%s\n%s",$1,$2); }
;
single_function:
KW_FUNC IDENTIFIER '(' var_func_decl ')' func_type '{' body return_action '}' ';' {$$ = template("%s %s(%s){%s\n%s\n}",$6,$2,$4,$8,$9);}
;
var_func_decl:
%empty { $$ = template(" "); }
| var_func_decl_2 { $$ = template("%s",$1); }
;
var_func_decl_2:
single_var_func_decl { $$ = template("%s", $1); }
| var_func_decl_2 ',' single_var_func_decl { $$ = template("%s, %s",$1,$3); }
;
single_var_func_decl:
IDENTIFIER KW_INT { $$ = template("int %s", $1); }
| IDENTIFIER KW_REAL { $$ = template("float %s", $1); }
| IDENTIFIER KW_STRING { $$ = template("char %s[]", $1); }
| IDENTIFIER KW_BOOL { $$ = template("bool %s", $1); }
| IDENTIFIER '[' ']' KW_INT { $$ = template("int %s[]", $1); }
| IDENTIFIER '[' ']' KW_REAL { $$ = template("float %s[]", $1); }
| IDENTIFIER '[' ']' KW_STRING { $$ = template("char %s[][]", $1); }
| IDENTIFIER '[' ']' KW_BOOL { $$ = template("bool %s[]", $1); }
;
return_action:
KW_RETURN ';' { $$ = template("return;"); }
| KW_RETURN calc ';' { $$ = template("return %s;",$2); }
;
func_type:
KW_INT { $$ = template("int"); }
| KW_REAL { $$ = template("float"); }
| KW_STRING { $$ = template("char *"); }
| KW_BOOL { $$ = template("bool"); }
| KW_VOID { $$ = template("void"); }
| '[' ']' KW_INT { $$ = template("int *"); }
| '[' ']' KW_REAL { $$ = template("float *"); }
| '[' ']' KW_STRING { $$ = template("char **"); }
| '[' ']' KW_BOOL { $$ = template("bool *"); }
;



































var_decl:
single_var_decl { $$ = template("%s",$1); }
| var_decl single_var_decl { $$ = template("%s\n%s",$1,$2); }
;
single_var_decl: 
KW_VAR list_decl KW_REAL ';' { $$ = template("float %s;",$2); }
| KW_VAR list_decl KW_INT ';' { $$ = template("int %s;",$2); }
| KW_VAR list_decl KW_STRING ';' { $$ = template("char* %s;",$2); }
| KW_VAR list_decl KW_BOOL ';' { $$ = template("bool %s;",$2); }
;
list_decl:
single_decl { $$ = template("%s",$1); }
| list_decl ',' single_decl { $$ = template("%s, %s",$1,$3); }
;
single_decl:
IDENTIFIER { $$ = template("%s",$1); };
| IDENTIFIER '[' INTERGER_CONSTANT ']' { $$ = template("%s[%d]",$1,$3); };
| calculation_not_semicolon { $$ = template("%s",$1); };
;

















/*
var_decl:
single_var_decl { $$ = template("%s",$1); }
| var_decl single_var_decl { $$ = template("%s\n%s",$1,$2); }
;
single_var_decl: 
KW_VAR list_real_decl KW_REAL ';' { $$ = template("%s",$2); }
| KW_VAR list_int_decl KW_INT ';' { $$ = template("%s",$2); }
| KW_VAR list_string_decl KW_STRING ';' { $$ = template("%s",$2); }
| KW_VAR list_bool_decl KW_BOOL ';' { $$ = template("%s",$2); }
;
list_real_decl: 
real_decl 
| real_decl ',' list_real_decl { $$ = template("%s\n%s",$1,$3); }
;
list_int_decl: 
int_decl 
| int_decl ',' list_int_decl { $$ = template("%s\n%s",$1,$3); }
;
list_string_decl: 
string_decl 
| string_decl ',' list_string_decl { $$ = template("%s\n%s",$1,$3); }
;
list_bool_decl: 
bool_decl 
| bool_decl ',' list_bool_decl { $$ = template("%s\n%s",$1,$3); }
;
real_decl:
IDENTIFIER { $$ = template("float %s;",$1); };
| IDENTIFIER ASSIGN FLOATING_POINT { $$ = template("float %s = %.6f ;",$1,$3); };
;
int_decl:
IDENTIFIER { $$ = template("int %s;",$1); };
| IDENTIFIER ASSIGN INTERGER_CONSTANT { $$ = template("int %s = %d ;",$1,$3); };
;
string_decl:
IDENTIFIER { $$ = template("string %s;",$1); };
| IDENTIFIER ASSIGN CONSTANT_STRING { $$ = template("string %s = \"%s\" ;",$1,$3); };
;
bool_decl:
IDENTIFIER { $$ = template("bool %s;",$1); };
| IDENTIFIER ASSIGN KW_TRUE { $$ = template("bool %s = true;",$1); };
| IDENTIFIER ASSIGN KW_FALSE { $$ = template("bool %s = false;",$1); }; 
;*/





const_decl:
single_line_const_decl
| const_decl single_line_const_decl { $$ = template("%s\n%s", $1, $2); }
;
single_line_const_decl: 
KW_CONST list_real_assign KW_REAL ';' { $$ = template("%s",$2); }
| KW_CONST list_int_assign KW_INT ';' { $$ = template("%s",$2); }
| KW_CONST list_string_assign KW_STRING ';' { $$ = template("%s",$2); }
| KW_CONST list_bool_assign KW_BOOL ';' { $$ = template("%s",$2); }
;
list_real_assign: 
real_assign_const 
| list_real_assign ',' real_assign_const { $$ = template("%s\n%s",$1,$3); }
;
list_int_assign: 
int_assign_const 
| list_int_assign ',' int_assign_const { $$ = template("%s\n%s",$1,$3); }
;
list_string_assign: 
string_assign_const 
| list_string_assign ',' string_assign_const { $$ = template("%s\n%s",$1,$3); }
;
list_bool_assign: 
bool_assign_const 
| list_bool_assign ',' bool_assign_const { $$ = template("%s\n%s",$1,$3); }
;
real_assign_const: IDENTIFIER ASSIGN FLOATING_POINT { $$ = template("#define %s %.6f", $1, $3); };
int_assign_const: IDENTIFIER ASSIGN INTERGER_CONSTANT { $$ = template("#define %s %d", $1, $3); };
string_assign_const: IDENTIFIER ASSIGN CONSTANT_STRING { $$ = template("#define %s %s", $1, $3); };
bool_assign_const: IDENTIFIER ASSIGN KW_TRUE { $$ = template("#define %s true", $1); }
| IDENTIFIER ASSIGN KW_FALSE { $$ = template("#define %s false", $1); }
;








%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
  //else
    //printf("Accepted!\n");
}


