import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";

const senderEmail = import.meta.env.SENDER_EMAIL;
const discordInvite = import.meta.env.DISCORD_INVITE;
const ses = new SESClient({
    region: import.meta.env.SES_REGION,
    credentials: {
      accessKeyId: import.meta.env.SES_ACCESS,
      secretAccessKey: import.meta.env.SES_SECRET,
    },
  });


const sendConfirmationEmail = async (
  email: string,
  name: string,
  confirmation: string,
) => {
  const params = new SendEmailCommand({
    Source: senderEmail,
    Destination: { ToAddresses: [email] },
    Message: {
      Subject: { Data: "[BugsByte] Registration Confirmation" },
      Body: {
        Html: {
          Data: `<h2>Hello, ${name} 👋</h2>
            <div>
              <p>Your participation in the BugsByte Hackathon is confirmed! Your confirmation number is <b>#${confirmation}</b></p>
              <p>Make sure to keep this email handy, it's your ticket to the event! Plus, stay tuned for more details as we'll be reaching out to you shortly with all the necessary information.</p>
              <p>If you want to join our discord server, here's the link: ${discordInvite}</p>
              <p>See you soon,</p>
              <p>Organization team 🪲</p>
            </div>`,
        },
      },
    },
  });

  try {
    await ses.send(params);
  } catch (error) {
    console.error("Error sending email:", error);
  }
};

export { sendConfirmationEmail };