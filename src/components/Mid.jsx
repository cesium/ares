import Image from 'next/image';

export default function Mid() {
    return (
        <div className="max-w-screen-lg color">
            <div className="flex space-between text-4xl text-white items-center justify-end h-screen w-screen font-karrik-normal">
                <div className="mr-auto p-16 w-4/5">
                    <p className="text-4xl text-white">Mais um ano, mais uma Hackathon incrível… <br/>
                        E desta vez, o CeSIUM preparou a melhor que já viste, a BugsByte!
                        Aproveita esta oportunidade única para conviver com estudantes da área da tecnologia que partilham das mesmas paixões que tu - inovação, competição e, é claro, programação!
                        Problemas desafiantes, muito trabalho árduo, soluções fora da caixa e doses absurdas de diversão esperam-te na BugsByte. <br/>
                    </p>    
                    <p className='mt-10'><b>Reúne a tua equipa e prepara-te para dar tudo!</b></p>
                    <p className='mt-10 text-secondary'><b><a href="https://forms.gle/KxsegGxvB6psH4Gu7">Junta-te a nós</a></b></p>
                </div>
                <div className="ml-auto">
                    <Image src="/bicho.png" alt="CeSIUM Logo" width={600} height={800} />
                </div>
            </div>
        </div>
    );
}
