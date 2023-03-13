import React from "react";
import DateTimeDisplay from "./DateTimeDisplay";
import { useCountdown } from "../hooks/useCountdown";

const ShowCounter = ({ days, hours, minutes, seconds }) => {
  return (
    <div className="font-alarmclock-uppercase p-4 text-center text-4xl text-white xl:text-7xl">
      <div className="flex flex-row items-center justify-center">
        <DateTimeDisplay value={days} isDanger={days <= 3} />
        <p>:</p>
        <DateTimeDisplay value={hours} isDanger={false} />
        <p>:</p>
        <DateTimeDisplay value={minutes} isDanger={false} />
        <p>:</p>
        <DateTimeDisplay value={seconds} isDanger={false} />
      </div>
    </div>
  );
};

const CountdownTimer = ({ targetDate }) => {
  const [days, hours, minutes, seconds] = useCountdown(targetDate);

  if (days + hours + minutes + seconds <= 0) {
    return <ShowCounter days={0} hours={0} minutes={0} seconds={0} />;
  } else {
    return (
      <ShowCounter
        days={days}
        hours={hours}
        minutes={minutes}
        seconds={seconds}
      />
    );
  }
};

export default CountdownTimer;
