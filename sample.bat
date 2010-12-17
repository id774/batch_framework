@echo off
goto main

:sysenv
    set PROJECT_ROOT=%PWD%
    set JOBLOG=%PROJECT_ROOT%\sample.log
    set LOCK=%PROJECT_ROOT%\lock
    goto end_sysenv

:clear_sysenv
    set PWD=
    set PROJECT_ROOT=
    set JOBLOG=
    set LOCK=
    goto end_clear_sysenv

:methods
    goto end_of_method

:error
    :: logger
        date /t>>%JOBLOG%
        time /t>>%JOBLOG%
        echo ### Job Abnormal Ended ###>>%JOBLOG%

        if exist %LOCK% del /q /f %LOCK%
    goto end

:final
    :: logger
        date /t>>%JOBLOG%
        time /t>>%JOBLOG%
        echo ### Job Ended ###>>%JOBLOG%

        if exist %LOCK% del /q /f %LOCK%
    goto shutdown

:initial
    :: Wait for lock
        cd /d %PWD%>nul
        ruby waitlock.rb %LOCK% 1
        echo lock>%LOCK%

    :: logger
        date /t>%JOBLOG%
        time /t>>%JOBLOG%
        echo ### Job Started ###>>%JOBLOG%

    :setup_methods
        set METHODS= ^
            methods ^
            final

    if "%2"=="test" goto exit
    call %0 %METHODS%
    goto end

:Common
    :set_pwd
        for /f "usebackq tokens=*" %%i in (`cd`) do @set PWD=%%i
    goto end_set_pwd

:shutdown
    cd %PWD%>nul
    :clear_config
        call config.bat clear
    goto clear_sysenv
        :end_clear_sysenv
    goto exit

:startup
    cd %PWD%>nul
    :require_config
        call config.bat
    goto sysenv
        :end_sysenv
    goto end_startup

:main
    :environment
        goto set_pwd
            :end_set_pwd
        goto startup
            :end_startup

    :dispatcher
        if "%1"=="" goto initial
        goto %1

    :end_of_method
        if "%2"=="test" goto exit
        cd %PWD%>nul
        shift /1
        if "%1"=="" goto final
        call %0 %1 %2 %3 %4 %5 %6 %7 %8 %9

:end
if "%2"=="test" goto exit
goto shutdown
:exit
