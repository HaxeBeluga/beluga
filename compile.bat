set directory=survey

rd /S /Q www
mkdir www
mkdir www\mtt

.\build.hxml

xcopy /Y *.mtt www\
xcopy /Y style.css www\
rd /S /Q C:\wamp2\www\%directory%\
mkdir C:\wamp2\www\%directory%\
mkdir C:\wamp2\www\%directory%\image\
xcopy /Y image\* C:\wamp2\www\%directory%\image\
xcopy /E www\* C:\wamp2\www\%directory%\