@echo off
SET interactive=1
ECHO %CMDCMDLINE% | FIND /I "/c" >NUL 2>&1
IF %ERRORLEVEL% == 0 SET interactive=0

cd %~dp0
:: The important piece to running tests is to have a localhost running in one terminal, then running minitest in a second
:: script main content
start bundle exec jekyll serve
:: Running minitest without an argument automatically runs test file paths that match test/test_*
:: Within the files, functions matching test_* in classes that inherit from Minitest::Test are ran as tests.
:: (in eisencalc's case, test classes inherit from CalcTest which inherets from Minitest::Test)
bundle exec minitest
:: end script main content

::echo The tests are finished running. Please close the localhost window that was created.

IF "%interactive%"=="0" PAUSE
EXIT /B 0
