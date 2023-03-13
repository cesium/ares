import Image from "next/image";

export default function Mid() {
  return (
    <div className="max-w-screen-lg">
      <div className="space-between font-karrik-normal md:h-screen-md lg:h-screen-lg xl:h-screen-xl m-auto flex h-screen w-screen flex-col items-center justify-center text-4xl text-white lg:justify-center xl:m-0 xl:flex-row xl:justify-center">
        <div className="mr-auto w-screen p-4 xl:w-4/5 xl:p-16">
          <p className="font-terminal-uppercase text-xl text-white md:text-3xl lg:text-4xl xl:text-5xl">
            Mais um ano, mais uma Hackathon incrível… <br />
            E desta vez, o CeSIUM preparou a melhor que já viste, a BugsByte!
            Aproveita esta oportunidade única para conviver com estudantes da
            área da tecnologia que partilham das mesmas paixões que tu -
            inovação, competição e, é claro, programação! Problemas desafiantes,
            muito trabalho árduo, soluções fora da caixa e doses absurdas de
            diversão esperam-te na BugsByte. <br />
          </p>
          <p className="font-terminal-uppercase mt-10">
            Reúne a tua equipa e prepara-te para dar tudo!
          </p>
          <p className="font-terminal-uppercase mt-10 animate-bounce text-white">
            <a
              href="https://forms.gle/KxsegGxvB6psH4Gu7"
              className="border-2 bg-[#00E600] p-2"
            >
              Junta-te a nós
            </a>
          </p>
        </div>
        <div className="ml-auto hidden xl:block">
          <Image src="/bicho.png" alt="CeSIUM Logo" width={600} height={800} />
        </div>
      </div>
    </div>
  );
}
