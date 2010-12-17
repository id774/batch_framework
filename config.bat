@echo off
if "%1"=="clear" goto clear

:configuration
    :: set foo=bar
goto end

:clear
    :: set foo=
goto end

:end
