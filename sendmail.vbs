Option Explicit

Sub mail_send()
    Dim oMsg
    Dim schemas
    Set oMsg = CreateObject("CDO.Message")
    schemas = "http://schemas.microsoft.com/cdo/configuration/"

    oMsg.Bcc      = ""
    oMsg.From     = "hoge@hoge.co.jp"
    oMsg.To       = "fuga@fuga.co.jp"

    oMsg.Subject  = Wscript.Arguments.Item(0)
    oMsg.TextBody = Now & vbCrLf & Wscript.Arguments.Item(1)

    oMsg.Configuration.Fields.Item (schemas + "sendusing") = 2
    oMsg.Configuration.Fields.Item (schemas + "smtpserver") = "smtp.hoge.co.jp"
    oMsg.Configuration.Fields.Item (schemas + "smtpserverport") = 25
    oMsg.Configuration.Fields.Item (schemas + "smtpauthenticate") = true
    oMsg.Configuration.Fields.Item (schemas + "sendusername") = "username"
    oMsg.Configuration.Fields.Item (schemas + "sendpassword") = "password"

    oMsg.Configuration.Fields.Update
    oMsg.send
End Sub

mail_send
