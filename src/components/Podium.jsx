import Lottie from 'lottie-react';
import ampulheta from '/home/mario/Cesium/ares/public/ampulheta.json';

export default function Podium() {
    return(
    <div className="h-screen w-screen flex flex-row space-between w-screen items-center text-4xl text-white font-terminal-uppercase">
        <div className="flex flex-col items-center w-1/3">
            <h1 className="text-secondary">Temas</h1>
            <div className="flex flex-row mb-10 mt-10 items-center">
                <h2 className="">Tema 1</h2>
                <Lottie animationData={ampulheta} loop={true} autoplay={true} style={{width: '50px', height: '50px'}}/>
            </div>
            <div className="flex flex-row mb-10 mt-10 items-center">
                <h2 className="">Tema 2</h2>
                <Lottie animationData={ampulheta} loop={true} autoplay={true} style={{width: '50px', height: '50px'}}/>
            </div>
            <div className="flex flex-row mb-10 mt-10 items-center">
                <h2 className="">Tema 3</h2>
                <Lottie animationData={ampulheta} loop={true} autoplay={true} style={{width: '50px', height: '50px'}}/>
            </div>
        </div>
        <div className="flex flex-col items-center w-1/3">
            <h1 className="text-secondary">Prémios</h1>
            <div className="flex flex-col mb-10 mt-10 items-center">
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
        <div className="flex flex-col items-center w-1/3">
            <h1 className='text-secondary'>Sponsors</h1>
            <div className="flex flex-row mb-10 mt-10 items-center">
                <h2 className="">Sponsor Exclusive</h2>
                <Lottie animationData={ampulheta} loop={true} autoplay={true} style={{width: '50px', height: '50px'}}/>
            </div>
            <div className="flex flex-row mb-10 mt-10 items-center">
                <h2 className="">Sponsor Gold</h2>
                <Lottie animationData={ampulheta} loop={true} autoplay={true} style={{width: '50px', height: '50px'}}/>
            </div>
            <div className="flex flex-row mb-10 mt-10 items-center">
                <h2 className="">Sponsor Gold</h2>
                <Lottie animationData={ampulheta} loop={true} autoplay={true} style={{width: '50px', height: '50px'}}/>
            </div>
        </div>
    </div>
    );
}