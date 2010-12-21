@echo off
if "%1"=="clear" goto clear

:configuration
    :: set foo=bar
    set ALART_LEVEL=0
goto end

:clear
    :: set foo=
goto end

:end
