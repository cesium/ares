import Lottie from "lottie-react";
import ampulheta from "public/ampulheta.json";
import Image from "next/image";
import subvisual from "public/logos/subvisual.svg";

export default function Podium() {
  return (
    <div className="space-between font-terminal-uppercase lg:h-screen-lg xl:h-screen-xl flex h-screen h-screen w-screen flex-col items-center justify-center text-base text-white lg:flex-row lg:text-2xl xl:flex-row xl:text-4xl">
      <div className="mt-10 flex flex flex-col items-center xl:mt-0 xl:w-1/3">
        <h1 className="text-4xl text-secondary">Temas:</h1>
        <div className="flex flex-row items-center xl:mb-10 xl:mt-10 xl:flex-col">
          <div className="flex flex-row items-center xl:mb-10 xl:mt-10">
            <h2 className="">Tema 1 - Web3</h2>
          </div>
          <div className="flex flex-row items-center xl:mb-10 xl:mt-10">
            <h2 className="">Tema 2 - Gaming</h2>
          </div>
          <div className="flex flex-row items-center xl:mb-10 xl:mt-10">
            <h2 className="">Tema 3 - Educação</h2>
          </div>
        </div>
      </div>
      <div className="mt-10 flex flex-col items-center xl:mt-0 xl:w-1/3">
        <h1 className="text-4xl text-secondary">Prémios por Equipa</h1>
        <div className="flex flex-col items-center xl:mb-10">
          <div className="flex flex-col items-center xl:mb-10 xl:mt-10 ">
            <h2 className="text-white">Vencedores Gerais</h2>
            <h2 className="mt-4 text-white">1º Lugar - TINC</h2>
            <h2 className="mt-4 text-white">2º Lugar - QuadraTable</h2>
            <h2 className="mt-4 text-white">3º Lugar - Los Passaritos</h2>
          </div>
          <div className="flex flex-row items-center xl:mb-10 xl:mt-10 xl:flex-col">
            <div className="mt-4 flex flex-col items-center">
              <h2 className="text-center text-white">Vencedores Tema Web3</h2>
              <h2 className="text-white">TINC</h2>
            </div>
            <div className="mt-4 flex flex-col items-center ">
              <h2 className="text-center text-white">
                Vencedores Tema Educação
              </h2>
              <h2 className="text-white">Los Passaritos</h2>
            </div>
            <div className="mt-4 flex flex-col items-center">
              <h2 className="text-center text-white">Vencedores Tema Gaming</h2>
              <h2 className="text-white">Hack a ton of Nuts</h2>
            </div>
          </div>
        </div>
      </div>
      <div className="mt-10 flex w-1/3 flex-col items-center xl:mt-0">
        <div className="flex flex-row items-center justify-center xl:flex-col">
          <div className="mr-2 flex flex-col items-center justify-center xl:mb-10 xl:mt-10">
            <h2 className="w-max text-center text-secondary">
              Sponsor Exclusive
            </h2>
            <Image src={subvisual} alt="subvisual" className="mt-5" />
          </div>
        </div>
      </div>
    </div>
  );
}
