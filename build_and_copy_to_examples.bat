call dart format .
call dart run build_runner build

COPY bin\api\hello\*.dart ..\pennyworth\example\
COPY bin\api\math\*.dart ..\pennyworth\example\

COPY bin\api\hello\*.dart ..\pennyworth_builder\example\
COPY bin\api\math\*.dart ..\pennyworth_builder\example\
