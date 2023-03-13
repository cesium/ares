import { motion } from "framer-motion";
import CountdownTimer from "../components/CountdownTimer";
import { useEffect, useMemo, useState } from "react";

const TextVariants = {
  offscreen: {
    opacity: 0,
  },
  onscreen: {
    opacity: 1,
  },
  exit: {
    opacity: 0,
  },
};

const letterHoverVariants = {
  hover: {
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
  const texts = useMemo(() => ["BugsByte Hackathon"], []);

  const [currentWord, setCurrentWord] = useState(-1);

  useEffect(() => {
    let i = 0;
    const interval = setInterval(() => {
      if (i === texts.length) clearInterval(interval);
      else setCurrentWord(i);
      i++;
    }, 200 + texts[i].length * 0.25);
    return () => clearInterval(interval);
  }, [texts]);

  const container = {
    visible: {
      transition: {
        staggerChildren: 0.0125,
      },
    },
  };

  const [mousePosition, setMousePosition] = useState({
    x: 0,
    y: 0,
  });
  const [cursorVariant, setCursorVariant] = useState("default");

  useEffect(() => {
    const mouseMove = (e) => {
      setMousePosition({
        x: e.clientX,
        y: e.clientY,
      });
    };

    window.addEventListener("mousemove", mouseMove);

    return () => {
      window.removeEventListener("mousemove", mouseMove);
    };
  }, []);

  const variants = {
    default: {
      height: 50,
      width: 50,
      x: mousePosition.x - 50,
      y: mousePosition.y - 50,
      backgroundColor: "green",
      mixBlendMode: "difference",
      borderRadius: "50%",
    },
    text: {
      height: 50,
      width: 50,
      x: mousePosition.x - 50,
      y: mousePosition.y - 50,
      backgroundColor: "green",
      mixBlendMode: "difference",
      borderRadius: "50%",
    },
  };

  const textEnter = () => setCursorVariant("text");
  const textLeave = () => setCursorVariant("default");

  return (
    <>
      <motion.div
        className="cursor"
        variants={variants}
        animate={cursorVariant}
      />
      <div onMouseEnter={textEnter} onMouseLeave={textLeave}>
        <motion.div
          className="sm:h-screen-sm md:h-screen-md lg:h-screen-lg xl:h-screen-xl h-screen max-h-screen overflow-hidden bg-hero text-white"
          initial="hidden"
          animate="visible"
          variants={container}
          whileHover={{
            textShadow: "0px 0px 8px rgb(0,230,0)",
          }}
          whileFocus={{ textShadow: "0px 0px 8px rgb(0,230,0)" }}
        >
          <motion.span
            className="flex h-screen flex-col items-center justify-center text-4xl text-secondary xl:text-9xl"
            transition={{ staggerChildren: 2 }}
            whileHover={{
              textShadow: "0px 0px 8px rgb(0,230,0)",
            }}
            whileFocus={{ textShadow: "0px 0px 8px rgb(0,230,0)" }}
          >
            {texts.map((word, index) =>
              index === currentWord ? (
                <motion.span key={index}>
                  {word.split("").map((r, id) => (
                    <motion.span
                      initial="offscreen"
                      animate="onscreen"
                      exit="exit"
                      variants={TextVariants}
                      whileHover={letterHoverVariants}
                      transition={{
                        duration: 2,
                        delay: id * 0.25,
                      }}
                      key={index}
                      className="font-terminal-uppercase"
                    >
                      {r}
                    </motion.span>
                  ))}
                </motion.span>
              ) : null
            )}
            <CountdownTimer targetDate={dateInFuture} />
          </motion.span>
        </motion.div>
      </div>
    </>
  );
}
