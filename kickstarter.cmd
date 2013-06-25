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
Set /P _app=please enter parameter 3: desired name of app (lowercase initial)   :
Set /P _dom1=please enter parameter 4: name of the 1st domain class (upper initial) :
Set /P _dom2=please enter parameter 5: name of the 2nd domain class (upper initial) :
Set /P _dom3=please enter parameter 6: name of the 3rd domain class (upper initial) :
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
echo.
echo on
%_drive%
cd \
cd %_path%
call grails create-app %_app%
cd %_app%
rem *** remove the next 2 lines to avoid kickstart
call grails install-plugin kickstart-with-bootstrap
call grails kickstart
call grails create-domain-class %_dom1%
call grails create-domain-class %_dom2%
call grails create-domain-class %_dom3%
rem if you want to comment out the 2 kickstart lines above use the 3 lines below, otherwise above
rem call grails create-domain-class %_app%.%_dom1%
rem call grails create-domain-class %_app%.%_dom2%
rem call grails create-domain-class %_app%.%_dom3%
echo.
echo ********************************************************
echo now copy or implement your 3 domain classes:
echo domain class 1: %_dom1%
echo domain class 2: %_dom2%
echo domain class 3: %_dom3%
echo after that, come back here and continue
echo ********************************************************
echo.
pause
:recompile
call grails compile
choice /C:YN /N /M "Ready to move on (Y) or re-compile (N)"
if ERRORLEVEL 2 goto recompile
:moveon
call grails generate-all %_app%.%_dom1%
call grails generate-all %_app%.%_dom2%
call grails generate-all %_app%.%_dom3%
echo.
echo.
echo *****************************************************************************
echo domains are done!
echo now, we'll create the documentation
echo *****************************************************************************
echo.
cd src
md docs
cd docs
md guide
md ref
cd ref
md Areas
md Domains
md Services
md Tools
md Extensions
cd..
cd..
cd..
cd..
echo *************************************************************************************************
echo to do:
echo. 
echo update grails-app/conf/Config.groovy
echo insert properties like version, title, authors... 
echo ...as descibed in "Configuring Output Properties" in grails documentation
echo. 
echo *************************************************************************************************
pause
copy template_intro.gdoc %_app%\src\docs\guide\introduction.gdoc
copy template_blocks.gdoc %_app%\src\docs\guide\blocks.gdoc
copy template_dom.gdoc %_app%\src\docs\guide\%_dom1%.gdoc
copy template_dom.gdoc %_app%\src\docs\guide\%_dom2%.gdoc
copy template_dom.gdoc %_app%\src\docs\guide\%_dom3%.gdoc
rem creating reference pages
copy template_ref.gdoc %_app%\src\docs\ref\Areas\sample.gdoc
copy template_ref.gdoc %_app%\src\docs\ref\Domains\sample.gdoc
copy template_ref.gdoc %_app%\src\docs\ref\Services\sample.gdoc
copy template_ref.gdoc %_app%\src\docs\ref\Tools\sample.gdoc
copy template_ref.gdoc %_app%\src\docs\ref\Extensions\sample.gdoc
rem
rem to do:
rem use ant to modify toc here to cater to the actual domain names
rem
rem these 3 lines are just here, so something is created!
rem
copy template_dom.gdoc %_app%\src\docs\guide\domain1.gdoc
copy template_dom.gdoc %_app%\src\docs\guide\domain2.gdoc
copy template_dom.gdoc %_app%\src\docs\guide\domain3.gdoc
copy template_toc.yml %_app%\src\docs\guide\toc.yml
cd %_app%
call grails doc
echo.
echo *************************************************************************************************
echo documentation...done as well!
echo Update your TOC and re-run grails doc - see errors above.
echo *************************************************************************************************
call grails stats
call grails clean
call grails compile
echo *************************************************************************************************
echo now, we'll go ahead and run the app.
echo.
echo Documentation is located at: C:\...\%_app%\target\docs\guide\index.html
echo going to run-app now! Fasten seat belts!
echo *************************************************************************************************
echo.
grails run-app
