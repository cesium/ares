import Head from "next/head";
import Top from "../components/Top";
import Mid from "../components/Mid";
import Footer from "../components/Footer";
import Podium from "../components/Podium";
import Faqs from "../components/Faqs";
import faqs from "../../public/faqs.json";

export default function Home() {
  return (
    <>
      <Head>
        <title>BugsByte Hackathon</title>
        <meta name="description" content="BugsByte Hackathon" />
      </Head>
      <main className="h-screen snap-y snap-mandatory overflow-scroll bg-hero text-white ">
        <div className="snap-center">
          <Top />
        </div>
        <div className="snap-center">
          <Mid />
        </div>
        <div className="snap-center">
          <Podium />
        </div>
        <div className="snap-center">
          <div className="space-between font-terminal-uppercase flex h-screen w-screen w-screen flex-col justify-center p-8 text-4xl text-white">
            <h1 className="text-secondary">FAQs</h1>
            {faqs.map((faq, index) => (
              <Faqs key={index} faq={faq} />
            ))}
          </div>
          <Footer />
        </div>
      </main>
    </>
  );
}
