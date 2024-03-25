import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from decouple import config

def Snd(ListaFile,ListaMails,obj,bodyy):

    smtp_port = 587                     # Standard secure SMTP port
    smtp_server = "smtp.gmail.com"      # Google SMTP Server

    email_from = "emaailnumero1@gmail.com"

    pswrd = config('EMAIL_PASSWORD')

    subject = obj

    def send_emails(ListaMails):

        for address in ListaMails:

            # Make the body of the email
            body = bodyy

            # make a MIME object to define parts of the email
            msg = MIMEMultipart()
            msg['From'] = email_from
            msg['To'] = address
            msg['Subject'] = subject

            # Attach the body of the message
            msg.attach(MIMEText(body, 'plain'))

            for file in ListaFile:
                # Open the file in python as a binary
                attachment= open(file, 'rb')  # r for read and b for binary

                # Encode as base 64
                attachment_package = MIMEBase('application', 'octet-stream')
                attachment_package.set_payload((attachment).read())
                encoders.encode_base64(attachment_package)
                attachment_package.add_header('Content-Disposition', "attachment; filename= " + file)
                msg.attach(attachment_package)

                # Cast as string
                text = msg.as_string()

            # Connect with the server
            print("Connecting to server...")
            TIE_server = smtplib.SMTP(smtp_server, smtp_port)
            TIE_server.starttls()
            TIE_server.login(email_from, pswrd)
            print("Succesfully connected to server")
            print()

            # Send emails to "address" as list is iterated
            print(f"Sending email to: {address}...")
            TIE_server.sendmail(email_from, address, text)
            print(f"Email sent to: {address}")
            print()

        # Close the port
        TIE_server.quit()
    # Run the function
    send_emails(ListaMails)