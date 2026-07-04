import weblogic.security.internal.SerializedSystemIni
import weblogic.security.internal.encryption.ClearOrEncryptedService

# 1. Point to your EXACT domain directory
domain_path = "/path/to/YOUR_DOMAIN"

# 2. Load the domain's encryption service
service = weblogic.security.internal.encryption.ClearOrEncryptedService(weblogic.security.internal.SerializedSystemIni.getEncryptionService(domain_path))

# 3. Decrypt your string (Replace with your actual encrypted string)
print "Decrypted Password: " + service.decrypt("{AES}GetYourEncryptedStringFromConfigFile...")
