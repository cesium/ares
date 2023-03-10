import { motion } from "framer-motion";
import CountdownTimer from '@/components/CountdownTimer';
import { useEffect, useState } from "react";
const TextVariants = {
    offscreen: {
        opacity: 0
    },
    onscreen: {
        opacity: 1
    },
    exit: {
        opacity: 0
    }
};

const letterHoverVariants = {
    hover: {
      scale: 1.2,
      color: "#FF007F",
      transition: {
        duration: 0.3,
        ease: "easeInOut",
      },
    },
  };
export default function Top() {
    const FUTURE_DATE = 21.7 * 24 * 60 * 60 * 1000;
    const NOW_IN_MS = new Date().getTime();

    const dateInFuture = NOW_IN_MS + FUTURE_DATE;
    const texts = ["BugsByte Hackathon"];
    const [currentWord, setCurrentWord] = useState(-1);

    useEffect(() => {
        let i = 0;
        const interval = setInterval(() => {
            if (i === texts.length) clearInterval(interval);
            else setCurrentWord(i);
            i++;
        }, 200 + texts[i].length * 0.25);
        return () => clearInterval(interval);
    }, []);

    const container = {
        visible: {
            transition: {
                staggerChildren: 0.0125
            }
        }
    };



    return (
        <>
            <motion.div
                className="bg-black text-white h-screen max-h-screen overflow-hidden"
                initial="hidden"
                animate="visible"
                variants={container}
                whileHover={{
                    textShadow: "0px 0px 8px rgb(0,230,0)",
                }}
                whileFocus={{ textShadow: "0px 0px 8px rgb(0,230,0)" }}

            >
                <motion.span
                    className="h-screen flex flex-col items-center justify-center text-9xl text-secondary"
                    transition={{ staggerChildren: 2 }}
                    whileHover={{
                        path: "M 0 0 Q 25 -10 50 0 T 100 0",
                        transition: { duration: 0.5 },
                        letterHoverVariants 
                    }}
                >
                    {texts.map((word, index) => (
                        index === currentWord
                            ? (<motion.span>
                                {word.split("").map((r, id) => (
                                    <motion.span
                                        initial="offscreen"
                                        animate="onscreen"
                                        exit="exit"
                                        variants={TextVariants}
                                        whileHover={letterHoverVariants}
                                        transition={{
                                            duration: 2,
                                            delay: id * 0.25
                                        }}
                                        key={index}
                                        className="font-terminal-uppercase"i
                                    >
                                        {r}
                                    </motion.span>
                                ))}
                            </motion.span>
                            )
                            : null
                    ))}
                    <CountdownTimer targetDate={dateInFuture} />
                </motion.span>
            </motion.div>
        </>
    )
}