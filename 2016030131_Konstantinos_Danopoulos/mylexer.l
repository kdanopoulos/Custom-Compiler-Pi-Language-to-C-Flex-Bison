%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "myanalyzer.tab.h"
#include "cgen.h"

int line_num = 1;

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
"else if"	{return KW_ELSE_IF;}
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
"void"		{return KW_VOID;}
"readString"  {return KW_readString;}
"readInt"     {return KW_readInt;}
"readReal"    {return KW_readReal;}
"writeString" {return KW_writeString;}
"writeInt"    {return KW_writeInt;}
"writeReal"   {return KW_writeReal;}

{INTEGER} {yylval.integer = atoll(strdup(yytext)); return INTERGER_CONSTANT;}
{INTEGER}|({INTEGER}\.{DIGIT}*([e|E][+|-]?{NONZEROINT})?) {yylval.real = atof(strdup(yytext)); return FLOATING_POINT;}

[a-zA-Z][a-zA-Z0-9_]* {yylval.crepr = strdup(yytext);return IDENTIFIER;}

\"(([^\"]|\\\")*[^\\])?\" {yylval.crepr = strdup(yytext);return CONSTANT_STRING;}



"="	return ASSIGN;
"+" return '+';
"-" return '-';
"*" return '*';
"/" return '/';
"%" return '%';
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

.  { yyerror("lexical error: unrecognized literal '%s'\n", yytext); }


%%