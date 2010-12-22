@echo off
goto main

:sysenv
    set TARGET=sample.bat
    goto end_sysenv

:clear_sysenv
    set METHODS=
    set TESTPWD=
    set EXPECT=
    set ACTUAL=
    set TARGET=
    goto end_clear_sysenv

:test_final
    call %TARGET% final test
    :: Assert
        echo ### Test for final ###

        set EXPECT=
        set ACTUAL=%JOBLOG%
        if not "%ACTUAL%"=="%EXPECT%" echo Actual is %ACTUAL%, but expected was %EXPECT%.
        if     "%ACTUAL%"=="%EXPECT%" echo Actual is %ACTUAL%, TEST OK.

        set EXPECT=%TESTPWD%\sample.log
        if not exist "%EXPECT%" echo %EXPECT% is not exist.
        if exist     "%EXPECT%" echo %EXPECT% is exist, TEST OK.

        set EXPECT=
        set ACTUAL=%LOCK%
        if not "%ACTUAL%"=="%EXPECT%" echo Actual is %ACTUAL%, but expected was %EXPECT%.
        if     "%ACTUAL%"=="%EXPECT%" echo Actual is %ACTUAL%, TEST OK.

        set EXPECT=%TESTPWD%\lock
        if exist     "%EXPECT%" echo %EXPECT% is exist.
        if not exist "%EXPECT%" echo %EXPECT% is not exist, TEST OK.

    goto end_of_method

:test_initial
    call %TARGET% initial test
    :: Assert
        echo ### Test for initial ###

        set EXPECT=%TESTPWD%\sample.log
        set ACTUAL=%JOBLOG%
        if not "%ACTUAL%"=="%EXPECT%" echo Actual is %ACTUAL%, but expected was %EXPECT%.
        if     "%ACTUAL%"=="%EXPECT%" echo Actual is %ACTUAL%, TEST OK.

        set EXPECT=%TESTPWD%\sample.log
        if not exist "%EXPECT%" echo %EXPECT% is not exist.
        if exist     "%EXPECT%" echo %EXPECT% is exist, TEST OK.

        set EXPECT=%TESTPWD%\lock
        set ACTUAL=%LOCK%
        if not "%ACTUAL%"=="%EXPECT%" echo Actual is %ACTUAL%, but expected was %EXPECT%.
        if     "%ACTUAL%"=="%EXPECT%" echo Actual is %ACTUAL%, TEST OK.

        set EXPECT=%TESTPWD%\lock
        if not exist "%EXPECT%" echo %EXPECT% is not exist.
        if exist     "%EXPECT%" echo %EXPECT% is exist, TEST OK.

    goto end_of_method

:final
    :: logger
        date /t
        time /t
        echo ### Test Ended ###
    goto shutdown

:initial
    :: logger
        date /t
        time /t
        echo ### Test Started ###

    :setup_methods
        set METHODS= ^
            test_initial ^
            test_final

    call %0 %METHODS%
    goto end

:Common
    :set_pwd
        for /f "usebackq tokens=*" %%i in (`cd`) do @set TESTPWD=%%i
    goto end_set_pwd

:shutdown
    cd %TESTPWD%>nul
    :clear_config
        :: call config.bat clear
    goto clear_sysenv
        :end_clear_sysenv
    goto exit

:startup
    cd %TESTPWD%>nul
    :require_config
        :: call config.bat
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
        cd %TESTPWD%>nul
        shift /1
        if "%1"=="" goto final
        call %0 %1 %2 %3 %4 %5 %6 %7 %8 %9

:end
goto shutdown
:exit
