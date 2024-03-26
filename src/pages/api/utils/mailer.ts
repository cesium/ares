import { SMTPClient } from "emailjs";

const sendEmail = async (
  to: string,
  subject: string,
  content: string,
): Promise<Error | null> => {
  const senderEmail = import.meta.env.SENDER_EMAIL;

  const client = new SMTPClient({
    user: import.meta.env.SMTP_USER,
    password: import.meta.env.SMTP_PASS,
    host: import.meta.env.SMTP_HOST,
    ssl: true,
  });

  const message = {
    text: "",
    from: senderEmail,
    to: to,
    subject: subject,
    attachment: [
      {
        data: content,
        alternative: true,
      },
    ],
  };

  return new Promise((resolve, reject) => {
    client.send(message, function(err, message) {
      if (err) {
        console.error("Error sending email:", err);
        reject(err);
      } else {
        console.log("Email sent successfully:", message);
        resolve(null);
      }
    });
  });
};

export { sendEmail };
