Option Explicit

Dim str,oMsg
Set oMsg = CreateObject("CDO.Message")

oMsg.Bcc      = "bcc@hoge.co.jp"
oMsg.From     = "from@hoge.co.jp"
oMsg.To       = "to@hoge.co.jp"

oMsg.Subject  = Wscript.Arguments.Item(0)
oMsg.TextBody = Now & vbCrLf & Wscript.Arguments.Item(1)

oMsg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
oMsg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail-smtp.hoge.co.jp"
oMsg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
oMsg.Configuration.Fields.Update

oMsg.send
