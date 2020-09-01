if
.RegistrationEnabled then "<h2>"+.Name+"</H2><p>",.Details.RegistrationConfirmationExtraInfo | sub("\r\n";"<br/>";"g")
else empty
end
