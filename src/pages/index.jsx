import Head from 'next/head'
import Top from "../components/Top"
import Mid from '../components/Mid'
import Footer from '../components/Footer'
import Podium from '../components/Podium'
import Faqs from '../components/Faqs'
import faqs from '../../public/faqs.json'

export default function Home() {

  return (
    <>
      <Head>
        <title>BugsByte Hackathon</title>
        <meta name="description" content="BugsByte Hackathon" />
      </Head>
      <main className="bg-hero text-white snap-y snap-mandatory h-screen overflow-scroll ">
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
          <div className="h-screen w-screen flex flex-col space-between w-screen justify-center p-8 text-4xl text-white font-terminal-uppercase">
            <h1 className="text-secondary">FAQs</h1>
            {faqs.map((faq, index) => (
              <Faqs key={index} faq={faq} />
            ))}
          </div>
          <Footer />
        </div>
      </main>
    </>
  )
}
