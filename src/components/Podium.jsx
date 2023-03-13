import Lottie from "lottie-react";
import ampulheta from "public/ampulheta.json";

export default function Podium() {
  return (
    <div className="space-between font-terminal-uppercase flex h-screen w-screen w-screen flex-row items-center text-4xl text-white">
      <div className="flex w-1/3 flex-col items-center">
        <h1 className="text-secondary">Temas</h1>
        <div className="mb-10 mt-10 flex flex-row items-center">
          <h2 className="">Tema 1</h2>
          <Lottie
            animationData={ampulheta}
            loop={true}
            autoplay={true}
            style={{ width: "50px", height: "50px" }}
          />
        </div>
        <div className="mb-10 mt-10 flex flex-row items-center">
          <h2 className="">Tema 2</h2>
          <Lottie
            animationData={ampulheta}
            loop={true}
            autoplay={true}
            style={{ width: "50px", height: "50px" }}
          />
        </div>
        <div className="mb-10 mt-10 flex flex-row items-center">
          <h2 className="">Tema 3</h2>
          <Lottie
            animationData={ampulheta}
            loop={true}
            autoplay={true}
            style={{ width: "50px", height: "50px" }}
          />
        </div>
      </div>
      <div className="flex w-1/3 flex-col items-center">
        <h1 className="text-secondary">Prémios por Equipa</h1>
        <div className="mb-10 mt-10 flex flex-col items-center">
          <h2 className="text-white">Vencedores Gerais</h2>
          <h2 className="text-white">1º Lugar - 600€</h2>
          <h2 className="text-white">2º Lugar - 400€</h2>
          <h2 className="text-white">3º Lugar - 200€</h2>
        </div>
        <div className="flex flex-col items-center ">
          <h2 className="text-white">Vencedores Tema 1</h2>
          <h2 className="text-white">1º Lugar - 300€</h2>
        </div>
        <div className="flex flex-col  items-center">
          <h2 className="text-white">Vencedores Tema 2</h2>
          <h2 className="text-white">1º Lugar - 300€</h2>
        </div>
        <div className="flex flex-col  items-center">
          <h2 className="text-white">Vencedores Tema 3</h2>
          <h2 className="text-white">1º Lugar - 300€</h2>
        </div>
      </div>
      <div className="flex w-1/3 flex-col items-center">
        <h1 className="text-secondary">Sponsors</h1>
        <div className="mb-10 mt-10 flex flex-row items-center">
          <h2 className="">Sponsor Exclusive</h2>
          <Lottie
            animationData={ampulheta}
            loop={true}
            autoplay={true}
            style={{ width: "50px", height: "50px" }}
          />
        </div>
        <div className="mb-10 mt-10 flex flex-row items-center">
          <h2 className="">Sponsor Gold</h2>
          <Lottie
            animationData={ampulheta}
            loop={true}
            autoplay={true}
            style={{ width: "50px", height: "50px" }}
          />
        </div>
        <div className="mb-10 mt-10 flex flex-row items-center">
          <h2 className="">Sponsor Gold</h2>
          <Lottie
            animationData={ampulheta}
            loop={true}
            autoplay={true}
            style={{ width: "50px", height: "50px" }}
          />
        </div>
      </div>
    </div>
  );
}
