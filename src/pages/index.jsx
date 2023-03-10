import Head from 'next/head'
import Top from '@/components/Top'
import Mid from '@/components/Mid'
import Footer from '@/components/Footer'
import Podium from '@/components/Podium'
export default function Home() {

  return (
    <>
      <Head>
        <title>BugsByte Hackathon</title>
        <meta name="description" content="BugsByte Hackathon" />
      </Head>
      <main className="bg-black text-white snap-y snap-mandatory h-screen overflow-scroll">
        <div className="snap-center">
          <Top />
        </div>
        <div className="snap-center">
          <Mid />
        </div>
        <div className="snap-center">
          <Podium />
        </div>
        <Footer />
      </main>
    </>
  )
}
