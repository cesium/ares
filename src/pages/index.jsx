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
        <link
          rel="apple-touch-icon"
          sizes="180x180"
          href="/apple-touch-icon.png"
        />
        <link
          rel="icon"
          type="image/png"
          sizes="32x32"
          href="/favicon-32x32.png"
        />
        <link
          rel="icon"
          type="image/png"
          sizes="16x16"
          href="/favicon-16x16.png"
        />
        <link rel="manifest" href="/site.webmanifest" />
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
          <div className="space-between font-terminal-uppercase h-screen-sm sm:h-screen-sm lg:h-screen-lg xl:h-screen-xl flex flex-col justify-end p-8 text-lg text-white lg:text-2xl xl:text-4xl">
            <h1 className="text-3xl text-secondary">FAQs</h1>
            {faqs.map((faq, index) => (
              <Faqs key={index} faq={faq} />
            ))}
            <Footer />
          </div>
        </div>
      </main>
    </>
  );
}
