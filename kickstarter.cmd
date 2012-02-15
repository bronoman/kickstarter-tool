echo off
rem note: 6 parameters required
rem parameter %1 is the drive (e.g. c:)
rem parameter %2 is the path (e.g. grails\workspace\)
rem parameter %3 is the name of the app 
rem parameter %4 is the name of the 1st domain class
rem parameter %5 is the name of the 2nd domain class
rem parameter %6 is the name of the 3rd domain class
rem
if [%6]==[] goto :entry
if [%5]==[] goto :entry
if [%4]==[] goto :entry
if [%3]==[] goto :entry
if [%2]==[] goto :entry
if [%1]==[] goto :entry
set _drive=%1
set _path=%2
set _app=%3
set _dom1=%4
set _dom2=%5
set _dom3=%6
goto :start
:entry
Set /P _drive=please enter parameter 1: drive letter (e.g. c:)       :
Set /P _path=please enter parameter 2: path (e.g. grails\workspace)  :
Set /P _app=please enter parameter 3: desired name of app            :
echo remember to use a capital first letter for domain names
Set /P _dom1=please enter parameter 4: name of the 1st domain class  :
Set /P _dom2=please enter parameter 5: name of the 2nd domain class  :
Set /P _dom3=please enter parameter 6: name of the 3rd domain class  :
:start
echo Input Summary:
echo you set drive    to: %_drive%
echo you set path     to: %_path%
echo you set app name to: %_app%
echo you set domain1  to: %_dom1%
echo you set domain2  to: %_dom2%
echo you set domain3  to: %_dom3%
echo.
pause
cls
echo.
echo ok, let's go!
echo on
%_drive%
cd \
cd %_path%
call grails create-app %_app%
cd %_app%
call grails install-plugin kickstart-with-bootstrap
call grails kickstartWithBootstrap
call grails create-domain-class %_dom1%
call grails create-domain-class %_dom2%
call grails create-domain-class %_dom3%
echo.
echo *****************************************************************************
echo now copy or implement your 3 domain classes:
echo domain class 1: %_dom1%
echo domain class 2: %_dom2%
echo domain class 3: %_dom3%
echo after that, come back here and continue
echo *****************************************************************************
echo.
pause
call grails generate-all %_app%.%_dom1%
call grails generate-all %_app%.%_dom2%
call grails generate-all %_app%.%_dom3%
echo.
echo.
echo *****************************************************************************
echo ...done!
call grails stats
echo now, we'll go ahead and run the app.
echo *****************************************************************************
echo.
grails run-app
