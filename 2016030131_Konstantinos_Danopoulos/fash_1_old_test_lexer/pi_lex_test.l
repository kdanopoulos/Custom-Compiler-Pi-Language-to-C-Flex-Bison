%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
//#include "pi_parser.tab.h"
//#include "cgen.h"

int line_num = 1;

#define DIV 0
#define ASSIGN 1
#define PLUS 2
#define MINUS 3
#define STAR 4
#define SLASH 5
#define STARSTAR -1
#define ASSIGNASSIGN -2
#define NOTEQUAL -3
#define SMALLER -4
#define SMALLEREQUAL -5
#define BIGGER -6
#define BIGGEREQUAL -7

#define KW_INT 6
#define KW_REAL 7
#define KW_STRING 8
#define KW_BOOL 9
#define KW_TRUE 10
#define KW_FALSE 11
#define KW_VAR 12
#define KW_CONST 13
#define KW_IF 14
#define KW_ELSE 15
#define KW_FOR 16
#define KW_WHILE 17
#define KW_BREAK 18
#define KW_CONTINUE 19
#define KW_FUNC 20
#define KW_NIL 21
#define KW_AND 22
#define KW_OR 23
#define KW_NOT 24
#define KW_RETURN 25 
#define KW_BEGIN 26

#define IDENTIFIER 27
#define INTERGER_CONSTANT 28
#define FLOATING_POINT 29

#define CONSTANT_STRING 30


%}

DIGIT  [0-9]
NUM  {DIGIT}{DIGIT}*
STRING  '[^'\n]*'
INTEGER [+|-]?([1-9]{DIGIT}*)|0
NONZEROINT ([1-9]{DIGIT}*)

%x comment

%%

"int"       {return KW_INT;}
"real"      {return KW_REAL;}
"string"	{return KW_STRING;}
"bool"	    {return KW_BOOL;}
"var"	    {return KW_VAR;}
"const"	    {return KW_CONST;}
"if"	    {return KW_IF;}
"else"	    {return KW_ELSE;}
"for"	    {return KW_FOR;}
"while"	    {return KW_WHILE;}
"break"	    {return KW_BREAK;}
"continue"	{return KW_CONTINUE;}
"func"	    {return KW_FUNC;}
"nil"	    {return KW_NIL;}
"and"	    {return KW_AND;}
"or"	    {return KW_OR;}
"not"	    {return KW_NOT;}
"return"	{return KW_RETURN;}
"begin"	    {return KW_BEGIN;}
"true"	    {return KW_TRUE;}
"false"	    {return KW_FALSE;}

{INTEGER} {return INTERGER_CONSTANT;}
{INTEGER}|{INTEGER}\.{DIGIT}*([e|E][+|-]?{NONZEROINT})? {return FLOATING_POINT;}

[a-zA-Z][a-zA-Z0-9_]* {return IDENTIFIER;}

\"(([^\"]|\\\")*[^\\])?\" {return CONSTANT_STRING;}



"="	return ASSIGN;
"+" return PLUS;
"-" return MINUS;
"*" return STAR;
"/" return SLASH;
"%" return DIV;
"**" return STARSTAR;
"==" return ASSIGNASSIGN;
"!=" return NOTEQUAL;
"<" return SMALLER;
"<=" return SMALLEREQUAL;
">" return BIGGER;
">=" return BIGGEREQUAL;

";" 	return ';';
")"	return ')';
"("	return '(';
"[" return '[';
"]" return ']';
"{"	return '{';
"}"	return '}';
"," return ',';


"//"[^\n]*  	/* eat line comments */

"/*"		BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);


[ \r\t]		/* skip whitespace */
\n 		++line_num;
<<EOF>> 	return EOF;

.  { printf("lexical error: unrecognized literal '%s'\n", yytext); }


%%

int main(){
	int token;
	while( (token = yylex()) != EOF ){
		printf("Line %d Token %d: %s\n",line_num,token,yytext);
	}
}
